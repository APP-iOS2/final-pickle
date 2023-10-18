//
//  UserRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation

protocol UserRepositoryProtocol: Dependency, AnyObject {
    func getUser(_ completion: @escaping (Result<User,PersistentedError>) -> Void)
    func fetchUser() throws -> User
    func addUser(model: User) throws
    func updateUser(model: User) throws
    func deleteAll() throws
}

final class UserRepository: BaseRepository<UserObject>, UserRepositoryProtocol {
    
    func fetchUser() throws -> User {
        do {
            let value = try super.fetch(UserObject.self,
                                        predicate: nil,
                                        sorted: nil)
            if let first = value.first {
                return User.mapFromPersistenceObject(first)
            } else {
                throw PersistentedError.fetchNothing
            }
        } catch {
            throw PersistentedError.fetchError
        }
    }
   
    func getUser(_ completion: @escaping (Result<User, PersistentedError>) -> Void) {
        super.fetch(UserObject.self,
                    predicate: nil,
                    sorted: Sorted.createdAscending,
                    completion: { user in
            if let userObject = user.first {
                let user = User.mapFromPersistenceObject(userObject)
                completion(.success(user))
            } else {
                completion(.failure(.fetchError))
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
    
    func deleteAll() throws {
        do {
            try super.deleteAll(UserObject.self)
        } catch {
            throw PersistentedError.deleteFailed
        }
    }
}
