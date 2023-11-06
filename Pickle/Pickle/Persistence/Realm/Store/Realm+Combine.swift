//
//  Realm+Combine.swift
//  Pickle
//
//  Created by 박형환 on 11/6/23.
//

import Foundation
import Combine
import RealmSwift

extension RealmStore {
    // var subscriptions = Set<AnyCancellable>()
    
    func fetchPublisher<T: Storable>(_ model: T.Type,
                                     query: RealmFilter<T>)
    -> AnyPublisher<[T], Error> where T: RObject {
        realmStore.objects(model)
            .where(query)
            .collectionPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .freeze()
            .compactMap { ob in ob.compactMap { $0 as T } }
            .eraseToAnyPublisher()
    }
}
