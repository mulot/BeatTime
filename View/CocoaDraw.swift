//
//  ViewDraw.swift
//  BeatTime
//
//  Created by Julien Mulot on 28/04/2021.
//

import Foundation
import Cocoa

//WIP
class TextGradient: NSView {
    var startColor =  NSColor(red: 0, green: 30/255, blue: 50/255, alpha: 1)
    var midColor = NSColor.purple
    var mid2Color = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
    var endColor = NSColor.yellow
    var isShadow: Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let shadowOffset = 2
    
        context.saveGState()
        if (isShadow) {
            context.setShadow(offset: CGSize(width: shadowOffset, height: -shadowOffset), blur: 3)
        }
        context.beginPath()
        context.replacePathWithStrokedPath()
        context.clip()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let startColorComponents = startColor.cgColor.components else { return }
        guard let midColorComponents = midColor.cgColor.components else { return }
        guard let mid2ColorComponents = mid2Color.cgColor.components else { return }
        guard let endColorComponents = endColor.cgColor.components else { return }
        let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], mid2ColorComponents[0], mid2ColorComponents[1], mid2ColorComponents[2], mid2ColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let locations:[CGFloat] = [0.0, 0.25, 0.5, 1.0]
        guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 4) else { return }
        let startPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        let endPoint = CGPoint(x: self.bounds.width, y: 0)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        context.restoreGState()
    }
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
            let nbHour = BeatTime.hoursOffsetWithBMT()
            //let nbHour = 2
            print("BMP Offset: \(nbHour) hours")
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
        else {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (circleDiameter/2 - lineWidth), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi*2), clockwise: true)
            context.setStrokeColor(lineColor)
            context.strokePath()
        }
        context.restoreGState()
    }
}
