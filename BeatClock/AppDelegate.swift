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
    @IBOutlet var view: NSView!
    @IBOutlet var beatsWindow: NSTextField!
    @IBOutlet var optCentiBeats: NSMenuItem!
    
    var timer: Timer!
    var beat: BeatClock!
    var circleBeatView: Drawing!
    
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
        let circleView = Drawing(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        circleView.arcFrag = 1000
        circleView.lineColor = NSColor.gray.cgColor
        view.addSubview(circleView)
        circleBeatView = Drawing(frame: NSRect(x: window.contentLayoutRect.width/2 - (circleDiameter/2), y: window.contentLayoutRect.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        if (beat != nil) {
            circleBeatView.arcFrag = Double(beat.beatTime()) ?? 0
        }
        view.addSubview(circleBeatView)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        beat = BeatClock()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beatTime())"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in
            beatsWindow.stringValue = "@\(self.beat.beatTime())"
        }
        drawTimeCircle()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

class Drawing: NSView {
    
    var arcFrag: Double = 0
    var lineWidth: CGFloat = 10
    var lineColor: CGColor = NSColor.blue.cgColor
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let arcLength: CGFloat = CGFloat((2 * Double.pi) - (2 * Double.pi * arcFrag)/1000 + (Double.pi/2))
        
        context.saveGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor)
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
