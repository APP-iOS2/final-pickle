//
//  RealmError.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation



enum RealmError: Error {
    case notRealmObject
    case deleteFailed
    case saveFailed
    case invalidObjectORPrimaryKey
}
