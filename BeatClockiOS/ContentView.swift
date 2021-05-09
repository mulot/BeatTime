//
//  ContentView.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DetailView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View {
    
    //let character: CharacterDetail

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
