//
//  BeatTimeTvOSApp.swift
//  BeatTimeTvOS
//
//  Created by Julien Mulot on 17/05/2021.
//

import SwiftUI

@main
struct BeatTimeTvOSApp: App {
    var body: some Scene {
        WindowGroup {
            BeatTimeView(lineWidth: 40)
                .foregroundColor(.orange)
                .font(.largeTitle)
        }
    }
}

struct BeatTimeTvOSApp_Previews: PreviewProvider {
    static var previews: some View {
        BeatTimeView(lineWidth: 40)
            .foregroundColor(.orange)
            .font(.largeTitle)
    }
}
