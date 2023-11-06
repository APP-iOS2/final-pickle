//
//  EntryPoint.swift
//  Pickle
//
//  Created by 박형환 on 11/4/23.
//

import SwiftUI

@main
final class Application {
    static func main() {
        if ProcessInfo.processInfo.isRunningTests {
            PickleAppTest.main()
        } else {
            PickleApp.main()
        }
    }
}
