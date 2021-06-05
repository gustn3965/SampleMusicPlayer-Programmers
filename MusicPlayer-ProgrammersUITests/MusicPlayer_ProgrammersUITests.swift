//
//  MusicPlayer_ProgrammersUITests.swift
//  MusicPlayer-ProgrammersUITests
//
//  Created by hyunsu on 2021/06/05.
//

import XCTest

class MusicPlayer_ProgrammersUITests: XCTestCase {

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                
                XCUIApplication(bundleIdentifier: "com.hyunsu.park.MusicPlayer-Programmers").launch()
            }
        }
    }
}

