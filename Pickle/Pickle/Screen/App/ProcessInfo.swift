//
//  {rocessInfo.swift
//  Pickle
//
//  Created by 박형환 on 11/4/23.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
