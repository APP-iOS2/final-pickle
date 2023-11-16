//
//  UserStore.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI
import Combine

final class UserStore: ObservableObject {
    
    @Injected(UserRepoKey.self) var userRepository: UserRepositoryProtocol
    
    @Published var user: User = User.defaultUser
    @Published var currentPizza: CurrentPizza = .init(pizza: nil)
    
    var token: RNotificationToken?
    
    private var subscriptions = Set<AnyCancellable>()
    
    var pizzaSlice: Double {
        return Double(user.currentPizzas.map(\.currentPizzaSlice).reduce(0, +))
    }
    
    // TODO: 변경 필요 - currentPizza로 변경
    // 기존 user안에있는 slice와 count를 currentPizza 데이터 내부로 이동
    var pizzaCount: Int {
        user.currentPizzas.map(\.currentPizzaCount).reduce(0, +)
    }
    
    enum Action {
        case select(Pizza)
        case create
        case delete
    }
    
    func trigger(action: Action) {
        switch action {
        case .select(let pizza):
            Log.debug("pizza")
            self.selectCurrentPizza(pizza: pizza)
        case .create:
            break
        case .delete:
            break
        }
    }
    
    @MainActor
    func fetchUser() throws {
        do {
            self.user = try userRepository.fetchUser()
            // TODO: 변경 필요
            self.currentPizza = user.currentPizzas.filter { $0.pizza!.id == user.pizzaID }.first ?? self.user.currentPizzas.first!
            self.token?.invalidate()
            observeUser()
        } catch {
            Log.error("failed : \(error)")
            throw error
        }
    }
    
    deinit {
        self.token?.invalidate()
    }
    
    func selectCurrentPizza(pizza: Pizza) {
        user.updatePublihser(path: \.pizzaID, to: pizza.id)
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: false)
            .withUnretained(self)
            .map { store, model -> AnyPublisher<User, Never> in
                store.userRepository.update(seleted: model)
                    .replaceError(with: store.user)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sinkToResult(with: self) { store, result in
                switch result {
                case .success(let success):
                    store.user = success
                    store.currentPizza  = success.currentPizzas.filter { $0.pizza!.id == success.pizzaID }.first!
                    store.subscriptions.removeAll()
                case .failure(let failure):
                    Log.error("error occur : \(failure)")
                }
            }
            .store(in: &subscriptions)
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
        // let user = self.user.addPizzaSliceValidation(count: count)
        let currentPizza = self.currentPizza.addPizzaSliceValidation()
        Log.debug("add Pizza Slice: \(currentPizza.currentPizzaSlice)")
        let user = self.user.update(current: currentPizza)
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
    
    @MainActor
    private func observeUser() {
        // TODO: 변경 필요
        // 필요가 있나?
//        self.token = userRepository.observeUser(id: self.user.id,
//                                                keyPaths: [\.currentPizzaSlice, \.pizza]) {
//            change in
//            switch change {
//            case .change(let userObject, let propertys):
//                let user = User.mapFromPersistenceObject(userObject)
//                if self.user == user {
//                    Log.error("self.user == user")
//                } else {
//                    Log.error("self.user != user")
//                }
//                return
//            default:
//                break
//            }
//        }
    }
}
