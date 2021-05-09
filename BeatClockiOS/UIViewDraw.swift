//
//  UIViewDraw.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

//import Foundation
import SwiftUI

struct DrawingArcCircle: View {
    
    var arcFrag: Double = 300
    var lineWidth: CGFloat = 10
     /*
    var lineColor: CGColor = Color.blue.cgColor!
    var startColor =  Color(red: 0, green: 30/255, blue: 50/255)
    var midColor = Color.purple
    var mid2Color = Color(red: 247/255, green: 186/255, blue: 0)
    var endColor = Color.yellow
    var isShadow: Bool = false
*/
    var body: some View {
        GeometryReader { geometry in
            
            //let context = UIGraphicsGetCurrentContext()!
            //let arcLength: CGFloat = CGFloat((2 * Double.pi) - (2 * Double.pi * arcFrag)/1000 + (Double.pi/2))
            let frame = geometry.frame(in: .local)
            //let boxWidth = frame.width / 4
            
            Path { path in
                //path.move(to: CGPoint(x: 0, y: frame.minY))
                //path.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width/2 - (lineWidth/2)), startAngle: CGFloat(Double.pi/2), endAngle: arcLength, clockwise: true)
                /*
                path.addLines(
                    [CGPoint(x: 0, y: frame.minY),
                     CGPoint(x: boxWidth, y: frame.minY),
                     CGPoint(x: boxWidth, y: frame.maxY),
                     CGPoint(x: 0, y: frame.maxY)])
 */
                path.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width/2 - (lineWidth)), startAngle: Angle.degrees(270), endAngle: Angle.degrees(90), clockwise: false)
            }
            .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: CGLineCap.round))
            /*
             context.saveGState()
             context.setLineWidth(lineWidth)
             context.setLineCap(CGLineCap.round)
             if (isShadow) {
             context.setShadow(offset: CGSize(width: 2, height: -2), blur: 3)
             }
             context.beginPath()
             if (arcFrag != 1000) {
             context.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width/2 - (lineWidth/2)), startAngle: CGFloat(Double.pi/2), endAngle: arcLength, clockwise: true)
             context.replacePathWithStrokedPath()
             context.clip()
             
             let colorSpace = CGColorSpaceCreateDeviceRGB()
             let startColorComponents = startColor.cgColor?.components
             let midColorComponents = midColor.cgColor?.components
             let mid2ColorComponents = mid2Color.cgColor?.components
             let endColorComponents = endColor.cgColor?.components
             let colorComponents: [CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], midColorComponents[0], midColorComponents[1], midColorComponents[2], midColorComponents[3], mid2ColorComponents[0], mid2ColorComponents[1], mid2ColorComponents[2], mid2ColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
             let locations:[CGFloat] = [0.0, 0.25, 0.5, 1.0]
             guard let gradient  = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 4) else { }
             let startPoint = CGPoint(x: frame.bounds.width, y: frame.bounds.height)
             let endPoint = CGPoint(x: frame.bounds.width, y: 0)
             context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
             }
             else {
             context.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width/2 - (lineWidth/2)), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi*2), clockwise: true)
             context.setStrokeColor(lineColor)
             context.strokePath()
             }
             context.restoreGState()
             */
        }
    }
}

struct UIViewDraw_Previews: PreviewProvider {
    static var previews: some View {
        DrawingArcCircle()
    }
}
