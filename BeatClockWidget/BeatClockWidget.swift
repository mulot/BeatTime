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
        BeatEntry(date: Date(), beat: BeatClock())
    }

    func getSnapshot(in context: Context, completion: @escaping (BeatEntry) -> ()) {
        let entry = BeatEntry(date: Date(), beat: BeatClock())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [BeatEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = BeatEntry(date: entryDate, beat: BeatClock())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct BeatEntry: TimelineEntry {
    let date: Date
    let beat: BeatClock
}

struct BeatClockWidgetEntryView : View {
    var entry: BeatClockProvider.Entry

    var body: some View {
        Text(entry.beat.beatTime())
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
        BeatClockWidgetEntryView(entry: BeatEntry(date: Date(), beat: BeatClock()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
