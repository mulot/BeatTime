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
            CLKComplicationDescriptor(identifier: "mulot.org.BeatClockWatchOS", displayName: "Beats Time", supportedFamilies: CLKComplicationFamily.allCases),
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
            print("*** Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .modularSmall:
            // Create a template from the modular small family.
            print("*** Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianSmall:
            // Create a template from the modular small family.
            print("*** Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianSmallFlat:
            // Create a template from the modular small family.
            print("*** Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicCircular:
            // Create a template from the modular small family.
            print("*** Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .modularLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .extraLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicCorner:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicBezel:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicRectangular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicExtraLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
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
        handler(entries)
        //handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let beatTime = BeatClock().beatTime()
        switch complication.family {
        case .circularSmall:
            // Create a template from the circular small family.
            print("*** Template Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .modularSmall:
            // Create a template from the modular small family.
            print("*** Template Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .utilitarianSmall:
            // Create a template from the modular small family.
            print("*** Template Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .utilitarianSmallFlat:
            // Create a template from the modular small family.
            print("*** Template Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .graphicCircular:
            // Create a template from the modular small family.
            print("*** Template Complication Family: \(complication.family) ***")
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .modularLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .utilitarianLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .extraLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .graphicCorner:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .graphicBezel:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .graphicRectangular:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        case .graphicExtraLarge:
            let beatProvider = CLKSimpleTextProvider(
                text: "@" + beatTime,
                shortText: beatTime)
             let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: beatProvider)
            handler(template)
        @unknown default:
            print("*** Unknown Complication Family: \(complication.family) ***")
            // Handle the error here.
            handler(nil)
        }
        //handler(nil)
    }
}
