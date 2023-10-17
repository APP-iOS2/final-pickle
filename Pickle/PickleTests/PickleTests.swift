//
//  PickleTests.swift
//  PickleTests
//
//  Created by 박형환 on 10/14/23.
//

import XCTest
@testable import Pickle

final class PickleTests: XCTestCase {
    
    var sut: TodoStore!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        @Injected(DBStoreKey.self) var dbStore: DBStore
        
        Self.setUpDependency()
        sut = TodoStore()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
    
    func test_addSuccessValue_TodoStore() async throws {
        let todo = Todo.init(id: UUID().uuidString, content: "", startTime: Date(), targetTime: TimeInterval(), spendTime: Date(), status: .done)
        await sut.add(todo: todo)
        let value = await sut.todos
        XCTAssertEqual(value, [todo])
    }
    
    func test_AddFaildValue_TodoStore() async throws {
        let todo = Todo.init(id: "", content: "", startTime: Date(), targetTime: TimeInterval(), spendTime: Date(), status: .done)
        await sut.add(todo: todo)
        let value = await sut.todos
        XCTAssertEqual(value, [todo])
    }
    

    static func setUpDependency() {
        DependencyContainer.register(DBStoreKey.self, TestStore())
        DependencyContainer.register(TodoRepoKey.self, TodoRepository())
    }
}

struct TestStoreKey: InjectionKey {
    typealias Value = TestStore
    static var type: DependencyType = .automatic
}

struct TestStore: DBStore {
    func create<T>(_ model: T.Type, completion: @escaping (T) -> Void) throws where T: Pickle.Storable {
        fatalError()
    }
    
    func save(object: Pickle.Storable) throws {
        return
    }
    
    func update(object: Pickle.Storable) throws {
        fatalError()
    }
    
    func delete(object: Pickle.Storable) throws {
        fatalError()
    }
    
    func delete<T>(model: T.Type, id: String) throws where T : Pickle.Storable {
        fatalError()
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T : Pickle.Storable {
        fatalError()
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Pickle.Sorted?, complection: ([T]) -> Void) throws where T : Pickle.Storable {
        fatalError()
    }
}
