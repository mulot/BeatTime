//
//  AppIntents.swift
//  BeatTime
//
//  Created by Julien Mulot on 10/06/2025.
//

/// App Intents and related SwiftUI snippet views for BeatTime.
///
/// This file defines:
/// - `RingProgressWidget`: A SwiftUI view that renders a circular progress indicator for the current .beat value.
/// - `DisplayBeatTime`: An App Intent that shows the current .beat time with a dialog and a snippet view.
/// - `ConvertTime2Beat`: An App Intent that converts a provided local `Date` to .beat time.
/// - `ConvertBeat2Time`: An App Intent that converts a .beat string to local time and presents it.
/// - `BeatTimeShortcuts`: App shortcuts that expose the above intents to the system.

import AppIntents
import SwiftUI
import WidgetKit

/// A circular progress snippet view that visualizes the current .beat value.
///
/// The view displays a circular `ProgressView` with a color gradient that
/// changes based on the current hour offset from BMT (Biel Mean Time).
/// The center label shows the .beat value.
///
/// - Note: `beats` must be a numeric string representing a value in the range 0...999.
struct RingProgressWidget: View {
    /// The .beat value to display, as a string (e.g., "@123").
    /// Only the numeric portion is used for progress calculation.
    var beats: String
    /// Accent color used by the view (currently unused in the body).
    var accentColor: Color = .orange
    /// The ring line width used by the legacy ring implementation.
    /// Retained for compatibility with previous designs.
    var lineWidth:CGFloat = 5
    
    /// Builds the circular progress snippet view.
    ///
    /// - Returns: A view rendering a circular progress indicator annotated with the current .beat value.
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
        //.padding(.bottom, 12)
    }
}

/// An App Intent that presents the current .beat time.
///
/// Displays a dialog containing the current .beat time and shows a snippet
/// view (`RingProgressWidget`) that visualizes the value.
struct DisplayBeatTime: AppIntent {
    
    static let title: LocalizedStringResource = "Show .beat time"
    static let description = IntentDescription("Display the current .beat time")
    
    @MainActor
    /// Executes the intent.
    ///
    /// - Returns: An intent result that provides a spoken/text dialog and a snippet view.
    /// - Throws: Rethrows any errors from intent execution.
    /// - Note: Runs on the main actor to create SwiftUI views.
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let dialog = IntentDialog("the current .beat time is \(BeatTime.beats())")
        //let entry = BeatEntry(date: Date(), beat: BeatTime.beats())
        let snippet = RingProgressWidget(beats: BeatTime.beats())
        return .result(dialog: dialog, view: snippet)
    }
}

/// An App Intent that converts a provided local time (`Date`) to .beat time.
///
/// Prompts the user for a `Date` parameter and responds with a dialog
/// containing the computed .beat representation.
struct ConvertTime2Beat: AppIntent {
    
    static let title: LocalizedStringResource = "Convert time to .beat"
    static let description = IntentDescription("Convert a given local time to .beat time")
    
    /// The local date and time to convert to .beat time.
    @Parameter(title: "Time")
    var time: Date
    
    @MainActor
    /// Executes the conversion from `time` to .beat.
    ///
    /// - Returns: An intent result that provides a dialog with the converted .beat value.
    /// - Throws: Rethrows any errors from intent execution.
    /// - Note: Runs on the main actor for UI-related work.
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let dialog = IntentDialog("converted .beat time is \(BeatTime.beats(date: time))")
        return .result(dialog: dialog)
    }
    
    /// Describes how parameters are summarized in the shortcuts UI.
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$time) to .beats time")
    }
}

/// An App Intent that converts a .beat string to local time.
///
/// Accepts a string representing .beats and responds with a dialog
/// showing the localized short time string.
struct ConvertBeat2Time: AppIntent {
    
    static let title: LocalizedStringResource = "Convert .beat to time"
    static let description = IntentDescription("Convert a given .beat time to local time")
    
    /// The .beat value to convert (e.g., "123").
    ///
    /// - Important: The string must be parseable by `BeatTime.date(beats:)`.
    @Parameter(title: ".beats")
    var beats: String

    @MainActor
    /// Executes the conversion from `.beats` to a localized time string.
    ///
    /// - Returns: An intent result that provides a dialog with the converted local time.
    /// - Throws: Rethrows any errors from intent execution.
    /// - Note: Runs on the main actor for UI-related work.
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let dialog = IntentDialog("converted local time is \(DateFormatter.localizedString(from: BeatTime.date(beats: beats), dateStyle: .none, timeStyle: .short))")
        //let dialog = IntentDialog("converted local time is 12:42")
        return .result(dialog: dialog)
    }
    
    /// Describes how parameters are summarized in the shortcuts UI.
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$beats) to local time")
    }
}

/// Provides App Shortcuts for the BeatTime intents.
///
/// Registers shortcuts for displaying the current .beat time and converting
/// between local time and .beats.
struct BeatTimeShortcuts : AppShortcutsProvider {
    /// The list of shortcuts exposed to the system.
    ///
    /// - Returns: Three shortcuts for display and conversion intents.
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: DisplayBeatTime(), phrases: ["Show beat in \(.applicationName)", "Show beats in \(.applicationName)", "Show Internet time in \(.applicationName)"], shortTitle: "Display .beat time", systemImageName: "clock")
        AppShortcut(intent: ConvertTime2Beat(), phrases: ["Convert time in \(.applicationName)", "Convert date in \(.applicationName)"], shortTitle: "Convert local time", systemImageName: "clock.badge.questionmark.fill")
        AppShortcut(intent: ConvertBeat2Time(), phrases: ["Convert beat in \(.applicationName)", "Convert beats in \(.applicationName)", "Convert Internet time in \(.applicationName)"], shortTitle: "Convert .beat time", systemImageName: "clock.badge.questionmark")
    }
}

