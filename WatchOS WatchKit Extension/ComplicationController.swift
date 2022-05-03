//
//  ComplicationController.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import ClockKit

extension ComplicationController {
  func makeTemplate(for beatTime: String, complication: CLKComplication) -> CLKComplicationTemplate? {
    var beatProvider = CLKSimpleTextProvider(
        text: "@" + beatTime,
        shortText: beatTime)
    
    switch complication.family {
    case .circularSmall:
        // Create a template from the circular small family.
        return CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
    case .modularSmall:
        // Create a template from the modular small family.
        return CLKComplicationTemplateModularSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
    case .modularLarge:
        // Create a template from the modular Large.
        let dateProvider = CLKSimpleTextProvider(
            text: "Local time " + DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short),
            shortText: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
        return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, body2TextProvider: dateProvider)
    case .utilitarianSmall:
        // Create a template from the utilitarian small family.
        beatProvider = CLKSimpleTextProvider(
            text: "@" + beatTime,
            shortText: "@")
        return CLKComplicationTemplateUtilitarianSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
    case .utilitarianSmallFlat:
        // Create a template from the utilitarian small flat family.
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: beatProvider)
    case .graphicCircular:
        // Create a template from the graphic Circular family.
      return CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: gaugeColor, fillFraction: (Float(beatTime)!/1000)), centerTextProvider: beatProvider)
    case .graphicRectangular:
        // Create a template from the graphic Rectangular family.
        return CLKComplicationTemplateGraphicRectangularTextGauge(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: gaugeColor, fillFraction: (Float(beatTime)!/1000)))
    case .graphicCorner:
        // Create a template from the graphic Corner family.
        return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: gaugeColor, fillFraction: (Float(beatTime)!/1000)), outerTextProvider: beatProvider)
    case .extraLarge:
        // Create a template from the extra large watch face.
        return CLKComplicationTemplateExtraLargeRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
    case .graphicExtraLarge:
        // Create a template from the graphic extra large watch face.
        return CLKComplicationTemplateGraphicExtraLargeCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: gaugeColor, fillFraction: (Float(beatTime)!/1000)), centerTextProvider: beatProvider)
    default:
      return nil
    }
  }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    private let beatSample = "642"
    private let gaugeColor = UIColor.orange
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "org.mulot.beattime.BeatTimeWatchOS", displayName: "Beats Time", supportedFamilies: [.circularSmall, .modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat, .graphicCircular, .graphicRectangular, .graphicCorner, .extraLarge, .graphicExtraLarge]),
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        //handler(Date.distantFuture)
        handler(Date().addingTimeInterval(60.0 * 60.0))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let beatTime = BeatTime().beats()
        if let template = makeTemplate(for: beatTime, complication: complication) {
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        }
        else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        var entries: [CLKComplicationTimelineEntry] = []
        var entry: CLKComplicationTimelineEntry
        var current = date.addingTimeInterval(60.0)
        let endDate = date.addingTimeInterval(60.0 * 60.0)
        
        //print("Limit: \(limit) Date:" + DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short))
        // Generate a timeline consisting of five entries a minute apart, starting from the date.
        while ((current.compare(endDate) == .orderedAscending) && (entries.count < limit)) {
            let beatTime = BeatTime().beats(date: current)
            //print("Entry Date:" + DateFormatter.localizedString(from: current, dateStyle: .short, timeStyle: .short) + " Beats: \(beatTime)")
            if let template = makeTemplate(for: beatTime, complication: complication) {
                entry = CLKComplicationTimelineEntry(date: current, complicationTemplate: template)
                entries.append(entry)
                current = current.addingTimeInterval(60.0)
            }
        }
        handler(entries)
        //handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if let template = makeTemplate(for: beatSample, complication: complication) {
            handler(template)
        }
        else {
            handler(nil)
        }
        //handler(nil)
    }
}
