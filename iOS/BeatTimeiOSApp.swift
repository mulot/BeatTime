//
//  BeatTimeiOSApp.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

@main
struct BeatTimeiOSApp: App {
    //let fgColors: [Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .pink]
    //@State private var fgColor: Color = .gray
    //@State private var index = 1
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //BeatTimeView(lineWidth: 25)
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
    @State var bgCircleColor = Color.circleLine
    @SceneStorage("ContentView.isCentiBeats") var isCentiBeats = false
    @SceneStorage("ContentView.isFullCircleBg") var isFullCircleBg = true
    
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
                BeatTimeView(lineWidth: 25, centiBeats: isCentiBeats, fullCircleBg: isFullCircleBg, bgCircleColor: bgCircleColor)
            }
            //.background(Color.blue)
            Button(action: { self.showConvert.toggle() }) {
                Text("Convert")
                    .font(.title)
            }
        }
        .sheet(isPresented: $showConvert) {
            ConvertView(isPresented: $showConvert)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings, isCentiBeats: $isCentiBeats, isFullCircleBg: $isFullCircleBg, bgCircleColor: $bgCircleColor)
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

struct ConvertBeatView: View {
    @State private var beats: String = BeatTime().beats()
    
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
                        if (!validate(beats)) {
                            beats = BeatTime().beats()
                        }
                    })
                    .foregroundColor(.accentColor)
                    Text(".beats")
                    Spacer()
                    //.textFieldStyle(RoundedBorderTe(xtFieldStyle())
                }//.padding(.leading)
                HStack {
                    Text("24-hour time:")
                    Text(DateFormatter.localizedString(from: BeatTime().date(beats: beats), dateStyle: .none, timeStyle: .short))
                }//.padding(.leading)
            }
        }
    }
    
    private func validate(_ beats: String) -> Bool {
        if let beattime = Int(beats) {
            if (beattime >= 0 && beattime <= 1000) {
                return true
            }
        }
        return false
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
                    Text("@" + BeatTime().beats(date: date))
                    Text(".beats")
                    
                }//.padding(.leading)
            }
        }
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Binding var isCentiBeats: Bool
    @Binding var isFullCircleBg: Bool
    @Binding var bgCircleColor: Color
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Toggle(isOn: $isCentiBeats) {
                        Text("Centibeats")
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
            Button(action: {  }) {
                Text("Convert")
                    .font(.title)
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

