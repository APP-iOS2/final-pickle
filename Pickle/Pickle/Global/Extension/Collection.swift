//
//  Collection.swift
//  Pickle
//
//  Created by 박형환 on 10/17/23.
//

import Foundation

// MARK: - Collection 에 접근할때 범위 체크 -> 안전배열
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
