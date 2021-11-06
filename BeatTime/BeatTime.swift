//
//  BeatTime.swift
//  BeatTIme
//
//  Created by Julien Mulot on 24/04/2021.
//

import Foundation

class BeatTime: NSObject {
    /// Standard offset in seconds between UTC timezone and Beat time reference timezone
    private static let UTCplus1Offset:Double = 3600
    
    /// Convert a Date (local 24-hour time) to beat time
    /// - Parameters:
    ///   - date: Date to convert
    ///   - centiBeats: option to display centieme of beats
    /// - Returns: beat time as String
    func beats(date: Date = Date(), centiBeats: Bool = false) -> String
    {
        var beats: Double
        var timeSeconds: TimeInterval
        var daySeconds: TimeInterval
        
        timeSeconds = date.timeIntervalSinceReferenceDate + BeatTime.UTCplus1Offset
        daySeconds = timeSeconds.truncatingRemainder(dividingBy: 86400)
        beats = (daySeconds * 1000) / 86400
        //print(".beat @\(Int(beats))")
        if (centiBeats) {
            //print(".beat @\(String(format: "%.2f", beats))")
            return String(format: "%.2f", beats)
        }
        else {
            //print(".beat @\(Int(beats))")
            return(String(Int(beats)))
        }
    }
    
    /// Convert a beat time to a Date (local 24-hour time)
    /// - Parameter beats: beat time
    /// - Returns: Date
    func date(beats: String) -> Date
    {
        var seconds: Double
        
        if let beattime = Double(beats) {
            if (beattime >= 0 && beattime <= 1000) {
                seconds = beattime / 1000 * 86400 - BeatTime.UTCplus1Offset
                return(Date(timeIntervalSinceReferenceDate: seconds))
            }
        }
        return(Date())
    }
}
