//
//  BeatTimeiOSApp.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI
import SwiftData

//let notificationCenter = UNUserNotificationCenter.current()
@MainActor let notifManager = LocalNotificationManager()
@MainActor let alarmManager = AlarmModel()

@main
struct BeatTimeiOSApp: App {
    //let fgColors: [Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .pink]
    //@State private var fgColor: Color = .gray
    //@State private var index = 1
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Notification.self)
            //BeatTimeView(lineWidth:onde 25)
            /*
             .background(Color.black)
             .foregroundColor(fgColor)
             .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
             .edgesIgnoringSafeArea(.all)
             */
        }
    }
}

struct ContentView: View {
    @State var showConvert = false
    @State var showSettings = false
    @State var showAlarm = false
    @State var bgCircleColor = Color.circleLine
    @SceneStorage("ContentView.isCentiBeats") var isCentiBeats = false
    @SceneStorage("ContentView.isFullCircleBg") var isFullCircleBg = true
    @SceneStorage("ContentView.isFullDigits") var isFullDigits = false
    @SceneStorage("ContentView.isFollowSun") var isFollowSun = true
    @SceneStorage("ContentView.alarmByDefault") var alarmByDefault = true
    @SceneStorage("ContentView.notifByDefault") var notifByDefault = false
    
    var body: some View {
        VStack {
            HStack{
                Button(action: { self.showSettings.toggle() }) {
                    Image(systemName: "gear")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.leading)
            //ZStack {
            /*
             DrawingArcCircle(arcFrag: 999, lineWidth: 25)
             .foregroundColor(.circleLine)
             .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
             LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
             .mask(BeatTimeView(lineWidth: 25))
             */
            ZStack {
                BeatTimeView(lineWidth: 25, centiBeats: isCentiBeats, fullCircleBg: isFullCircleBg, fullDigits: isFullDigits, followSun: isFollowSun, bgCircleColor: bgCircleColor)
            }
            //.background(Color.blue)
            HStack {
                Spacer()
                Button(action: { self.showConvert.toggle() }) {
                    //Text("Convert")
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title)
                }
                Spacer()
                Button(action: { self.showAlarm.toggle() }) {
                    //Text("Alarm")
                    Image(systemName: "bell")
                        .font(.title)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showConvert) {
            ConvertView(isPresented: $showConvert)
        }
        .sheet(isPresented: $showAlarm) {
            AlarmView(isPresented: $showAlarm, alarmByDefault: alarmByDefault, notifByDefault: notifByDefault)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings, isCentiBeats: $isCentiBeats, isFullCircleBg: $isFullCircleBg, isFullDigits: $isFullDigits, isFollowSun: $isFollowSun, bgCircleColor: $bgCircleColor, alarmByDefault: $alarmByDefault, notifByDefault: $notifByDefault)
        }
        /*
        .onTapGesture(perform: {
        fgColor = fgColors[index]
            index += 1
            if (index >= fgColors.count) {
                index = 0
            }
        }
        */
    }
}

struct ConvertView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            Spacer()
            HStack{
                Spacer()
                Button(action: { isPresented.toggle() }) {
                    Image(systemName: "xmark.circle.fill")
                        //.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                    //.font(.title)
                }
            } .padding(.trailing)
            HStack{
                Text("Converter")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.leading)
            VStack {
                Spacer()
                TabView {
                    ConverTimeView()
                        .tabItem {
                            Image(systemName: "clock.fill")
                            Text("Time")
                        }
                    ConvertBeatView()
                        .tabItem {
                            Image(systemName: "at.circle.fill")
                            Text("Beats")
                        }
                }
                .font(.headline)
            }
        }
    }
}

struct AlarmView: View {
    @Binding var isPresented: Bool
    var alarmByDefault: Bool = true
    var notifByDefault: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            HStack{
                Spacer()
                Button(action: { isPresented.toggle() }) {
                    Image(systemName: "xmark.circle.fill")
                    //.font(.title)
                        .foregroundColor(.gray)
                    //.font(.title)
                }
            } .padding(.trailing)
            HStack{
                Text("Alarms")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.leading)
            HStack{
                Text("Manage notifications & alarms")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.leading)
            VStack {
                Spacer()
                AlarmSetView(setAlarm: alarmByDefault, setNotif: notifByDefault)
            }
        }
    }
}

struct ConvertBeatView: View {
    @State private var beats: String = BeatTime.beats()
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                Text("Beat time to 24-hour time")
                    .font(.subheadline)
                Spacer()
            }.padding(.leading)
            List {
                HStack {
                    TextField("Beat Time", text: $beats, onCommit: {
                        if (!BeatTime.validate(beats)) {
                            beats = BeatTime.beats()
                        }
                    })
                    .foregroundColor(.accentColor)
                    Text(".beats")
                    Spacer()
                    //.textFieldStyle(RoundedBorderTe(xtFieldStyle())
                }//.padding(.leading)
                HStack {
                    Text("24-hour time:")
                    Text(DateFormatter.localizedString(from: BeatTime.date(beats: beats), dateStyle: .none, timeStyle: .short))
                }//.padding(.leading)
            }
        }
    }
}

