//
//  BeatTime.swift
//  BeatTIme
//
//  Created by Julien Mulot on 24/04/2021.
//

import Foundation

class BeatTime: NSObject {
    private static let UTCplus1Offset:Double = 3600
    var isCentiBeat = false

    func beats(date: Date = Date()) -> String
    {
        var beats: Double
        var timeSeconds: TimeInterval
        var daySeconds: TimeInterval
        
        timeSeconds = date.timeIntervalSinceReferenceDate + BeatTime.UTCplus1Offset
        daySeconds = timeSeconds.truncatingRemainder(dividingBy: 86400)
        beats = (daySeconds * 1000) / 86400
        //print(".beat @\(Int(beats))")
        if (isCentiBeat) {
            //print(".beat @\(String(format: "%.2f", beats))")
            return String(format: "%.2f", beats)
        }
        else {
            //print(".beat @\(Int(beats))")
            return(String(Int(beats)))
        }
    }
}
