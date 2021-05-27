//
//  AppDelegate.swift
//  BeatTime
//
//  Created by Julien Mulot on 24/04/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSWindowDelegate, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    @IBOutlet var view: NSView!
    @IBOutlet var beatsWindow: NSTextField!
    @IBOutlet var optCentiBeats: NSMenuItem!
    
    var timer: Timer!
    var beat: BeatTime!
    var circleBeatView: RingProgressView!
    var circleView: RingProgressView!
    var isCentiBeats: Bool = false
    
    @IBAction func changeCentiBeats(_ sender: AnyObject) {
        if (beat != nil) {
            if (optCentiBeats.state == NSControl.StateValue.off) {
                optCentiBeats.state = NSControl.StateValue.on
                isCentiBeats = true
                beatsWindow.stringValue = "@\(beat.beats(centiBeats: isCentiBeats))"
            }
            else {
                optCentiBeats.state = NSControl.StateValue.off
                isCentiBeats = false
                beatsWindow.stringValue = "@\(beat.beats(centiBeats: isCentiBeats))"
            }
        }
    }
    
    private func drawTimeCircle()
    {
        let circleDiameter = min(window.contentLayoutRect.height, window.contentLayoutRect.width) - 50
        //Draw circle layout
        let circle = RingProgressView(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        circle.arcFrag = 1000
        circle.lineColor = NSColor.gray.cgColor
        circle.isShadow = true
        if (circleView != nil) {
            view.replaceSubview(circleView, with: circle)
            circleView = circle
        }
        else {
            circleView = circle
            view.addSubview(circleView)
        }
        //Draw beat time circle
        let circleBeat = RingProgressView(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        if (beat != nil) {
            circleBeat.arcFrag = Double(beat.beats()) ?? 0
            //circleBeat.arcFrag = 999 // TEST FULL CIRCLE
        }
        if (circleBeatView != nil) {
            view.replaceSubview(circleBeatView, with: circleBeat)
            circleBeatView = circleBeat
        }
        else {
            circleBeatView = circleBeat
            view.addSubview(circleBeatView)
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        drawTimeCircle()
    }
    
    func windowWillClose(_ notification: Notification)
    {
        NSApp.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        beat = BeatTime()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beats(centiBeats: isCentiBeats))"
        drawTimeCircle()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in
            beatsWindow.stringValue = "@\(self.beat.beats(centiBeats: isCentiBeats))"
            drawTimeCircle()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

