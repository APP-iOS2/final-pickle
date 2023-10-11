//
//  UserStore.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI

final class UserStore: ObservableObject {
    
    @Published var user: User?
    
    @Injected(UserRepoKey.self) var userRepository: UserRepository
    
    init() { }
    
    @MainActor
    func fetchUser() async throws {
        self.user = await withCheckedContinuation { continuation in
            userRepository.getUser { [weak userRepository] value in
                if let value { continuation.resume(with: .success(value)) }
                else {
                    do {
                        try userRepository?.addUser()
                    } catch {
                        print("error: Failed")
                    }
                }
            }
        }
    }
}
