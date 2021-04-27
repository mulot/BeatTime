//
//  AppDelegate.swift
//  BeatClock
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
    var beat: BeatClock!
    var circleBeatView: Drawing!
    var circleView: Drawing!
    
    @IBAction func changeCentiBeats(_ sender: AnyObject) {
        if (beat != nil) {
            if (optCentiBeats.state == NSControl.StateValue.off) {
                optCentiBeats.state = NSControl.StateValue.on
                beat.isCentiBeat = true
                beatsWindow.stringValue = "@\(beat.beatTime())"
            }
            else {
                optCentiBeats.state = NSControl.StateValue.off
                beat.isCentiBeat = false
                beatsWindow.stringValue = "@\(beat.beatTime())"
            }
        }
    }
    
    private func drawTimeCircle()
    {
        let circleDiameter = min(window.contentLayoutRect.height, window.contentLayoutRect.width) - 50
        let circle = Drawing(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
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
        let circleBeat = Drawing(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        if (beat != nil) {
            circleBeat.arcFrag = Double(beat.beatTime()) ?? 0
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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        beat = BeatClock()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beatTime())"
        drawTimeCircle()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in
            beatsWindow.stringValue = "@\(self.beat.beatTime())"
            drawTimeCircle()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

class Drawing: NSView {
    
    var arcFrag: Double = 0
    var lineWidth: CGFloat = 10
    var lineColor: CGColor = NSColor.blue.cgColor
    var isShadow: Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let arcLength: CGFloat = CGFloat((2 * Double.pi) - (2 * Double.pi * arcFrag)/1000 + (Double.pi/2))
        
        context.saveGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor)
        if (isShadow) {
            context.setShadow(offset: CGSize(width: 2, height: -2), blur: 3)
        }
        context.beginPath()
        if (arcFrag != 1000) {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (dirtyRect.width/2 - (lineWidth/2)), startAngle: CGFloat(Double.pi/2), endAngle: arcLength, clockwise: true)
        }
        else {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (dirtyRect.width/2 - (lineWidth/2)), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi*2), clockwise: true)
        }
        context.strokePath()
        context.restoreGState()
    }
}
