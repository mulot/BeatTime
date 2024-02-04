//
//  ViewDraw.swift
//  BeatTime
//
//  Created by Julien Mulot on 28/04/2021.
//

import Foundation
import Cocoa

//WIP
// Fonction pour créer une CGImage masque avec du texte
func createMaskCGImage(withText text: String) -> CGImage? {
    
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = .center
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 64),
        .foregroundColor: NSColor.black,
        .paragraphStyle: textStyle
    ]
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    let textSize = attributedText.size()
    
    // Créer un contexte graphique
    guard let bitmapContext = CGContext(data: nil,
                                        width: Int(textSize.width),
                                        height: Int(textSize.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: CGColorSpaceCreateDeviceGray(),
                                        bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
        return nil
    }
    
    // Dessiner le texte dans le contexte graphique
    bitmapContext.setFillColor(gray: 1.0, alpha: 1.0)
    bitmapContext.fill(CGRect(origin: .zero, size: textSize))
    
    bitmapContext.setFillColor(gray: 0.0, alpha: 1.0)
    let textRect = CGRect(origin: .zero, size: textSize)
    (text as NSString).draw(in: textRect, withAttributes: attributes)
    
    // Extraire la CGImage du contexte graphique
    guard let maskCGImage = bitmapContext.makeImage() else {
        return nil
    }
    
    return maskCGImage
}

func createMaskImage(withText text: String) -> NSImage? {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 64),
    ]
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    let textSize = attributedText.size()
    //let colorSpace = CGColorSpaceCreateDeviceGray()
    
    let image = NSImage(size: textSize)
    //let image2 = CGImage(
    // Créer un contexte graphique
    if let representation = NSBitmapImageRep(bitmapDataPlanes: nil,
                                             pixelsWide: Int(textSize.width),
                                             pixelsHigh: Int(textSize.height),
                                             bitsPerSample: 8,
                                             samplesPerPixel: 4,
                                             hasAlpha: true,
                                             isPlanar: false,
                                             colorSpaceName: .deviceRGB,
                                             bytesPerRow: 0,
                                             bitsPerPixel: 0) {
        representation.size = textSize
        image.addRepresentation(representation)
        
        if let context = NSGraphicsContext(bitmapImageRep: representation) {
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = context
            
            // Dessiner le texte dans le contexte graphique
            let textRect = CGRect(origin: .zero, size: textSize)
            let textStyle = NSMutableParagraphStyle()
            textStyle.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 40),
                .foregroundColor: NSColor.white,
                .paragraphStyle: textStyle
            ]
            (text as NSString).draw(in: textRect, withAttributes: attributes)
            
            NSGraphicsContext.restoreGraphicsState()
        }
    }
    
    return image
}

class GradientTextView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Définir le texte à afficher
        let text = "Hello Text!"
        
        // Récupérer la taille du texte
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 64),
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedText.size()
        
        // Créer un dégradé de couleur
        let gradient = NSGradient(colors: [NSColor.red, NSColor.yellow]) // Changez les couleurs selon votre choix
        
        // Calculer le point de départ et d'arrivée du dégradé pour le texte
        let startX = dirtyRect.origin.x
        let startY = dirtyRect.origin.y
        //let endX = startX + textSize.width
        //let endY = startY + textSize.height
        
        // Appliquer le dégradé au texte en utilisant le texte comme masque
        if let context = NSGraphicsContext.current?.cgContext {
            //let colorSpace = CGColorSpaceCreateDeviceGray()
            //let maskContext = CGContext(data: nil, width:  Int(dirtyRect.width), height:  Int(dirtyRect.height), bitsPerComponent: 8, bytesPerRow: Int(dirtyRect.width), space: colorSpace, bitmapInfo: 0)
            context.saveGState()
            // Créer l'image masque du text
            if let maskImage = createMaskCGImage(withText: text) {
                context.clip(to: NSRect(x: startX, y: startY, width: textSize.width, height: textSize.height), mask: maskImage)
            }
            else
            {
                print("no mask image")
            }
            //context.restoreGState()
            //attributedText.draw(at: NSPoint(x: startX, y: startY))
            //context.restoreGState()
            if let gradient = gradient {
                //context.clip(to: NSRect(x: startX, y: startY, width: textSize.width, height: textSize.height))
                //gradient.draw(in: NSBezierPath(rect: NSRect(x: startX, y: startY, width: textSize.width, height: textSize.height)), angle: 0)
                gradient.draw(in: NSRect(x: startX, y: startY, width: textSize.width, height: textSize.height), angle: 0)
                //context.restoreGState()
            }
            context.restoreGState()
        }
    }
}

class GradientLabel: NSTextField {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let gradient = NSGradient(colors: [NSColor.red, NSColor.blue]) // Dégradé de couleur du texte
        
        if gradient != nil {
            let string = self.stringValue
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: gradient ?? NSColor.orange
            ]
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedString.draw(at: NSPoint(x: 20, y: 20)) // Position du texte dans la fenêtre
            //attributedString.draw(in: dirtyRect)
        }
    }
}

class TextGradient: NSView {
    var startColor =  NSColor(red: 0, green: 30/255, blue: 50/255, alpha: 1)
    var midColor = NSColor.purple
    var mid2Color = NSColor(red: 247/255, green: 186/255, blue: 0, alpha: 1)
    var endColor = NSColor.yellow
    var isShadow: Bool = false
    var text = "TOTO"
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        //let shadowOffset = 2
        //let circleDiameter = min(dirtyRect.height, dirtyRect.width)
        //print("Rect Height: \(dirtyRect.height) width: \(dirtyRect.width) diameter: \(circleDiameter)")
        //let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.orange]
        //let font = NSFont.systemFont(ofSize: 32)
        let font = NSFont.systemFont(ofSize: 32, weight: .bold)
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.orange, .font: font]
        //let attributedString = NSAttributedString(string: "TOTO")
        let attributedString = NSAttributedString(string: "TOTO", attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        
        context.saveGState()
        context.beginPath()
        context.textPosition = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height/2))
        CTLineDraw(line, context)
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
        let startPoint = CGPoint(x: dirtyRect.width/2, y: 0)
        let endPoint = CGPoint(x: dirtyRect.width/2, y: (dirtyRect.height))
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
        else {
            context.addArc(center: CGPoint(x: dirtyRect.width/2, y: dirtyRect.height/2), radius: (circleDiameter/2 - lineWidth), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi*2), clockwise: true)
            context.setStrokeColor(lineColor)
            context.strokePath()
        }
        context.restoreGState()
    }
}
