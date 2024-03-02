//
//  BeatTimeiOSApp.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

//let notificationCenter = UNUserNotificationCenter.current()
let manager = LocalNotificationManager()

@main
struct BeatTimeiOSApp: App {
    //let fgColors: [Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .pink]
    //@State private var fgColor: Color = .gray
    //@State private var index = 1
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
    @SceneStorage("ContentView.isFollowSun") var isFollowSun = true
    
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
                BeatTimeView(lineWidth: 25, centiBeats: isCentiBeats, fullCircleBg: isFullCircleBg, followSun: isFollowSun, bgCircleColor: bgCircleColor)
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
            AlarmView(isPresented: $showAlarm)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings, isCentiBeats: $isCentiBeats, isFullCircleBg: $isFullCircleBg, isFollowSun: $isFollowSun, bgCircleColor: $bgCircleColor)
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
                Text("Notification alarm")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.leading)
            HStack{
                Text("Manage notifications")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.leading)
            VStack {
                Spacer()
                AlarmSetView()
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
    @State private var notifCount: Int = manager.notifications.count
    @State private var notifications: [Notification] = manager.notifications

    func setNotification(msg: String, date: Date) -> Void {
        if (date.timeIntervalSinceNow < 0) {
            manager.addNotification(title: msg, time: 86400 + date.timeIntervalSinceNow, date: date.addingTimeInterval(86400))
        }
        else {
            manager.addNotification(title: msg, time: date.timeIntervalSinceNow, date: date)
        }
    }
    
    func unsetNotification(id: String? = nil) -> Void {
        if (id == nil)
        {
            if (manager.notifications.last != nil) {
                manager.removeNotification(notif: manager.notifications.last!)
            }
        }
        else {
            let notif = manager.notifications.filter{$0.id == id}
            if !notif.isEmpty {
                print("remove notif: \(notif[0].title) - \(notif[0].id)")
                manager.removeNotification(notif: notif[0])
            }
        }
    }

    var body: some View {
        VStack (alignment: .leading) {
            NavigationView {
                List {
                    HStack {
                        DatePicker("24-hour time:", selection: $date, displayedComponents: [.hourAndMinute])
                            .onChange(of: date) { newDate in
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
                }
                .navigationTitle("Set alarm")
            }
           NavigationView {
                List {
                    ForEach(notifications) { notif in
                        if (notif.date > Date()) {
                            Text("\(notif.title) - \(DateFormatter.localizedString(from: notif.date, dateStyle: .short, timeStyle: .short))")
                        }
                        else {
                            Text("\(notif.title) - \(DateFormatter.localizedString(from: notif.date, dateStyle: .short, timeStyle: .short))")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .onDelete(perform: {
                        if let index = $0.first {
                            unsetNotification(id: notifications[index].id)
                        }
                        notifications.remove(atOffsets: $0)
                        notifCount = notifications.count
                    })
                }
                .navigationTitle("Current alarms: \(notifCount)")
                //.navigationTitle("Current alarms")
                .toolbar { EditButton() }
            }
            HStack {
                Spacer()
                Button(action: {
                    let dateBeats = BeatTime.date(beats: BeatTime.beats(date: date))
                    self.setNotification(msg: "@\(BeatTime.beats(date: date)) .beats", date: dateBeats)
                    notifications = manager.notifications
                    notifCount =  manager.notifications.count
                }) {
                    Text("Set")
                        .font(.title)
                    Image(systemName: "bell")
                        .font(.title)
                }
                Spacer()
                Button(action: {
                    if (manager.notifications.last != nil) {
                        unsetNotification()
                    }
                    notifications = manager.notifications
                    notifCount = manager.notifications.count
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
    @Binding var isFollowSun: Bool
    @Binding var bgCircleColor: Color
    
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
                    Toggle(isOn: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/, label: {
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
