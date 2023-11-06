//
//  XCTestCase-extension.swift
//  PickleTests
//
//  Created by 박형환 on 11/4/23.
//

import XCTest

extension XCTestCase {
    func waitTask(for timeInterval: TimeInterval = 0.5) async {
        let expectation = XCTestExpectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }
}
