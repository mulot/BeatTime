//
//  ViewDraw.swift
//  BeatClock
//
//  Created by Julien Mulot on 28/04/2021.
//

import Foundation
import Cocoa

class DrawingArcCircle: NSView {
    
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
        //context.drawLinearGradient(<#T##gradient: CGGradient##CGGradient#>, start: <#T##CGPoint#>, end: <#T##CGPoint#>, options: <#T##CGGradientDrawingOptions#>)
        /*
        if let gradient = NSGradient(starting: NSColor.yellow, ending: NSColor.blue) {
            gradient.draw(in: context.path, angle: 90)
        }
        */
        context.strokePath()
        context.restoreGState()
    }
}
