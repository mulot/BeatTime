//
//  BeatTimeApp.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI
import os

enum Hours: Int, CaseIterable, Identifiable {
    case zero = 0
    case one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirtheen, fourthteen, fifthteen, sixteen, seventeen, eigthteen, nineteen, twenty, twenty_one, twenty_two, twenty_three, twenty_four
    
    var id: Int { self.rawValue }
}

@main
struct BeatTimeApp: App {
    @WKExtensionDelegateAdaptor private var appDelegate: ExtensionDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    let logger = Logger(subsystem: "mulot.org.BeatTimeWatchOS.watchkitapp.watchkitextension.App", category: "App View")
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                ConvertView()
            }.tabViewStyle(PageTabViewStyle())
        }.onChange(of: scenePhase) { (phase) in
            switch phase {
            case .inactive:
                logger.debug("Scene became inactive.")
            case .active:
                logger.debug("Scene became active.")
            case .background:
                logger.debug("Scene moved to the background.")
                // Schedule a background refresh task
                // to update the complications.
                scheduleBAR(first: true)
            @unknown default:
                logger.debug("Scene entered unknown state.")
                assertionFailure()
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "mulot.org.BeatTime.time")
    }
}

struct Clock {
    static let clock: [(String, [String])] = [
        ("Beats", Array(0...999).map{"@\($0)"}),
        ("Hour", Array(0...23).map{"\($0)"}),
        ("Minute", Array(0...59).map{"\(String(format: "%02d",$0))"})
    ]
    
    static func currentClock(date: Date = Date()) -> [String] {
        let beats:String = "@\(BeatTime().beats())"
        var hours:String = "\(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short).split(separator: ":", omittingEmptySubsequences: true)[0])"
        let minutes:String = "\(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short).split(separator: ":", omittingEmptySubsequences: true)[1].split(separator: " ")[0])"
        let ampm: String = "\(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short).split(separator: " ", omittingEmptySubsequences: true)[1])"
        
        if (ampm == "PM") {
            if let digitHours = Int(hours) {
                hours = String(digitHours + 12)
            }
        }
        return [beats, hours, minutes]
    }
}

struct ConvertView: View {
    @State private var date = Date()
    @State var clock: [(String, [String])] = Clock.clock
    @State var selection: [String] = Clock.currentClock()
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selection[0], label: Text(".beats")) {
                    ForEach(0..<self.clock[0].1.count) { index in
                        Text(verbatim: self.clock[0].1[index])
                            .tag(self.clock[0].1[index])
                    }
                }.font(.title.bold())
            }
            HStack {
                Picker("Hours", selection: $selection[1]) {
                    //Text(selection[1])
                    ForEach(0..<self.clock[1].1.count) { index in
                        Text(verbatim: self.clock[1].1[index])
                            .tag(self.clock[1].1[index])
                    }
                }.font(.title.bold())
                Picker("Minutes", selection: $selection[2]) {
                    //Text(selection[2])
                    ForEach(0..<self.clock[2].1.count) { index in
                        Text(verbatim: self.clock[2].1[index])
                            .tag(self.clock[2].1[index])
                    }
                }.font(.title.bold())
            }
            Text("Selected: \(selection[0]) \(selection[1]) \(selection[2])")
        }
    }
}

struct ContentView: View {
    let fgColors: [Color] = [.orange, .gray, .red, .yellow, .green, .blue, .purple, .pink]
    @State private var index = 0.0
    @State var beats: String = BeatTime().beats()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //@State private var fgColor = Color.gray
    
    var body: some View {
        ZStack {
            DrawingArcCircle(arcFrag: 999)
                .foregroundColor(.circleLine)
            //BeatTimeView()
            DrawingArcCircle(arcFrag: Double(beats)!)
                .foregroundColor(fgColors[Int(index)])
            Text("@" + beats)
                .font(.title.bold())
                .foregroundColor(fgColors[Int(index)])
                //.background(Color.black)
                /*
                 .onTapGesture(perform: {
                 fgColor = fgColors[index]
                 index += 1
                 if (index >= fgColors.count) {
                 index = 0
                 }
                 })
                 */
                //Text("Index : \(index)")
                .focusable()
                .digitalCrownRotation($index, from: 0, through: Double((fgColors.count - 1)), by: 1, sensitivity: .low, isContinuous: true, isHapticFeedbackEnabled: true)
        }.onReceive(timer) { _ in
            beats = BeatTime().beats()
        }
    }
}

struct Content_Preview: PreviewProvider {
    static var previews: some View {
        TabView {
            ContentView()
            ConvertView()
        }.tabViewStyle(PageTabViewStyle())
    }
}

struct Convert_Preview: PreviewProvider {
    static var previews: some View {
        ConvertView()
    }
}
