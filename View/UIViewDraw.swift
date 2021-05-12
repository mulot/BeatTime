//
//  UIViewDraw.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

//import Foundation
import SwiftUI

struct DrawingArcCircle: View {
    
    var arcFrag: Double = 0
    var lineWidth: CGFloat = 10
    /*
    var lineColor: Color = Color.timeLine
    var startColor =  Color(red: 0, green: 30/255, blue: 50/255)
    var midColor = Color.purple
    var mid2Color = Color(red: 247/255, green: 186/255, blue: 0)
    var endColor = Color.yellow
    var isShadow: Bool = false
     */
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let arcLength: Double = ((arcFrag * 360)/1000 - 90)
            let circleDiameter = min(frame.width, frame.height)
            
            Path { path in
                path.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (circleDiameter/2 - (lineWidth)), startAngle: Angle.degrees(270), endAngle: Angle.degrees(arcLength), clockwise: false)
            }
            //.stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
        }
    }
}

struct UIViewDraw_Previews: PreviewProvider {
    static var previews: some View {
        DrawingArcCircle(arcFrag: Double(BeatTime().beats())!)
    }
}
