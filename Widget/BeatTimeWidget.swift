//
//  BeatTimeWidget.swift
//  BeatTimeWidget
//
//  Created by Julien Mulot on 28/04/2021.
//

import WidgetKit
import SwiftUI

func hoursOffsetWithGMT(date: Date = Date()) -> Int
{
    //print(TimeZone.current.identifier)
    //print(TimeZone.abbreviationDictionary)
    //let seconds = TimeZone.init(identifier: "JST")!.secondsFromGMT(for: date)
    let seconds = TimeZone.current.secondsFromGMT(for: date)
    let hours = seconds / 3600
    //print("seconds: \(seconds) hours: \(-hours)")
    return(-hours)
}

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
    var accentColor: Color = .orange
    
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
#if os(watchOS) || os(iOS)
        case .accessoryCircular:
            if #available(iOSApplicationExtension 16.0, *) {
                let nbHour = hoursOffsetWithGMT()
                //let nbHour = -4
                let angle = (2 * Double.pi) / 24 * Double(nbHour)
                let startCircle = UnitPoint(x: 0.5, y: 1)
                //let endCircle = UnitPoint(x: 0.5, y: 1)
                //let startGradient = startCircle
                //let endGradient = endCircle
                let startGradient = UnitPoint(x: startCircle.x + 0.5*sin(angle), y: startCircle.y - 0.5*(1-cos(angle)))
                let endGradient =  UnitPoint(x: startCircle.x + 0.5*sin(angle+Double.pi), y: startCircle.y - 0.5*(1-cos(angle+Double.pi)))
                ZStack {
                    //ProgressView(value: Double(entry.beat)!/1000) { Text(entry.beat) }
                    //.progressViewStyle(.circular)
                    Gauge(value: Float(entry.beat)!/1000) { Text("@") }
                        .gaugeStyle(.accessoryCircular)
                        //.tint(accentColor)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: startGradient, endPoint: endGradient)
                    Text(entry.beat)
                }
            }
        case .accessoryInline:
            if #available(iOSApplicationExtension 16.0, *) {
                ZStack {
                    Text("@\(entry.beat) .beats")
                        .tint(accentColor)
                }
            }
        case .accessoryRectangular:
            if #available(iOSApplicationExtension 16.0, *) {
                let nbHour = hoursOffsetWithGMT()
                //let nbHour = 12
                let startCircle = UnitPoint(x: 1, y: 0.5)
                let endCircle = UnitPoint(x: 0, y: 0.5)
                let startGradient = nbHour < 12 ? startCircle : endCircle
                let endGradient = nbHour < 12 ? endCircle : startCircle
                ZStack {
                    ProgressView(value: Double(entry.beat)!/1000) { Text("@\(entry.beat) .beats") }
                        .progressViewStyle(.linear)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: startGradient, endPoint: endGradient)
                        //.tint(accentColor)
                }
            }
#endif
#if os(watchOS)
        case .accessoryCorner:
            //Gauge(value: Float(entry.beat)!/1000) { Text(entry.beat) }
            //ProgressView(value: Double(entry.beat)!/1000) { Text(entry.beat) }
            //.progressViewStyle(.automatic)
            //Image(systemName: "at.circle")
            Text(entry.beat)
                .foregroundColor(accentColor)
                .font(.title.bold())
                .widgetLabel {
                    ProgressView(value: Double(entry.beat)!/1000)
                        .tint(accentColor)
                }
#endif
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
#if os(macOS)
        return [.systemSmall]
#elseif os(watchOS)
        return [.accessoryCircular, .accessoryInline, .accessoryRectangular, .accessoryCorner]
#elseif os(iOS)
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular, .accessoryInline, .accessoryRectangular]
        }
        else {
            return [.systemSmall]
        }
#else
        return [.systemSmall]
#endif
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


#if os(macOS)
struct BeatTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif


#if os(iOS)
struct BeatTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
            //.previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                //.previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        } else {
            // Fallback on earlier versions
            BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
#endif


#if os(watchOS)
struct BeatTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
        //.previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}

struct BeatTimeWidget_Previews2: PreviewProvider {
    static var previews: some View {
        BeatTimeWidgetEntryView(entry: BeatEntry(date: Date(), beat: "849"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
#endif

