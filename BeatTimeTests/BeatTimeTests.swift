//
//  BeatTimeTests.swift
//  BeatTimeTests
//
//  Created by Julien Mulot on 26/11/2025.
//

import Testing
import Foundation

struct BeatTimeTests {

    @Test("Convert known Date to beats (midnight CET)")
    func testMidnightToBeats() async throws {
        // Construct a UTC date that becomes BMT midnight after the +1h shift.
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = DateComponents()
        components.year = 2021
        components.month = 4
        components.day = 23
        components.hour = 23 // 23:00 UTC + 1h = 00:00 BMT on 2021-04-24
        components.minute = 0
        components.second = 0
        components.timeZone = calendar.timeZone
        let date = try #require(calendar.date(from: components))
        let beats = BeatTime.beats(date: date)
        #expect(beats == "0")
    }
    
    @Test("Convert noon to beats (CET)")
    func testNoonToBeats() async throws {
        // Construct a UTC date that becomes BMT noon after the +1h shift.
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = DateComponents()
        components.year = 2021
        components.month = 4
        components.day = 24
        components.hour = 11 // 11:00 UTC + 1h = 12:00 BMT on 2021-04-24
        components.minute = 0
        components.second = 0
        components.timeZone = calendar.timeZone
        let date = try #require(calendar.date(from: components))
        let beats = BeatTime.beats(date: date)
        #expect(beats == "500")
    }
    
    @Test("Convert beats to Date")
    func testBeatsToDate() async throws {
        let beats = "500"
        let date = BeatTime.date(beats: beats)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let hour = calendar.component(.hour, from: date)
        // 500 beats = 12:00 BMT (UTC+1), which is 11:00 UTC
        #expect(hour == 11)
    }
    
    @Test("Validate valid and invalid beat strings")
    func testValidateBeats() async throws {
        #expect(BeatTime.validate("0") == true)
        #expect(BeatTime.validate("1000") == true)
        #expect(BeatTime.validate("500.5") == true)
        #expect(BeatTime.validate("-1") == false)
        #expect(BeatTime.validate("1000.1") == false)
        #expect(BeatTime.validate("abc") == false)
    }
    
    @Test("Test centiBeats and fullDigits formatting")
    func testFormattingOptions() async throws {
        // 12:00:00 CET
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2021
        components.month = 4
        components.day = 24
        components.hour = 11 // 11:00 UTC + 1h = 12:00 BMT on 2021-04-24
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = try #require(calendar.date(from: components))
        let centi = BeatTime.beats(date: date, centiBeats: true, fullDigits: false)
        let centiFull = BeatTime.beats(date: date, centiBeats: true, fullDigits: true)
        let intFull = BeatTime.beats(date: date, centiBeats: false, fullDigits: true)
        #expect(centi.starts(with: "500"))
        #expect(centiFull.starts(with: "500.00"))
        #expect(intFull == "500")
    }
    
    @Test("Test hoursOffsetWithGMT and hoursOffsetWithBMT")
    func testOffsets() async throws {
        let offsetGMT = BeatTime.hoursOffsetWithGMT(date: Date())
        let offsetBMT = BeatTime.hoursOffsetWithBMT(date: Date())
        #expect(offsetBMT == offsetGMT - 1)
    }
}

