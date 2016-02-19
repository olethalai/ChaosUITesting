//
//  ChaosUITests.swift
//  ChaosUITests
//
//  Created by Oletha Lai on 19/02/2016.
//  Copyright © 2016 Oletha Lai. All rights reserved.
//

import XCTest

class ChaosUITests: XCTestCase {

    let minimumGestureFrequency: UInt32 = 1 // Minimum amount of time to pass between gestures in seconds
    let duration: Double = 60 * 3 // Execution time limit in seconds
    let gestureLimit: UInt = 100 // Number of gestures to be executed
    let gestureTypeCount: UInt32 = 14 // Number of types of gesture available
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        // In these chaos tests, why not continue after failure, if nothing's crashed? CHAOS!
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChaosHandlingForDuration() {
        // Create a loop for the given time limit
        let end = NSDate(timeIntervalSinceNow: duration)
        while NSDate().compare(end) == NSComparisonResult.OrderedAscending {
            // Execute a gesture based on the random number
            executeRandomGesture()
        }
    }

    func testChaosHandlingUntilGestureLimit() {
        // Loop for as many times as the gesture limit allows
        for _ in 0..<gestureLimit {
            executeRandomGesture()
        }
    }

    private func executeRandomGesture() {
        let randomGestureID = arc4random_uniform(gestureTypeCount)
        let elementCount = UInt32(app.windows.descendantsMatchingType(.Any).count)
        if elementCount > 0 {
            let randomNumber = arc4random_uniform(elementCount)
            let element = app.windows.descendantsMatchingType(.Any).elementBoundByIndex(UInt(randomNumber))
            let device = XCUIDevice()
            if element.hittable {
                switch randomGestureID {
                case 0:
                    element.tap()
                case 1:
                    element.doubleTap()
                case 2:
                    element.swipeUp()
                case 3:
                    element.swipeDown()
                case 4:
                    element.swipeLeft()
                case 5:
                    element.swipeRight()
                case 6:
                    device.orientation = .Portrait
                case 7:
                    device.orientation = .PortraitUpsideDown
                case 8:
                    device.orientation = .LandscapeLeft
                case 9:
                    device.orientation = .LandscapeRight
                case 10:
                    device.orientation = .FaceUp
                case 11:
                    device.orientation = .FaceDown
                case 12:
                    element.twoFingerTap()
                case 13:
                    element.pressForDuration(2)
                default:
                    XCTFail("Random number failure - unhandled case for number: \(randomGestureID) on element type: \(element.elementType)")
                }
                print("Executed gesture \(randomGestureID) on element")
            }
        } else {
            print("Failed to execute gesture")
        }
        // Wait for cooldown period
        sleep(minimumGestureFrequency)
    }
}
