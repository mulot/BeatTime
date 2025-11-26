//
//  BeatTimeWidgetMain.swift
//  BeatTime
//
//  Created by Julien Mulot on 10/06/2025.
//

import WidgetKit
import SwiftUI

@main
struct BeatTimeWidget: Widget {
    let kind: String = "BeatTimeWidget"
    
    private let supportedFamilies:[WidgetFamily] = {
#if os(macOS)
        return [.systemSmall, .systemLarge]
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
        //.contentMarginsDisabled()
    }
}
