//
//  MappableProtocol.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

protocol MappableProtocol {
    associatedtype PersistenceType: Storable
    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
}
