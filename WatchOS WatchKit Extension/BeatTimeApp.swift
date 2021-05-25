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
    @State private var date = Date()
    @State var clock: [(String, [String])] = Clock.clock
    @State var selection: [String] = Clock.getClock()
    @State var lastSelection: [String] = Clock.getClock()
    @State private var beatsFocused = true
    @State private var hoursFocused = false
    @State private var minutesFocused = false
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selection[0], label: Text(".beats")) {
                    ForEach(0..<self.clock[0].1.count) { index in
                        Text(verbatim: "@" + self.clock[0].1[index])
                            .tag(self.clock[0].1[index])
                    }//.focusable() { )}
                }
                //.focusable() { state in print("Picker new state:\(state)")}
                .font(.title.bold())
            }
            HStack {
                Picker("Hours", selection: $selection[1]) {
                    //Text(selection[1])
                    ForEach(0..<self.clock[1].1.count) { index in
                        Text(verbatim: self.clock[1].1[index])
                            .tag(self.clock[1].1[index])
                        //.focusable(true) { state in print("Text: \(Text(verbatim: self.clock[1].1[index])) new state:\(state)") }
                    }
                }.font(.title.bold())
                //.onChange(of: selection) { time in updateTime(hours: time[1], minutes: time[2])}
                Picker("Minutes", selection: $selection[2]) {
                    //Text(selection[2])
                    ForEach(0..<self.clock[2].1.count) { index in
                        Text(verbatim: self.clock[2].1[index])
                            .tag(self.clock[2].1[index])
                    }
                }.font(.title.bold())
                //.onChange(of: selection) { time in updateTime(hours: time[1], minutes: time[2])}
            }
            //Text("Selected: \(selection[0]) \(selection[1]) \(selection[2])")
        }.onChange(of: selection) { time in
            updateClock(time)
        }
    }
    
    private func updateClock(_ selectedTime: [String]) {
        //print("Beats: \(selectedTime[0]) Hours: \(selectedTime[1]) Minutes: \(selectedTime[2])")
        if (self.lastSelection[0] != selectedTime[0]) {
            //print("New beats: \(selectedTime[0])")
            let newClock = Clock.getClock(date: BeatTime().date(beats: selectedTime[0]))
            self.selection[1] = newClock[1]
            self.selection[2] = newClock[2]
            //print("UPDATED selection Date: \(daydate) Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
        }
        else if (self.lastSelection[1] != selectedTime[1]) {
            //print("New hours: \(selectedTime[1])")
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let day = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            if let daydate = dateFormatterGet.date(from: "\(day) \(selectedTime[1]):\(lastSelection[2])") {
                let newClock = Clock.getClock(date: daydate)
                self.selection[0] = newClock[0]
                self.selection[2] = newClock[2]
                //print("UPDATED selection Date: \(daydate) Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
            }
        }
        else if (self.lastSelection[2] != selectedTime[2]) {
            //print("New minutes: \(selectedTime[2])")
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let day = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            if let daydate = dateFormatterGet.date(from: "\(day) \(lastSelection[1]):\(selectedTime[2])") {
                let newClock = Clock.getClock(date: daydate)
                self.selection[0] = newClock[0]
                self.selection[1] = newClock[1]
                //print("UPDATED selection Date: \(daydate) Beats: \(selection[0]) Hours: \(selection[1]) Minutes: \(selection[2]) current Date: \(Date())")
            }
        }
        self.lastSelection = self.selection
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
