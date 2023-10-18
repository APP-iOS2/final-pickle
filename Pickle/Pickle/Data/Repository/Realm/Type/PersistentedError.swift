//
//  PersistentedError.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation

enum PersistentedError: Error {
    case fetchNothing
    case fetchError
    case addFaild
    case saveFailed
    case createFailed
    case updateFaild
    case deleteFailed
    case deleteAllFailed
}
