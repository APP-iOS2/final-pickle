//
//  UserStore.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI

final class UserStore: ObservableObject {
    
    @Injected(UserRepoKey.self) var userRepository: UserRepositoryProtocol
    
    @Published var user: User = User.defaultUser
    
    var pizzaSlice: Double {
        Double(user.currentPizzaSlice)
    }
    
    var pizzaCount: Int {
        user.currentPizzaCount
    }
    
    @MainActor
    func fetchUser() throws {
        do {
            self.user = try userRepository.fetchUser()
            Log.debug("user : \(user)")
        } catch {
            Log.error("failed : \(error)")
            throw error
        }
    }
    
    func addUser(default user: User = User.defaultUser) {
        do {
            try userRepository.addUser(model: user)
            self.user = user
        } catch {
            Log.error("Add User 발생")
            assert(false, "Add User error발생")
        }
    }
    
    func addPizzaSlice(slice count: Int) throws {
        let user = self.user.addPizzaSliceValidation(count: count)
        do {
            try userRepository.updateUser(model: user)
            self.user = user
        } catch {
            assert(false)
        }
    }
    
    func updateUser(user: User) async throws {
        do {
            try userRepository.updateUser(model: user)
        } catch {
            Log.error("update User Failed")
            assert(false, "update User Failed")
        }
    }
    
    /// 피자를 언락 하기 위한 메서드
    /// - Parameter pizza: 언락할 피자를 인자로 받는다
    func unLockPizza(pizza: Pizza) {
        self.user.unlockPizza(pizza: pizza)
        do {
            // try userRepository.updatePizza(model: model, specific: Date())
            try userRepository.updateUser(model: user)
        } catch {
            Log.error("\(error)")
        }
    }
    
    func deleteuserAll() {
        do {
            try userRepository.deleteAll()
        } catch {
            Log.error("\(error)")
        }
    }
}
