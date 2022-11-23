//
//  BeatTimeWidget.swift
//  BeatTimeWidget
//
//  Created by Julien Mulot on 28/04/2021.
//

import WidgetKit
import SwiftUI

struct BeatTimeProvider: TimelineProvider {
    func placeholder(in context: Context) -> BeatEntry {
        BeatEntry(date: Date(), beat: BeatTime().beats())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BeatEntry) -> ()) {
        let entry = BeatEntry(date: Date(), beat: BeatTime().beats())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BeatEntry>) -> ()) {
        var entries: [BeatEntry] = []
        var entryDate: Date
        var entry: BeatEntry
        //var dialColor = Color.white
        
        // Generate a timeline consisting of five entries a minute apart, starting from the current date.
        let currentDate = Date()
        for Offset in 0 ..< 5 {
            entryDate = Calendar.current.date(byAdding: .minute, value: Offset, to: currentDate)!
            let beat = BeatTime().beats(date: entryDate)
            //print("getTimeline - Offset: \(Offset) beat: \(beat)")
            /*
             if (Int(beat) != nil) {
             if (Int(beat)! <= 250 || Int(beat)! >= 750) {
             dialColor = Color.gray
             }
             else {
             dialColor = Color.white
             }
             }
             */
            entry = BeatEntry(date: entryDate, beat: beat)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct BeatEntry: TimelineEntry {
    let date: Date
    let beat: String
}

struct BeatTimeWidgetEntryView : View {
    var entry: BeatTimeProvider.Entry
    
    @Environment(\.widgetFamily) var family
    //@Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var body: some View {
            switch family {
            case .systemSmall:
                ZStack {
                    RingProgressView(arcFrag: 999, lineWidth: 10)
                        .foregroundColor(.circleLine)
                    RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: 10)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                    Text("@" + entry.beat)
                        .font(.title.bold())
                }
            case .systemMedium:
                ZStack {
                    RingProgressView(arcFrag: 999, lineWidth: 10)
                        .foregroundColor(.circleLine)
                    RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: 10)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                    Text("@" + entry.beat)
                        .font(.title.bold())
                }
            case .systemLarge:
                ZStack {
                    RingProgressView(arcFrag: 999, lineWidth: 20)
                        .foregroundColor(.circleLine)
                    RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: 20)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                    Text("@" + entry.beat)
                        .font(.title.bold())
                }
            case .systemExtraLarge:
                ZStack {
                    RingProgressView(arcFrag: 999, lineWidth: 25)
                        .foregroundColor(.circleLine)
                    RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: 25)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                    Text("@" + entry.beat)
                        .font(.title.bold())
                }
            case .accessoryCircular:
                ZStack {
                    ProgressView(value: Double(entry.beat)!/1000) { Text(entry.beat) }
                        .progressViewStyle(.circular)
                }
            case .accessoryInline:
                ZStack {
                    Text("@\(entry.beat) .beats")
                }
            case .accessoryRectangular:
                ZStack {
                    ProgressView(value: Double(entry.beat)!/1000) { Text("@\(entry.beat) .beats") }
                        .progressViewStyle(.linear)
                }
            default:
                ZStack {
                    RingProgressView(arcFrag: 999, lineWidth: 10)
                        .foregroundColor(.circleLine)
                    RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: 10)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                    Text("@" + entry.beat)
                        .font(.title.bold())
                }
            }
    }
}



@main
struct BeatTimeWidget: Widget {
        let kind: String = "BeatTimeWidget"
        
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular, .accessoryInline, .accessoryRectangular]
        }
        else {
           return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
            //if #available(iOSApplicationExtension 16.0, *) {
            StaticConfiguration(
                kind: "org.mulot.beattime.BeatTimeWidget",
                provider: BeatTimeProvider()
            ) { entry in
                BeatTimeWidgetEntryView(entry: entry)
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color("WidgetBackground"))
                //.background(Color.black)
                //.foregroundColor(.gray)
            }
            .configurationDisplayName("BeatTime")
            .description("Swatch Internet Time aka .beat time")
            .supportedFamilies(supportedFamilies)
        }
}

struct BeatTimeWidgetDeprecated: Widget {
    let kind: String = "BeatTimeWidget"
    
    var body: some WidgetConfiguration {
        //if #available(iOSApplicationExtension 16.0, *) {
        StaticConfiguration(
            kind: "org.mulot.beattime.BeatTimeWidget",
            provider: BeatTimeProvider()
        ) { entry in
            BeatTimeWidgetEntryView(entry: entry)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color("WidgetBackground"))
            //.background(Color.black)
            //.foregroundColor(.gray)
        }
        .configurationDisplayName("BeatTime")
        .description("Swatch Internet Time aka .beat time")
        .supportedFamilies([.systemSmall])
    }
}


struct BeatTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                //.previewContext(WidgetPreviewContext(family: .accessoryCircular))
        } else {
            // Fallback on earlier versions
            BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}


