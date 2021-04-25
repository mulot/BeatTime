//
//  BeatClock.swift
//  BeatClock
//
//  Created by Julien Mulot on 24/04/2021.
//

import Foundation

class BeatClock: NSObject {
    static let UTCplus1Offset:Double = 3600
    var isCentiBeat = false

    func beatTime() -> String
    {
        var beats: Double
        var timeSeconds: TimeInterval
        var date: Date
        var daySeconds: TimeInterval
        
        date = Date()
        timeSeconds = date.timeIntervalSinceReferenceDate + BeatClock.UTCplus1Offset
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
