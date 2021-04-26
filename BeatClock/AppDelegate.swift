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
    var halfSize:CGFloat!
    
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
        let circleDiameter = min(window.frame.height, window.frame.width) - 50
        let circleView = Drawing(frame: NSRect(x: window.frame.width/2 - (circleDiameter/2), y: window.frame.height/2 - (circleDiameter/2), width: circleDiameter, height: circleDiameter))
        circleView.isHidden = false
        view.addSubview(circleView)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        beat = BeatClock()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beatTime())"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in beatsWindow.stringValue = "@\(self.beat.beatTime())"}
        drawTimeCircle()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

class Drawing: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let lineWidth:CGFloat = 10
        context.saveGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(NSColor.blue.cgColor)
        
        context.beginPath()
        context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (dirtyRect.width/2 - (lineWidth/2)), startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(0), clockwise: true)
        //context.closePath()
        context.strokePath()
        //context.fillPath()
        
        //context.setFillColor(NSColor.red.cgColor)
        //context.fillEllipse(in: dirtyRect)
        //context.strokeEllipse(in: dirtyRect)
        
        context.restoreGState()
    }
}
