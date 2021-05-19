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
            /*
             BeatTimeView(lineWidth: 25)
             .background(Color.black)
             .foregroundColor(fgColor)
             .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
             .edgesIgnoringSafeArea(.all)
             .onTapGesture(perform: {
             //fgColor = fgColors.randomElement()!
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

struct ContentView: View {
    @State var showConvert = false
    @State var showSettings = false
    
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
            BeatTimeView(lineWidth: 25)
            //.background(Color.blue)
            //}
            Button(action: { self.showConvert.toggle() }) {
                Text("Convert")
                    .font(.title)
            }
        }
        .sheet(isPresented: $showConvert) {
            ConvertView(isPresented: $showConvert)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings)
        }
    }
}

struct ConvertView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
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
                Spacer()
                Button(action: { isPresented.toggle() }) {
                    Text("Done")
                        .font(.title)
                }
            }
        }
    }
}

struct ConvertBeatView: View {
    @State private var beats: String = BeatTime().beats()
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(".beats:")
                TextField("Beat Time", text: $beats)
                    .foregroundColor(.accentColor)
                    //.textFieldStyle(RoundedBorderTe(xtFieldStyle())
            }.padding(.leading)
            HStack {
                Text("Time:")
                Text(DateFormatter.localizedString(from: BeatTime().date(beats: beats), dateStyle: .none, timeStyle: .short))
            }.padding(.leading)
        }
    }
}

struct ConverTimeView: View {
    @State private var date = Date()

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                //Text("Local Time:")
                DatePicker("Time", selection: $date, displayedComponents: [.hourAndMinute])
                //Text(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
            }.padding(.leading)
            HStack {
                Text(".beats:")
                Text("@" + BeatTime().beats(date: date))
            }.padding(.leading)
        }
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
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
    }
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
            }
            Button(action: {  }) {
                Text("Convert")
                    .font(.title)
            }
        }
    }
}

struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack{
                Text("Converter")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.leading)
            VStack {
                Spacer()
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
                Spacer()
                Button(action: { }) {
                    Text("Done")
                        .font(.title)
                }
            }
        }
        //.background(Color.orange)
    }
}
