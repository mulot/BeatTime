//
//  BeatTime.swift
//  BeatTime
//
//  Created by Julien Mulot on 24/04/2021.
//

import Foundation

struct BeatTime {
    /// Number of seconds in a day
    private static let secondsPerDay: Double = 86_400
    /// Number of beats in a day
    private static let beatsPerDay: Double = 1000
    /// Standard offset in seconds between UTC and Beat time reference timezone (UTC+1)
    private static let utcPlus1Offset: Double = 3_600

    /// Convert a Date (local 24-hour time) to beat time
    /// - Parameters:
    ///   - date: Date to convert
    ///   - centiBeats: Option to display centieme of beats
    ///   - fullDigits: Option to always display 3-digit integer part
    /// - Returns: Beat time as String
    static func beats(date: Date = Date(), centiBeats: Bool = false, fullDigits: Bool = false) -> String {
        let adjustedTime = date.timeIntervalSinceReferenceDate + utcPlus1Offset
        let daySeconds = adjustedTime.truncatingRemainder(dividingBy: secondsPerDay)
        let beatValue = (daySeconds * beatsPerDay) / secondsPerDay
        
        if centiBeats {
            return fullDigits
                ? String(format: "%06.2f", beatValue)
                : String(format: "%.2f", beatValue)
        } else {
            return fullDigits
                ? String(format: "%03d", Int(beatValue))
                : String(Int(beatValue))
        }
    }
    
    /// Convert a beat time (can be centibeats) to a Date (local 24-hour time)
    /// - Parameter beats: Beat time string
    /// - Returns: Corresponding Date
    static func date(beats: String) -> Date {
        guard let beatValue = Double(beats), beatValue >= 0, beatValue <= beatsPerDay else {
            return Date()
        }
        // Seconds since midnight in CET (UTC+1)
        let seconds = (beatValue / beatsPerDay) * secondsPerDay
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.timeZone = TimeZone(abbreviation: "CET")
        components.hour = 0
        components.minute = 0
        // Add UTC+1 offset if DST is on (local time matches BMT reference)
        if TimeZone.autoupdatingCurrent.isDaylightSavingTime() {
            components.hour = 1
        }
        guard let dayStart = calendar.date(from: components) else {
            return Date()
        }
        return Date(timeInterval: seconds, since: dayStart)
    }

    /// Return the difference between the local timezone and GMT, in hours
    /// - Parameter date: Local date
    /// - Returns: Difference in hours (negative or positive)
    static func hoursOffsetWithGMT(date: Date = Date()) -> Int {
        TimeZone.current.secondsFromGMT(for: date) / 3600
    }

    /// Return the difference between the local timezone and BMT (Biel Mean Time / CET / GMT+1), in hours
    /// - Parameter date: Local date
    /// - Returns: Difference in hours (negative or positive)
    static func hoursOffsetWithBMT(date: Date = Date()) -> Int {
        hoursOffsetWithGMT(date: date) - 1
    }

    /// Validate that a beat string is a valid value, supporting decimals
    /// - Parameter beats: Beat string
    /// - Returns: True if valid (between 0 and 1000)
    static func validate(_ beats: String) -> Bool {
        if let beatValue = Double(beats) {
            return beatValue >= 0 && beatValue <= beatsPerDay
        }
        return false
    }
}
