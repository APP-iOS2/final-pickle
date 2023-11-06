//
//  UserStoreTest.swift
//  PickleTests
//
//  Created by 박형환 on 11/4/23.
//

import XCTest
@testable import Pickle

@MainActor
final class UserStoreTest: XCTestCase {
    
    var sut: UserStore!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Self.setUpTodoDependency()
        sut = UserStore()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.deleteuserAll()
        sut = nil
    }
    
    /// 유저 add후 fetch UUID가 아닌 ObjectID 불일치
    /// id만 ObjectID 변경후 일치하는지 테스트
    func test_create_user() async throws {
        // Given
        let user = User.defaultUser
        
        // When
        sut.addUser(default: user)
        try sut.fetchUser()
        let newIDUser = user.changedID(user: sut.user)
        
        // Then
        XCTAssertNotEqual(user, sut.user)
        XCTAssertEqual(newIDUser, sut.user)
    }
    
    /// 유저 Pizza 전체 잠금 update 테스트
    /// 1. 유저 추가
    /// 2. 모든 pizza 를 keypath 를 이용해서 lock 을 true 변경후 업데이트
    /// 3. fetch후 업데이트 확인
    func test_update_pizza() async throws {
        // Given
        let user = User.defaultUser
        sut.addUser(default: user)
        try sut.fetchUser()
        let newIDUser = user.changedID(user: sut.user)
        let pizzas = newIDUser.pizzas
        
        let updatedPizzas
        = try pizzas.compactMap { pizza in
            try pizza.update(path: \.lock, to: true)
        }
        let updatedUser = try newIDUser.update(path: \.pizzas, to: updatedPizzas)
        
        let pizzalockCount = pizzas.filter(\.lock).count
        let lockCount = updatedUser.pizzas.filter(\.lock).count
        
        // When
        try await sut.updateUser(user: updatedUser)
        try sut.fetchUser()
        
        // Then
        XCTAssertEqual(sut.user, updatedUser)
        XCTAssertEqual(Pizza.allCasePizza.count, pizzas.count)
        XCTAssertEqual(lockCount, pizzas.count)
        XCTAssertNotEqual(pizzalockCount, lockCount)
    }
    
    /// 특정 피자만 unlock 하는 update 테스트
    /// 1. 유저 추가
    /// 2. unlockPizza 메소드 호출
    /// 3. fetch 호출
    /// 4. 결과 확인
    func test_update_specific_pizza() async throws {
        // Given
        try await addingAndFetchUser()
        let potato = sut.user.pizzas.filter { $0.image == "potato" }.first!
        XCTAssertEqual(potato.lock, true)
        
        // When
        sut.unLockPizza(pizza: potato)
        try sut.fetchUser()
        
        // Then
        let potatoPizzas = sut.user.pizzas.filter { $0.image == "potato" }.first!
        XCTAssertEqual(potatoPizzas.lock, false)
    }
    
    /// User가 가지고 있는 pizzaSlice 업데이트 테스트
    /// 1. 유저 추가
    /// 2. 피자 조각 업데이트
    /// 3. 현재 피자조각 8개 이상일시 피자 한판 추가 후 피자 조각 0으로 초기화 테스트
    /// 4. 결과 확인
    func test_update_pizza_slice() async throws {
        // Given
        try await addingAndFetchUser()
        
        // When
        // 피자 조각 1개 추가
        try self.sut.addPizzaSlice(slice: 4)
        
        await waitTask(for: 0.3)
        XCTAssertEqual(self.sut.user.currentPizzaSlice, 4)
        
        try self.sut.addPizzaSlice(slice: 4)
        await waitTask(for: 0.3)
        
        // Then
        XCTAssertEqual(sut.user.currentPizzaCount, 1)
        XCTAssertEqual(sut.user.currentPizzaSlice, 0)
    }
    
    /// Default User 추가후 fetch해오는 함수
    private func addingAndFetchUser() async throws {
        let user = User.defaultUser
        sut.addUser(default: user)
        try sut.fetchUser()
        // let newIDUser = user.changedID(user: sut.user)
    }
}

extension User {
    func changedID(user: User) -> User {
        let pizzas = user.pizzas
        let originalPizzas = self.pizzas
        let newPizzas = zip(pizzas, originalPizzas).map { original, newPizza in
            Pizza(id: newPizza.id,
                  name: original.name,
                  image: original.image,
                  lock: original.lock,
                  createdAt: original.createdAt)
        }
        
        return User.init(id: user.id,
                         nickName: self.nickName,
                         currentPizzaCount: self.currentPizzaCount,
                         currentPizzaSlice: self.currentPizzaSlice,
                         pizzas: newPizzas,
                         currentPizzas: [],
                         createdAt: self.createdAt)
    }
}

extension UserStoreTest {
    static func setUpTodoDependency() {
        DependencyContainer.register(DBStoreKey.self, RealmStore(type: .inmemory))
        DependencyContainer.register(UserRepoKey.self, UserRepository())
    }
}
