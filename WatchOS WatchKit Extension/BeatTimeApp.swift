//
//  BeatTimeApp.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI
import os

@main
struct BeatTimeApp: App {
    @WKExtensionDelegateAdaptor private var appDelegate: ExtensionDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    let logger = Logger(subsystem: "org.mulot.beattime.BeatTimeWatchOS.watchkitapp.watchkitextension.App", category: "App View")
    
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
        WKNotificationScene(controller: NotificationController.self, category: "org.mulot.beattime.time")
    }
}

struct Clock {
    static let clock: [(String, [String])] = [
        ("Beats", Array(0...999).map{"\($0)"}),
        ("Hour", Array(0...23).map{"\($0)"}),
        ("Minute", Array(0...59).map{"\(String(format: "%02d",$0))"})
    ]
    
    static func getClock(date: Date = Date()) -> [String] {
        let beats:String = "\(BeatTime().beats(date: date))"
        //print("getClock Date: \(date) Beats: \(beats) Beatime: \(BeatTime().beats(date: date))")
        var hours:String = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short).split(separator: ":", omittingEmptySubsequences: true)[0])"
        let minutes:String = "\(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short).split(separator: ":", omittingEmptySubsequences: true)[1].split(separator: " ")[0])"
        let ampm: [Substring] = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short).split(separator: " ", omittingEmptySubsequences: true)
        
        if (hours.hasPrefix("0")) {
            hours.removeFirst()
        }
        if (ampm.count == 2) {
            if (ampm[1] == "PM") {
                if let digitHours = Int(hours) {
                    if (digitHours == 12) {
                        hours = "12"
                    }
                    else {
                        hours = String(digitHours + 12)
                    }
                }
            }
            else if (ampm[1] == "AM") {
                if let digitHours = Int(hours) {
                    if (digitHours == 12) {
                        hours = "0"
                    }
                }
            }
        }
        return [beats, hours, minutes]
    }
}

struct ConvertView: View {
    var clock: [(String, [String])] = Clock.clock
    @State var selection: [String] = Clock.getClock()
    @State var lastSelection: [String] = Clock.getClock()
    let logger = Logger(subsystem: "org.mulot.beattime.BeatTimeWatchOS.watchkitapp.watchkitextension.App", category: "ConvertView")
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selection[0], label: Text(".beats")) {
                    ForEach(0..<self.clock[0].1.count) { index in
                        Text(verbatim: "@" + self.clock[0].1[index])
                            .tag(self.clock[0].1[index])
                    }
                }
                .font(.title.bold())
            }
            HStack {
                Picker("Hours", selection: $selection[1]) {
                    ForEach(0..<self.clock[1].1.count) { index in
                        Text(verbatim: self.clock[1].1[index])
                            .tag(self.clock[1].1[index])
                    }
                }.font(.title.bold())
                Picker("Minutes", selection: $selection[2]) {
                    ForEach(0..<self.clock[2].1.count) { index in
                        Text(verbatim: self.clock[2].1[index])
                            .tag(self.clock[2].1[index])
                    }
                }.font(.title.bold())
            }
        }.onChange(of: selection) { time in
            updateClock(time)
        }
    }
    
    private func updateClock(_ selectedTime: [String]) {
        logger.debug("updateclock Beats: \(selectedTime[0]) Hours: \(selectedTime[1]) Minutes: \(selectedTime[2])")
        if (self.lastSelection[0] != selectedTime[0]) {
            let newClock = Clock.getClock(date: BeatTime().date(beats: selectedTime[0]))
            self.selection[1] = newClock[1]
            self.selection[2] = newClock[2]
            logger.debug("Updated selection:  Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
        }
        else if (self.lastSelection[1] != selectedTime[1]) {
            logger.debug("updateclock hours: \(selectedTime[1])")
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let day = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            if let daydate = dateFormatterGet.date(from: "\(day) \(selectedTime[1]):\(lastSelection[2])") {
                let newClock = Clock.getClock(date: daydate)
                self.selection[0] = newClock[0]
                self.selection[2] = newClock[2]
                logger.debug("Updated selection Date: \(daydate) Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
            }
        }
        else if (self.lastSelection[2] != selectedTime[2]) {
            logger.debug("updateclock minutes: \(selectedTime[2])")
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let day = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            if let daydate = dateFormatterGet.date(from: "\(day) \(lastSelection[1]):\(selectedTime[2])") {
                let newClock = Clock.getClock(date: daydate)
                self.selection[0] = newClock[0]
                self.selection[1] = newClock[1]
                logger.debug("Updated selection Date: \(daydate) Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
            }
        }
        self.lastSelection = self.selection
    }
}

struct ContentView: View {
    let fgColors: [Color] = [.orange, .gray, .red, .yellow, .green, .blue, .purple, .pink]
    @SceneStorage("ContentView.color") private var index:Double = 0.0
    @State var beats: String = "0"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            ZStack (alignment: .center) {
                /*
                 //Draw Progress View
                 DrawingArcCircle(arcFrag: 999)
                 .foregroundColor(.circleLine)
                 DrawingArcCircle(arcFrag: Double(beats)!)
                 .foregroundColor(fgColors[Int(index.rounded())])
                 */
                ProgressView(value: Double(beats)!/1000)
                    .progressViewStyle(CircularProgressViewStyle(tint: fgColors[Int(index.rounded())]))
                    //.scaledToFit()
                    .frame(width: frame.width, height: frame.height, alignment: .center)
                    .scaleEffect(3.2, anchor: .center)
                    .onAppear() {
                        withAnimation(.default.speed(0.25)) {
                            self.beats = BeatTime().beats()
                            print("animation on Appear")
                        }
                    }
                Text("@" + beats)
                    .font(.title.bold())
                    .foregroundColor(fgColors[Int(index.rounded())])
                //Text("Index : \(index)")
            }
            .focusable()
            .digitalCrownRotation($index, from: 0, through: Double((fgColors.count - 1)), by: 1.0, sensitivity: .low, isContinuous: true, isHapticFeedbackEnabled: true)
            .onReceive(timer) { _ in
                beats = BeatTime().beats()
            }
            /*
             .onTapGesture(perform: {
             fgColor = fgColors[index]
             index += 1
             if (index >= fgColors.count) {
             index = 0
             }
             })
             */
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
        TabView {
            ConvertView()
            ContentView()
        }.tabViewStyle(PageTabViewStyle())
    }
}
