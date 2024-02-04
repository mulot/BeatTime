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
        //NSApp.hide(nil)
        beat = BeatTime()
        //beat.isCentiBeat = true
        beatsWindow.stringValue = "@\(beat.beats(centiBeats: isCentiBeats))"
        //beatsWindow.textColor = NSColor(patternImage: imageGradient())
        drawTimeCircle()
        //let frame = NSRect(x: 0, y: 0, width: 400, height: 200)
        //let gradientLabel = GradientLabel(string: "TUTU")
        //view.addSubview(gradientLabel)
        let textGradient = GradientTextView()
        view.addSubview(textGradient)
        /*
        if let maskImage = createMaskImage(withText: "Hello !") {
            let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 300, height: 100))
            imageView.image = maskImage
            view.addSubview(imageView)
        }
        */
        //let gradientTextView = GradientTextView(frame: frame)
        //view.addSubview(gradientTextView)
        //view.window?.contentView = gradientTextView
        //gradientLabel.stringValue = "TOTO"
        //gradientLabel.alignment = .center
        //view.addSubview(NSTextField(string: "TITI"))
        //window.contentView = gradientLabel
        //let text = TextGradient()
        //view.addSubview(text)
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
    
    func imageGradient() -> NSImage {
        let startColor =  NSColor(red: 0, green: 30/255, blue: 50/255, alpha: 1)
        let midColor = NSColor.purple
        let mid2Color = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
        let endColor = NSColor.yellow
        let context = NSGraphicsContext.current!.cgContext
        
        context.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
         let startColorComponents = startColor.cgColor.components!
         let midColorComponents = midColor.cgColor.components!
         let mid2ColorComponents = mid2Color.cgColor.components!
         let endColorComponents = endColor.cgColor.components!
        let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], mid2ColorComponents[0], mid2ColorComponents[1], mid2ColorComponents[2], mid2ColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let locations:[CGFloat] = [0.0, 0.25, 0.5, 1.0]
         let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 4)!
        let startPoint = CGPoint(x: self.view.bounds.width/2, y: 0)
        let endPoint = CGPoint(x: self.view.bounds.width/2, y: (self.view.bounds.height))
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        let cgImage = context.makeImage()!
        let nsImage = NSImage(cgImage: cgImage, size: .zero)
        context.restoreGState()
        return nsImage
    }
    
    class RingProgressView: NSView {
        var arcFrag: Double = 0
        var lineWidth: CGFloat = 15
        var lineColor: CGColor = NSColor.blue.cgColor
        var startColor =  NSColor(red: 0, green: 30/255, blue: 50/255, alpha: 1)
        var midColor = NSColor.purple
        //var midColor = NSColor(red: 0, green: 160/255, blue: 1, alpha: 1)
        var mid2Color = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
        //var endColor = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
        var endColor = NSColor.yellow
        var isShadow: Bool = false
        var isFollowSun: Bool = false
        
        override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            let context = NSGraphicsContext.current!.cgContext
            let arcLength: CGFloat = CGFloat((2 * Double.pi) - (2 * Double.pi * arcFrag)/1000 + (Double.pi/2))
            let shadowOffset = 2
            let circleDiameter = min(dirtyRect.height, dirtyRect.width)
            //print("Rect Height: \(dirtyRect.height) width: \(dirtyRect.width) diameter: \(circleDiameter)")
            
            context.saveGState()
            context.setLineWidth(lineWidth)
            context.setLineCap(CGLineCap.round)
            if (isShadow) {
                context.setShadow(offset: CGSize(width: shadowOffset, height: -shadowOffset), blur: 3)
            }
            context.beginPath()
            if (arcFrag != 1000) {
                //let nbHour = BeatTime.hoursOffsetWithBMT()
                let nbHour = 4
                //print("BMP Offset: \(nbHour) hours")
                let angle = (2 * Double.pi) / 24 * Double(nbHour)
                context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (circleDiameter/2 - lineWidth), startAngle: CGFloat(Double.pi/2), endAngle: arcLength, clockwise: true)
                context.replacePathWithStrokedPath()
                context.clip()
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                guard let startColorComponents = startColor.cgColor.components else { return }
                guard let midColorComponents = midColor.cgColor.components else { return }
                guard let mid2ColorComponents = mid2Color.cgColor.components else { return }
                guard let endColorComponents = endColor.cgColor.components else { return }
                //let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
                //let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
                let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], mid2ColorComponents[0], mid2ColorComponents[1], mid2ColorComponents[2], mid2ColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
                //let locations:[CGFloat] = [0.0, 1.0]
                //let locations:[CGFloat] = [0.0, 0.25, 1.0]
                let locations:[CGFloat] = [0.0, 0.25, 0.5, 1.0]
                //guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) else { return }
                //guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 3) else { return }
                guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 4) else { return }
                let startCircle = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2)+circleDiameter/2)
                var startPoint = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2)+circleDiameter/2)
                var endPoint = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2)-circleDiameter/2)
                if (isFollowSun) {
                    startPoint = CGPoint(x: startCircle.x - (circleDiameter/2)*sin(angle), y: startCircle.y - ((circleDiameter/2)*(1-cos(angle))))
                    endPoint =  CGPoint(x: startCircle.x - (circleDiameter/2)*sin(angle+Double.pi), y: startCircle.y - ((circleDiameter/2)*(1-cos(angle+Double.pi))))
                }
                //let startPoint = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2)+circleDiameter/2)
                //let endPoint = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2)-circleDiameter/2)
                /*
                 let startPoint = CGPoint(x: 0, y: self.bounds.height)
                 let endPoint = CGPoint(x: self.bounds.width,y: self.bounds.height)
                 */
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            }
        }
    }
}
