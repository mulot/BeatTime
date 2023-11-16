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
    @IBOutlet var optFollowSun: NSMenuItem!
    @IBOutlet var optCircleBack: NSMenuItem!
    
    var timer: Timer!
    var beat: BeatTime!
    var circleBeatView: RingProgressView!
    var circleView: RingProgressView!
    var isCentiBeats: Bool = false
    var isFollowSun: Bool = false
    var isFullCircleBg: Bool = true
    var statusItem: NSStatusItem?
    var lineWidth: CGFloat = 25
    
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
    
    @IBAction func changeFollowSun(_ sender: AnyObject) {
            if (optFollowSun.state == NSControl.StateValue.off) {
                optFollowSun.state = NSControl.StateValue.on
                isFollowSun = true
            }
            else {
                optFollowSun.state = NSControl.StateValue.off
                isFollowSun = false
            }
    }
    
    @IBAction func changeCircleBack(_ sender: AnyObject) {
            if (optCircleBack.state == NSControl.StateValue.off) {
                optCircleBack.state = NSControl.StateValue.on
                isFullCircleBg = true
            }
            else {
                optCircleBack.state = NSControl.StateValue.off
                isFullCircleBg = false
            }
    }
    
    private func drawTimeCircle()
    {
        //let circleDiameter = min(window.contentLayoutRect.height, window.contentLayoutRect.width) - 50
        //print("Win Height: \(window.frame.height) Win Width: \(window.frame.width) Layout Height: \(window.contentLayoutRect.height) Layout Width: \(window.contentLayoutRect.width) min Layout: \(min(window.contentLayoutRect.height, window.contentLayoutRect.width)) Diameter: \(circleDiameter)")
        //Draw circle layout
        let circle = RingProgressView()
        if (isFullCircleBg) {
            circle.arcFrag = 1000
        }
        else {
            circle.arcFrag = 0
        }
        circle.lineColor = NSColor.gray.cgColor
        circle.isShadow = true
        circle.lineWidth = lineWidth
        if (circleView != nil) {
            view.replaceSubview(circleView, with: circle)
            circleView = circle
        }
        else {
            circleView = circle
            view.addSubview(circleView)
        }
        //Draw beat time circle
        let circleBeat = RingProgressView()
        if (beat != nil) {
            circleBeat.isFollowSun = isFollowSun
            circleBeat.arcFrag = Double(beat.beats()) ?? 0
            circleBeat.lineWidth = lineWidth
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
    
    @objc func showApp(_ sender: AnyObject?) {
        //print("show App")
        NSApp.unhide(sender)
    }
    
    @objc func quitApp(_ sender: AnyObject?) {
        //print("Quit App")
        NSApp.terminate(sender)
    }
    
    @objc func followSun(_ sender: AnyObject?) {
        //print("Follow Sun")
        isFollowSun = !isFollowSun
        if (isFollowSun) {
            self.statusItem?.menu?.item(withTitle: "Follow the sun")?.state = .on
        }
        else {
            self.statusItem?.menu?.item(withTitle: "Follow the sun")?.state = .off
        }
    }
    
    @objc func fullCircleBg(_ sender: AnyObject?) {
        isFullCircleBg = !isFullCircleBg
        if (isFullCircleBg) {
            self.statusItem?.menu?.item(withTitle: "Show back circle")?.state = .on
        }
        else {
            self.statusItem?.menu?.item(withTitle: "Show back circle")?.state = .off
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //print("Should close")
        NSApp.hide(sender)
        return false
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        //print("Become active")
        NSApp.unhide(self)
    }
    
    func windowDidResize(_ notification: Notification) {
        drawTimeCircle()
    }
    
    func windowWillClose(_ notification: Notification)
    {
        //NSApp.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.hide(nil)
        beat = BeatTime()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beats(centiBeats: isCentiBeats))"
        drawTimeCircle()
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.button?.title = "@" + BeatTime().beats()
        self.statusItem?.menu = NSMenu()
        self.statusItem?.menu?.addItem(withTitle: "Show App", action: #selector(showApp(_:)), keyEquivalent: "A")
        self.statusItem?.menu?.addItem(withTitle: "Quit", action: #selector(quitApp(_:)), keyEquivalent: "Q")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in
            beatsWindow.stringValue = "@\(self.beat.beats(centiBeats: isCentiBeats))"
            drawTimeCircle()
            self.statusItem?.button?.title = "@" + BeatTime().beats()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