struct ConverTimeView: View {
    @State private var date = Date()
    
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack{
                Text("24-hour time to Beat time")
                    .font(.subheadline)
                Spacer()
            }.padding(.leading)
            List {
                HStack {
                    //Text("Local Time:")
                    DatePicker("24-hour time:", selection: $date, displayedComponents: [.hourAndMinute])
                    //Text(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
                    Spacer()
                }//.padding(.leading)
                HStack {
                    Text("@" + BeatTime.beats(date: date))
                    Text(".beats")
                    
                }//.padding(.leading)
            }
        }
    }
}

struct AlarmSetView: View {
    @State private var date = Date()
    @State private var beats: String = BeatTime.beats()
    @State var setAlarm: Bool = true
    @State var setNotif: Bool = false
    @Query(sort: \Notification.date) private var notifications: [Notification]
    @Environment(\.modelContext) private var context
    
    func setNotification(msg: String, date: Date, isAlarm: Bool, isNotif: Bool) -> Void {
        if (date.timeIntervalSinceNow < 0) {
            let notif = Notification(id: UUID(), title: msg, timer: 86400 + date.timeIntervalSinceNow, date: date.addingTimeInterval(86400), alarm: isAlarm, notif: isNotif)
            if (isAlarm) {
                alarmManager.scheduleFixAlarm(notif: notif)
            }
            if (isNotif) {
                notifManager.addNotification(notif: notif)
                
            }
            if isAlarm || isNotif {
                context.insert(notif)
            }
        }
        else {
            let notif = Notification(id: UUID(), title: msg, timer: date.timeIntervalSinceNow, date: date, alarm: isAlarm, notif: isNotif)
            if (isAlarm) {
                alarmManager.scheduleFixAlarm(notif: notif)
            }
            if (isNotif) {
                notifManager.addNotification(notif: notif)
                
            }
            if isAlarm || isNotif {
                context.insert(notif)
            }
        }
    }
    
    func unsetNotification(id: UUID? = nil) -> Void {
        if (id == nil)
        {
            if (notifications.last != nil) {
                notifManager.removeNotification(notif: notifications.last!)
                alarmManager.removeNotification(notif: notifications.last!)
                context.delete(notifications.last!)
            }
        }
        else {
            let notif = notifications.filter{$0.id == id}
            if !notif.isEmpty {
                print("remove notif: \(notif[0].title) - \(notif[0].id)")
                notifManager.removeNotification(notif: notif[0])
                alarmManager.removeNotification(notif: notif[0])
                context.delete(notif[0])
            }
        }
    }

