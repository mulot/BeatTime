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
    //var startColor = NSColor.purple
    var startColor =  NSColor(red: 0, green: 77/255, blue: 129/255, alpha: 1)
    var midColor = NSColor.purple
    var endColor = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
    var isShadow: Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let arcLength: CGFloat = CGFloat((2 * Double.pi) - (2 * Double.pi * arcFrag)/1000 + (Double.pi/2))
        
        context.saveGState()
        context.setLineWidth(lineWidth)
        if (isShadow) {
            context.setShadow(offset: CGSize(width: 2, height: -2), blur: 3)
        }
        context.beginPath()
        if (arcFrag != 1000) {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (dirtyRect.width/2 - (lineWidth/2)), startAngle: CGFloat(Double.pi/2), endAngle: arcLength, clockwise: true)
            context.replacePathWithStrokedPath()
            context.clip()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let startColorComponents = startColor.cgColor.components else { return }
            guard let endColorComponents = endColor.cgColor.components else { return }
            guard let midColorComponents = midColor.cgColor.components else { return }
            //let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
            let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
            //let locations:[CGFloat] = [0.0, 1.0]
            let locations:[CGFloat] = [0.0, 0.5, 1.0]
            //guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) else { return }
            guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 3) else { return }
            let startPoint = CGPoint(x: 0, y: self.bounds.height)
            let endPoint = CGPoint(x: self.bounds.width,y: self.bounds.height)
            /*
            let startPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height)
            let endPoint = CGPoint(x: self.bounds.width,y: self.bounds.height)
             */
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        }
        else {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (dirtyRect.width/2 - (lineWidth/2)), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi*2), clockwise: true)
            context.setStrokeColor(lineColor)
            context.strokePath()
        }
        context.restoreGState()
    }
}
