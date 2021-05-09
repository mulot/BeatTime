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
        BeatEntry(date: Date(), beat: BeatClock().beatTime(), dialColor: Color.white)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BeatEntry) -> ()) {
        let entry = BeatEntry(date: Date(), beat: BeatClock().beatTime(), dialColor: Color.white)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BeatEntry>) -> ()) {
        var entries: [BeatEntry] = []
        var entryDate: Date
        var entry: BeatEntry
        var dialColor = Color.white
        
        // Generate a timeline consisting of five entries a minute apart, starting from the current date.
        let currentDate = Date()
        for Offset in 0 ..< 5 {
            entryDate = Calendar.current.date(byAdding: .minute, value: Offset, to: currentDate)!
            let beat = BeatClock().beatTime(date: entryDate)
            if (Int(beat) != nil) {
                if (Int(beat)! <= 250 || Int(beat)! >= 750) {
                    dialColor = Color.gray
                }
                else {
                    dialColor = Color.white
                }
            }
            entry = BeatEntry(date: entryDate, beat: beat, dialColor: dialColor)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct BeatEntry: TimelineEntry {
    let date: Date
    let beat: String
    let dialColor: Color
}

struct BeatClockWidgetEntryView : View {
    var entry: BeatClockProvider.Entry
    
    var body: some View {
        ZStack {
            Circle().fill(entry.dialColor)
                .frame(maxWidth: 150, maxHeight:150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack {
                Text("@\(entry.beat)")
                    //.foregroundColor(.accentColor)
                    //.foregroundColor(.orange)
                    .font(.system(size: 32)
                            .bold())
                Text(DateFormatter.localizedString(from: entry.date, dateStyle: .none, timeStyle: .short))
                    .font(.headline)
            }
        }
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("BeatClock")
        .description("Beat Internet Time widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct BeatClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        BeatClockWidgetEntryView(entry: BeatEntry(date: Date(), beat: "342", dialColor: Color.white))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

/*
 struct BeatClockView: View {
 typealias Body = type
 
 }
 */
