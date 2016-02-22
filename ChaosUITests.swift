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
		let coordinate = getRandomCoordinate()
		let device = XCUIDevice.sharedDevice()
		switch randomGestureID {
		case 0:
			coordinate.tap()
		case 1:
			coordinate.doubleTap()
		case 2:
			// Scroll up
			let maxY = app.windows.elementBoundByIndex(0).frame.size
			let startY = coordinate.screenPoint.y
			let dy = (startY * getRandomValueBetween0And1()) / maxY.height
			let vector = CGVector(dx: coordinate.screenPoint.x / maxY.width, dy: dy)
			scroll(coordinate, toCoordinate: getCoordinateForVector(vector))
		case 3:
			// Scroll down
			let maxY = app.windows.elementBoundByIndex(0).frame.size
			let startY = coordinate.screenPoint.y
			let dy = ((maxY.height - startY) * getRandomValueBetween0And1() + startY) / maxY.height
			let vector = CGVector(dx: coordinate.screenPoint.x / maxY.width, dy: dy)
			scroll(coordinate, toCoordinate: getCoordinateForVector(vector))
		case 4:
			// Scroll left
			let maxX = app.windows.elementBoundByIndex(0).frame.size
			let startX = coordinate.screenPoint.x
			let dx = (startX * getRandomValueBetween0And1()) / maxX.width
			let vector = CGVector(dx: dx, dy: coordinate.screenPoint.y / maxX.height)
			scroll(coordinate, toCoordinate: getCoordinateForVector(vector))
		case 5:
			// Scroll right
			let maxX = app.windows.elementBoundByIndex(0).frame.size
			let startX = coordinate.screenPoint.x
			let dx = ((maxX.width - startX) * getRandomValueBetween0And1() + startX) / maxX.width
			let vector = CGVector(dx: dx, dy: coordinate.screenPoint.y / maxX.height)
			scroll(coordinate, toCoordinate: getCoordinateForVector(vector))
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
			// Move in a completely random direction
			scroll(coordinate, toCoordinate: getRandomCoordinate())
		case 13:
			coordinate.pressForDuration(2)
		default:
			XCTFail("Random number failure - unhandled case for number: \(randomGestureID)")
		}
		print("Executed gesture \(randomGestureID) on coordinate: \(coordinate)")

		// Wait for cooldown period
		sleep(minimumGestureFrequency)
	}

	private func getRandomCoordinate() -> XCUICoordinate {
		let randomX = getRandomValueBetween0And1()
		let randomY = getRandomValueBetween0And1()

		let randomVector = CGVector(dx: randomX, dy: randomY)
		let coordinate = getCoordinateForVector(randomVector)

		return coordinate
	}

	private func getCoordinateForVector(vector: CGVector) -> XCUICoordinate {
		let window = app.windows.elementBoundByIndex(0)
		let coordinate = window.coordinateWithNormalizedOffset(vector)
		return coordinate
	}

	private func getRandomValueBetween0And1() -> CGFloat {
		return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
	}

	private func scroll(fromCoordinate: XCUICoordinate, toCoordinate: XCUICoordinate) {
		fromCoordinate.pressForDuration(0, thenDragToCoordinate: toCoordinate)
	}

}
