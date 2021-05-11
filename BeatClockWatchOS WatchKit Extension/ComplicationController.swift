//
//  ComplicationController.swift
//  BeatClockWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "mulot.org.BeatClockWatchOS", displayName: "Beats Time", supportedFamilies: [.circularSmall, .modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat, .graphicCircular, .graphicRectangular]),
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
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let beatTime = BeatClock().beatTime()
        switch complication.family {
        case .circularSmall:
            // Create a template from the circular small family.
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .modularSmall:
            // Create a template from the modular small family.
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateModularSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianSmall:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: "@")
            let template = CLKComplicationTemplateUtilitarianSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianSmallFlat:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicCircular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.orange, fillFraction: (Float(beatTime)!/1000)), centerTextProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .modularLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let dateProvider = CLKSimpleTextProvider(
                text: "Local time " + DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short),
                shortText: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
             let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, body2TextProvider: dateProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicRectangular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateGraphicRectangularTextGauge(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.orange, fillFraction: (Float(beatTime)!/1000)))
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianLarge:
            handler(nil)
        case .extraLarge:
            handler(nil)
        case .graphicCorner:
            handler(nil)
        case .graphicBezel:
            handler(nil)
        case .graphicExtraLarge:
            handler(nil)
        @unknown default:
            print("*** Unknown Complication Family: \(complication.family) ***")
            // Handle the error here.
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        var entries: [CLKComplicationTimelineEntry] = []
        var entryDate: Date
        var entry: CLKComplicationTimelineEntry
        
        // Generate a timeline consisting of five entries a minute apart, starting from the current date.
        for Offset in 0 ..< 5 {
            entryDate = Calendar.current.date(byAdding: .minute, value: Offset, to: date)!
            let beatTime = BeatClock().beatTime(date: entryDate)
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            entries.append(entry)
        }
        //handler(entries)
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let beatTime = BeatClock().beatTime()
        switch complication.family {
        case .circularSmall:
            // Create a template from the circular small family.
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .modularSmall:
            // Create a template from the modular small family.
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateModularSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
            handler(template)
        case .utilitarianSmall:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: "@")
            let template = CLKComplicationTemplateUtilitarianSmallRingText(textProvider: beatProvider, fillFraction: (Float(beatTime)!/1000), ringStyle: CLKComplicationRingStyle.closed)
            handler(template)
        case .utilitarianSmallFlat:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: beatProvider)
            handler(template)
        case .graphicCircular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.orange, fillFraction: (Float(beatTime)!/1000)), centerTextProvider: beatProvider)
            handler(template)
        case .modularLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let dateProvider = CLKSimpleTextProvider(
                text: "Local time " + DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short),
                shortText: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
             let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, body2TextProvider: dateProvider)
            handler(template)
        case .graphicRectangular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
            let template = CLKComplicationTemplateGraphicRectangularTextGauge(headerTextProvider: CLKSimpleTextProvider(text: "@Beats"), body1TextProvider: beatProvider, gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: UIColor.orange, fillFraction: (Float(beatTime)!/1000)))
            handler(template)
        case .utilitarianLarge:
            handler(nil)
        case .extraLarge:
            handler(nil)
        case .graphicCorner:
            handler(nil)
        case .graphicBezel:
            handler(nil)
        case .graphicExtraLarge:
            handler(nil)
        @unknown default:
            print("*** Unknown Complication Family: \(complication.family) ***")
            // Handle the error here.
            handler(nil)
        }
        //handler(nil)
    }
}
