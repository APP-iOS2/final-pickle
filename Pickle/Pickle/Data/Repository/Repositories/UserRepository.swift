//
//  UserRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import Foundation
import RealmSwift

// TODO: User Interactor 적용 해보기
    // 1. 현재 뷰 OR Store(ViewModel) 에서 Bussiness로직이 강하게 결합되어있음
    // 2. Interactor를 사용하여 도메인 로직 분리 필요해 보임 - 논의 해보기
    // 3. 상속 여부 현재 BaseRepository를 사용하여 상속 관계를 형성하여 메소드 자동생성 편의성이 올라가긴했음
    //  3-1 DownSide고려하여 Repository 추상화 결정해야함

protocol UserRepositoryProtocol: Dependency, AnyObject {
    func getUser(_ completion: @escaping (Result<User,PersistentedError>) -> Void)
    func fetchUser() throws -> User
    func addUser(model: User) throws
    func updateUser(model: User) throws
    func updatePizza(model: User, specific data: Date) throws
    func deleteAll() throws
    
    /// User Notification Change Observe function
    /// - Parameters:
    ///   - id: specific ID
    ///   - keyPaths: observe KeyPath
    /// - Returns: NotificationToken
    func observeUser(id: String,
                     keyPaths: [PartialKeyPath<UserObject>],
                     _ completion: @escaping ObjectCompletion<UserObject>) -> RNotificationToken
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
                throw PersistentedError.fetchUserError
            }
        } catch {
            throw PersistentedError.fetchUserError
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
    
    /// Realm FilterTest
    /// - Parameters:
    ///   - model: userModel
    ///   - data: not using
    func updatePizza(model: User, specific data: Date) throws {
        let object = model.pizzas.map { $0.mapToPersistenceObject() }
        let object2: RealmFilter<PizzaObject> = { value in
            value.lock
        }
        do {
            _ = try dbStore.update(PizzaObject.self,
                               item: object.first!,
                               query: object2)
        } catch {
            Log.error("update User Pizza \(error)")
        }
    }
    
    func deleteAll() throws {
        do {
            try super.deleteAll(UserObject.self)
        } catch {
            throw PersistentedError.deleteFailed
        }
    }
    
    func observeUser(id: String, 
                     keyPaths: [PartialKeyPath<UserObject>],
                     _ completion: @escaping ObjectCompletion<UserObject>) -> RNotificationToken {
        do {
            return try self.dbStore.notificationToken(UserObject.self,
                                                      id: id,
                                                      keyPaths: keyPaths,
                                                      completion)
        } catch {
            Log.error("error occur notification token")
            assert(false, "failed get observed User Token ")
        }
    }
}
