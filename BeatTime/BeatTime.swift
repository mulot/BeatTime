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
    static func beats(date: Date = Date(), centiBeats: Bool = false, fullDigits: Bool = false) -> String
    {
        var beats: Double
        var timeSeconds: TimeInterval
        var daySeconds: TimeInterval
        
        timeSeconds = date.timeIntervalSinceReferenceDate + BeatTime.UTCplus1Offset
        daySeconds = timeSeconds.truncatingRemainder(dividingBy: 86400)
        beats = (daySeconds * 1000) / 86400
        //print(".beat @\(Int(beats))")
        if (centiBeats) {
            if (fullDigits) {
                //print(".beat @\(String(format: "%06.2f", beats))")
                return String(format: "%06.2f", beats)
            }
            else {
                //print(".beat @\(String(format: "%.2f", beats))")
                return String(format: "%.2f", beats)
            }
        }
        if (fullDigits) {
            return String(format: "%03d", Int(beats))
        }
        else {
            //print(".beat @\(Int(beats))")
            return(String(Int(beats)))
        }
    }
    
    /// Convert a beat time to a Date (local 24-hour time)
    /// - Parameter beats: beat time
    /// - Returns: Date
    static func date(beats: String) -> Date
    {
        var seconds: Double
        
        if let beattime = Double(beats) {
            if (beattime >= 0 && beattime <= 1000) {
                seconds = beattime / 1000 * 86400
                let date = Date()
                let calendar = Calendar.current
                var dateComponents = DateComponents()
                dateComponents.year = calendar.component(.year, from: date)
                dateComponents.month = calendar.component(.month, from: date)
                dateComponents.day = calendar.component(.day, from: date)
                dateComponents.timeZone = TimeZone(abbreviation: "CET")
                dateComponents.hour = 0
                dateComponents.minute = 0

                if (TimeZone.autoupdatingCurrent.isDaylightSavingTime()) {
                    //print("Daylight On")
                    dateComponents.hour = 1 // UTC+1 Offset
                }

                if let someDateTime = calendar.date(from: dateComponents) {
                    //let secondsSinceRefDate = someDateTime.timeIntervalSinceReferenceDate + BeatTime.UTCplus1Offset + seconds
                    let secondsSinceRefDate = someDateTime.timeIntervalSinceReferenceDate + seconds
                    /*
                    print("Start Date: \(someDateTime)")
                    print("Date converted: \(Date(timeIntervalSinceReferenceDate: secondsSinceRefDate))")
                    print("Date ref: ", Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate))
                    print("beats converted seconds: \(seconds) hours: \(Int(seconds/3600)) minutes: \(Int(seconds)%3600/60)")
                    print("seconds since Ref UTC Date: \(Date.timeIntervalSinceReferenceDate)")
                    print("converted seconds since Ref UTC Date: \(secondsSinceRefDate)\n")
                     */
                    return(Date(timeIntervalSinceReferenceDate: secondsSinceRefDate))
                }
            }
        }
        return(Date())
    }
    
    /// Return the difference between LocalTimeZone and GMT
    /// - Parameter date: local date
    /// - Returns: Difference in hours (negative or positive)
    static func hoursOffsetWithGMT(date: Date = Date()) -> Int
    {
        //print(TimeZone.current.identifier)
        //print(TimeZone.abbreviationDictionary)
        //let seconds = TimeZone.init(identifier: "JST")!.secondsFromGMT(for: date)
        let seconds = TimeZone.current.secondsFromGMT(for: date)
        let hours = seconds / 3600
        //print("seconds: \(seconds) hours: \(hours)")
        return(hours)
    }
    
    /// Return the difference between LocalTimeZone and BMT (Biel Mean Time / CET / GMT+1)
    /// - Parameter date: local date
    /// - Returns: Difference in hours (negative or positive)
    static func hoursOffsetWithBMT(date: Date = Date()) -> Int
    {
        return(hoursOffsetWithGMT(date: date) - 1)
    }
    
    static func validate(_ beats: String) -> Bool {
        if let beattime = Int(beats) {
            if (beattime >= 0 && beattime <= 1000) {
                return true
            }
        }
        return false
    }
}
