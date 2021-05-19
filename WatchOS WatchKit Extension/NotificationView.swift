//
//  NotificationView.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        Text("@" + BeatTime().beats())
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
