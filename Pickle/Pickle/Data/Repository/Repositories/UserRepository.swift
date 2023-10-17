//
//  UserRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation

protocol UserRepositoryProtocol: Dependency, AnyObject {
    func getUser(_ completion: @escaping (User?) -> Void)
    func addUser(model: User) throws
    func updateUser(model: User) throws
}

final class UserRepository: BaseRepository<UserObject>, UserRepositoryProtocol {
    
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
    
    func addUser(model: User) throws {
        let object = model.mapToPersistenceObject()
        do {
            try super.save(object: object)
        } catch {
            throw PersistentedError.addFaild
        }
    }
    
    func updateUser(model: User) throws {
        let object = model.mapToPersistenceObject()
        do {
            try super.update(object: object)
        } catch {
            throw PersistentedError.addFaild
        }
    }
}
