//
//  UserRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation


protocol UserRepositoryProtocol: Dependency {
    
}

final class UserRepository: BaseRepository<UserObject>, UserRepositoryProtocol {
    //    required init(dbStore: DBStore) {
    //        super.init(dbStore: dbStore)
    //    }
    
    func getUser(_ completion: @escaping (User?) -> Void) {
        super.fetch(UserObject.self,
                    predicate: nil,
                    sorted: Sorted.createdAscending,
                    completion: { user in
            if let userObject = user.first {
                let user = User.mapFromPersistenceObject(userObject)
                completion(user)
            } else {
                completion(nil)
            }
        })
    }
    
    func addUser() throws {
        do {
            try super.save(object: UserObject(nickName: "Guest",
                                              currentPizzaCount: 0,
                                              currentPizzaSlice: 0,
                                              createdAt: Date()))
        } catch {
            throw PersistentedError.addFaild
        }
    }
}
