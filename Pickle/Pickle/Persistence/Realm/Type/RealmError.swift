//
//  RealmError.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation

enum RealmError: Error {
    case realmError
    case notRealmObject
    case deleteFailed
    case saveFailed
    case invalidObjectORPrimaryKey
    case updateMustOneValue // 필터를 통해서 1개 이상의 value가 나왔을때
}
