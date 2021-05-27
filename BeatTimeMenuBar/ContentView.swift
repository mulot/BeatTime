//
//  ContentView.swift
//  BeatTimeMenuBar
//
//  Created by Julien Mulot on 27/05/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Text("@" + BeatTime().beats())
            RingProgressView(arcFrag: 999, lineWidth: 10)
                .foregroundColor(.circleLine)
            RingProgressView(arcFrag: Double(BeatTime().beats())!, lineWidth: 10)
                .foregroundColor(.accentColor)
        }
        .font(.title.bold())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
