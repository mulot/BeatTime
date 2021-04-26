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
    @IBOutlet var circleTime: Drawing!
    var timer: Timer!
    var beat: BeatClock!
    var halfSize:CGFloat!
   
    let desiredLineWidth:CGFloat = 3
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        beat = BeatClock()
        //beat.isCentiBeat = true
        
        halfSize = min(window.frame.height/2, window.frame.width/2)
        //circleTime.draw(NSRect(x: window.frame.width/2, y: window.frame.height/2, width: halfSize, height: halfSize))
        //beatsWindow.stringValue = "@\(beat.beatTime())"
        
        //timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in beatsWindow.stringValue = "@\(self.beat.beatTime())"}
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

class Drawing: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        //let fillColor = NSColor.red
        let fillColor = NSColor.clear
        let lineColor = NSColor.blue
        let path = NSBezierPath(ovalIn: dirtyRect)
        path.lineWidth = 3
        lineColor.setStroke()
        fillColor.setFill()
        path.fill()
        path.stroke()
    }
}
