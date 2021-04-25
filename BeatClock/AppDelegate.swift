//
//  AppDelegate.swift
//  BeatClock
//
//  Created by Julien Mulot on 24/04/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet var beatsWindow: NSTextField!
    var timer: Timer!
    var beat: BeatClock!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        beat = BeatClock()
        
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beatTime())"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in beatsWindow.stringValue = "@\(self.beat.beatTime())"}
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

