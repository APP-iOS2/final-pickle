//
//  UserStore.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI

@MainActor
final class UserStore: ObservableObject {
    
    @Injected(UserRepoKey.self) var userRepository: UserRepositoryProtocol
    
    @Published var user: User = User.defaultUser
    
    var pizzaSlice: Double {
        Double(user.currentPizzaSlice)
    }
    
    var pizzaCount: Int {
        user.currentPizzaCount
    }
    
    func fetchUser() async throws {
        self.user = await withCheckedContinuation { continuation in
            userRepository.getUser { [weak self] value in
                if let value {
                    continuation.resume(with: .success(value))
                } else {
                    self?.addUser()
                }
            }
        }
        Log.debug("\(String(describing: user))")
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
}
