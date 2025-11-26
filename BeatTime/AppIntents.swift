//
//  AppIntents.swift
//  BeatTime
//
//  Created by Julien Mulot on 10/06/2025.
//

import AppIntents
import SwiftUI
import WidgetKit

struct RingProgressWidget: View {
    var beats: String
    var accentColor: Color = .orange
    var lineWidth:CGFloat = 5
    
    var body: some View {
        ZStack {
            /*
            RingProgressView(arcFrag: 999, lineWidth: lineWidth)
                .foregroundColor(.circleLine)
            RingProgressView(arcFrag: Double(beats)!, lineWidth: lineWidth)
                .gradientLinear(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
            Text("@" + beats)
                //.font(.title.bold())
                .font(.title)
                .fontWeight(.semibold)
             */
            let nbHour = BeatTime.hoursOffsetWithBMT()
            let index = ((abs(nbHour)/2%6)+5)%6
            let colors:[Color] = [.mid2Gradient, .endGradient, .mid2Gradient, .midGradient, .startGradient, .midGradient]
            let gradients:[Color] = [colors[(index)%colors.count], colors[(index+1)%colors.count], colors[(index+2)%colors.count], colors[(index+3)%colors.count], colors[(index+4)%colors.count], colors[(index+5)%colors.count]]
            ProgressView(value: Double(beats)!/1000) { Text("\(beats)") }
                .progressViewStyle(.circular)
                .gradientLinear(colors: gradients, startPoint: .leading, endPoint: .trailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.bottom, 12)
    }
}

struct DisplayBeatTime: AppIntent {
    
    static let title: LocalizedStringResource = "Show .beat time"
    static let description = IntentDescription("Display the current .beat time")
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let dialog = IntentDialog("the current .beat time is \(BeatTime.beats())")
        //let entry = BeatEntry(date: Date(), beat: BeatTime.beats())
        let snippet = RingProgressWidget(beats: BeatTime.beats())
        return .result(dialog: dialog, view: snippet)
    }
}

struct ConvertTime2Beat: AppIntent {
    
    static let title: LocalizedStringResource = "Convert time to .beat"
    static let description = IntentDescription("Convert a given local time to .beat time")
    
    @Parameter(title: "Time")
    var time: Date
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let dialog = IntentDialog("converted .beat time is \(BeatTime.beats(date: time))")
        return .result(dialog: dialog)
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$time) to .beats time")
    }
}

struct ConvertBeat2Time: AppIntent {
    
    static let title: LocalizedStringResource = "Convert .beat to time"
    static let description = IntentDescription("Convert a given .beat time to local time")
    
    @Parameter(title: ".beats")
    var beats: String

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let dialog = IntentDialog("converted local time is \(DateFormatter.localizedString(from: BeatTime.date(beats: beats), dateStyle: .none, timeStyle: .short))")
        //let dialog = IntentDialog("converted local time is 12:42")
        return .result(dialog: dialog)
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$beats) to local time")
    }
}

struct BeatTimeShortcuts : AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: DisplayBeatTime(), phrases: ["Show beat in \(.applicationName)", "Show beats in \(.applicationName)", "Show Internet time in \(.applicationName)"], shortTitle: "Display .beat time", systemImageName: "clock")
        AppShortcut(intent: ConvertTime2Beat(), phrases: ["Convert time in \(.applicationName)", "Convert date in \(.applicationName)"], shortTitle: "Convert local time", systemImageName: "clock.badge.questionmark.fill")
        AppShortcut(intent: ConvertBeat2Time(), phrases: ["Convert beat in \(.applicationName)", "Convert beats in \(.applicationName)", "Convert Internet time in \(.applicationName)"], shortTitle: "Convert .beat time", systemImageName: "clock.badge.questionmark")
    }
}