    var body: some View {
        VStack (alignment: .leading) {
            NavigationView {
                List {
                    HStack {
                        DatePicker("24-hour time:", selection: $date, displayedComponents: [.hourAndMinute])
                            .onChange(of: date) {
                                //print("Date changed to \(date)!")
                                beats = BeatTime.beats(date: date)
                            }
                        Spacer()
                    }//.padding(.leading)
                    HStack {
                        TextField("Beat Time", text: $beats, onCommit: {
                            if (BeatTime.validate(beats)) {
                                date = BeatTime.date(beats: beats)
                            }
                            else {
                                print("beats non valid")
                            }
                        })
                        .foregroundColor(.accentColor)
                        Text(".beats")
                    }//.padding(.leading)
                    HStack {
                        Toggle(isOn: $setAlarm) {
                            Text("Alarm on")
                        }
                    }
                    HStack {
                        Toggle(isOn: $setNotif) {
                            Text("Notification on")
                        }
                    }
                }
                .navigationTitle("Set alarm")
            }
           NavigationView {
                List {
                    ForEach(notifications) { notif in
                        if notif.date > Date() {
                            HStack(spacing: 8) {
                                Text("\(notif.title) - \(DateFormatter.localizedString(from: notif.date, dateStyle: .short, timeStyle: .short))")
                                if notif.notif {
                                    Image(systemName: "bell")
                                }
                                if notif.alarm {
                                    Image(systemName: "alarm")
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text("\(notif.title) - \(DateFormatter.localizedString(from: notif.date, dateStyle: .short, timeStyle: .short))")
                                if notif.notif {
                                    Image(systemName: "bell")
                                }
                                if notif.alarm {
                                    Image(systemName: "alarm")
                                }
                            }
                            .foregroundColor(Color.gray)
                        }
                     }
                    .onDelete(perform: {
                        if let index = $0.first {
                            unsetNotification(id: notifications[index].id)
                        }
                        alarmManager.notifications.remove(atOffsets: $0)
                        notifManager.notifications.remove(atOffsets: $0)
                        //notifCount = notifications.count
                    })
                }
                .navigationTitle("Current alarms: \(notifications.count)")
                //.navigationTitle("Current alarms")
                .toolbar { EditButton() }
            }
            HStack {
                Spacer()
                Button(action: {
                    let dateBeats = BeatTime.date(beats: BeatTime.beats(date: date))
                    self.setNotification(msg: "@\(BeatTime.beats(date: date)) .beats", date: dateBeats, isAlarm: setAlarm, isNotif: setNotif)
                    //notifications = manager.notifications
                    //notifCount =  manager.notifications.count
                }) {
                    Text("Set")
                        .font(.title)
                    Image(systemName: "bell")
                        .font(.title)
                }
                Spacer()
                Button(action: {
                    if (notifications.last != nil) {
                        unsetNotification()
                    }
                    //notifications = manager.notifications
                    //notifCount = manager.notifications.count
                }) {
                    Text("Unset")
                        .font(.title)
                    Image(systemName: "bell.slash")
                        .font(.title)
                }
                Spacer()
            }
            //.padding(.leading)
        }
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Binding var isCentiBeats: Bool
    @Binding var isFullCircleBg: Bool
    @Binding var isFullDigits: Bool
    @Binding var isFollowSun: Bool
    @Binding var bgCircleColor: Color
    @Binding var alarmByDefault: Bool
    @Binding var notifByDefault: Bool

    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Toggle(isOn: $isCentiBeats) {
                        Text("Centibeats")
                    }
                    Toggle(isOn: $isFollowSun) {
                        Text("Following the sun")
                    }
                    Toggle(isOn: $isFullCircleBg) {
                        Text("Back circle")
                    }
                    Toggle(isOn: $isFullDigits) {
                        Text("Full digits")
                    }
                    Toggle(isOn: $alarmByDefault) {
                        Text("Alarm by default")
                    }
                    Toggle(isOn: $notifByDefault) {
                        Text("Notification by default")
                    }
                    if (isFullCircleBg) {
                        ColorPicker("Back circle color", selection: $bgCircleColor)
                    }
                }
            }.navigationTitle("Settings")
        }
        Button(action: { isPresented.toggle() }) {
            Text("Close")
        }
    }
    /*
     VStack {
     HStack{
     Text("Settings")
     .font(.largeTitle.bold())
     Spacer()
     }
     .padding(.leading)
     VStack {
     Spacer()
     Button(action: { isPresented.toggle() }) {
     Text("Done")
     .font(.title)
     }
     }
     }
     */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack{
                Image(systemName: "gear")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading)
            ZStack {
                /*
                 DrawingArcCircle(arcFrag: 999, lineWidth: 25)
                 .foregroundColor(.circleLine)
                 .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                 LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                 .mask(BeatTimeView(lineWidth: 25))
                 */
                BeatTimeView(lineWidth: 25)
                //Text("Centi")
            }
            HStack {
                Spacer()
                Button(action: {  }) {
                    //Text("Convert")
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title)
                }
                Spacer()
                Button(action: {  }) {
                    //Text("Convert")
                    //Image(systemName: "arrow.up.left.arrow.down.right.circle")
                      ///  .font(.title)
                    Image(systemName: "alarm")
                        .font(.title)
                }
                Spacer()
            }
        }
    }
}

struct Settings_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Spacer()
            HStack{
                Spacer()
                Button(action: { }) {
                    Image(systemName: "xmark.circle.fill")
                        //.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                    //.font(.title)
                }
            } .padding(.trailing)
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Toggle(isOn: .constant(true), label: {
                        Text("Centibeats")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Back circle")
                    })
                    ColorPicker("Back circle color", selection: .constant(.circleLine))
                }
            }.navigationTitle("Settings")
        }
        }
    }
}

struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    //.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
            } .padding(.trailing)
            HStack{
                Text("Converter")
                    .font(.largeTitle.bold())
                Spacer()
                //Spacer()
            }
            .padding(.leading)
            TabView {
                ConvertBeatView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("Time")
                    }
                ConvertBeatView()
                    .tabItem {
                        Image(systemName: "at.circle.fill")
                        Text("Beats")
                    }
            }
            .font(.headline)
            /*
            Spacer()
            Button(action: { }) {
                Text("Close")
                //.font(.title)
            }
            */
        }
        //.background(Color.orange)
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Spacer()
            HStack{
                Spacer()
                Button(action: { }) {
                    Image(systemName: "xmark.circle.fill")
                    //.font(.title)
                        .foregroundColor(.gray)
                    //.font(.title)
                }
            } .padding(.trailing)
            HStack{
                Text("Alarm")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.leading)
            VStack {
                //Spacer()
                AlarmSetView()
            }
        }
    }
}
