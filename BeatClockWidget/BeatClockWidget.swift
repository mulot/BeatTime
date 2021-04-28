//
//  BeatClockWidget.swift
//  BeatClockWidget
//
//  Created by Julien Mulot on 28/04/2021.
//

import WidgetKit
import SwiftUI

struct BeatClockProvider: TimelineProvider {
    func placeholder(in context: Context) -> BeatEntry {
        BeatEntry(date: Date(), beat: BeatClock().beatTime())
    }

    func getSnapshot(in context: Context, completion: @escaping (BeatEntry) -> ()) {
        let entry = BeatEntry(date: Date(), beat: BeatClock().beatTime())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [BeatEntry] = []

        // Generate a timeline consisting of five entries a minute apart, starting from the current date.
        let currentDate = Date()
        for Offset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: Offset, to: currentDate)!
            let entry = BeatEntry(date: entryDate, beat: BeatClock().beatTime(date: entryDate))
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

struct BeatClockWidgetEntryView : View {
    var entry: BeatClockProvider.Entry
    //var beatCircle: DrawingArcCircle

    var body: some View {
        Text("@\(entry.beat)")
            .foregroundColor(.blue)
            .font(.system(size: 32)
                    .bold())
    }
}

@main
struct BeatClockWidget: Widget {
    let kind: String = "BeatClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "mulot.org.BeatClock.BeatClockWidget",
            provider: BeatClockProvider()
        ) { entry in
            BeatClockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BeatClock")
        .description("Beat Internet Time widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct BeatClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        BeatClockWidgetEntryView(entry: BeatEntry(date: Date(), beat: BeatClock().beatTime()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
