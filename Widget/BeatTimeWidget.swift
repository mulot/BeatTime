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

#if os(watchOS) || os(iOS)
struct InlineWidget : View {
    var entry: BeatTimeProvider.Entry
    var accentColor: Color = .orange
    
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            ZStack {
                Text("@\(entry.beat) .beats")
                    .tint(accentColor)
            }
        }
    }
}
#endif

struct RingProgressWidgetSystem : View {
    var entry: BeatTimeProvider.Entry
    var accentColor: Color = .orange
    var lineWidth:CGFloat = 10
    
    var body: some View {
        ZStack {
            RingProgressView(arcFrag: 999, lineWidth: lineWidth)
                .foregroundColor(.circleLine)
            RingProgressView(arcFrag: Double(entry.beat)!, lineWidth: lineWidth)
                .gradientLinear(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
            Text("@" + entry.beat)
                .font(.title.bold())
        }
    }
}

#if os(watchOS) || os(iOS)
struct GaugeWidget : View {
    var entry: BeatTimeProvider.Entry
    var accentColor: Color = .orange
    
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            let nbHour = BeatTime.hoursOffsetWithGMT()
            //let nbHour = 4
            let angle = (2 * Double.pi) / 24 * Double(nbHour)
            let startCircle = UnitPoint(x: 0.5, y: 1)
            //let endCircle = UnitPoint(x: 0.5, y: 1)
            //let startGradient = startCircle
            //let endGradient = endCircle
#if os(watchOS)
            let startGradient = UnitPoint(x: startCircle.x + 0.5*sin(angle), y: startCircle.y - 0.5*(1-cos(angle)))
            let endGradient =  UnitPoint(x: startCircle.x + 0.5*sin(angle+Double.pi), y: startCircle.y - 0.5*(1-cos(angle+Double.pi)))
#endif
            ZStack {
                //ProgressView(value: Double(entry.beat)!/1000) { Text(entry.beat) }
                //.progressViewStyle(.circular)
                Gauge(value: Float(entry.beat)!/1000) { Text("@") }
                    .gaugeStyle(.accessoryCircular)
                //.tint(accentColor)
#if os(watchOS)
                    .gradientLinear(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: startGradient, endPoint: endGradient)
#endif
#if os(iOS)
                    .tint(accentColor)
#endif
                Text(entry.beat)
            }
        }
    }
}
#endif

struct RectangularsWidget : View {
    var entry: BeatTimeProvider.Entry
    var accentColor: Color = .orange
    
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            let nbHour = BeatTime.hoursOffsetWithGMT()
            //let nbHour = -4
            let gmt:String = nbHour > 0 ? "+\(nbHour)" : "\(nbHour)"
            let index = ((abs(nbHour)/2%6)+5)%6
            let colors:[Color] = [.mid2Gradient, .endGradient, .mid2Gradient, .midGradient, .startGradient, .midGradient]
#if os(watchOS)
            let gradients:[Color] = [colors[(index)%colors.count], colors[(index+1)%colors.count], colors[(index+2)%colors.count], colors[(index+3)%colors.count], colors[(index+4)%colors.count], colors[(index+5)%colors.count]]
#endif
            ZStack {
                ProgressView(value: Double(entry.beat)!/1000) { Text("@\(entry.beat) .beats GMT\(gmt)") }
                    .progressViewStyle(.linear)
#if os(watchOS)
                    .gradientLinear(colors: gradients, startPoint: .leading, endPoint: .trailing)
#endif
#if os(iOS)
                    .tint(accentColor)
#endif
                //.gradientRadius(colors: gradients, center: centerPoint, startRadius: 10, endRadius: 90)
                //.tint(accentColor)
            }
        }
    }
}

#if os(watchOS)
struct CornerWidget : View {
    var entry: BeatTimeProvider.Entry
    var accentColor: Color = .orange
    
    var body: some View {
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
    }
}
#endif

struct BeatTimeWidgetEntryView : View {
    var entry: BeatTimeProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: RingProgressWidgetSystem(entry: entry)
        case .systemMedium: RingProgressWidgetSystem(entry: entry)
        case .systemLarge: RingProgressWidgetSystem(entry: entry, lineWidth: 20)
        case .systemExtraLarge: RingProgressWidgetSystem(entry: entry, lineWidth: 25)
#if os(watchOS) || os(iOS)
        case .accessoryCircular: GaugeWidget(entry: entry)
        case .accessoryInline: InlineWidget(entry: entry)
        case .accessoryRectangular: RectangularsWidget(entry: entry)
#endif
#if os(watchOS)
        case .accessoryCorner: CornerWidget(entry: entry)
#endif
        default: RingProgressWidgetSystem(entry: entry)
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
        StaticConfiguration(
            kind: "org.mulot.beattime.BeatTimeWidget",
            provider: BeatTimeProvider()
        ) { entry in
            BeatTimeWidgetEntryView(entry: entry)
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

