//
//  NotificationMediator.swift
//  Pickle
//
//  Created by 박형환 on 11/10/23.
//

import Foundation

final class NotiMediator: Mediator {
    
    weak var manager: NotificationService?
    weak var navigation: NotificationService?
    
    static var shared: Mediator = NotiMediator()
    
    init(manager: NotificationService? = nil,
         navigation: NotificationService? = nil) {
        self.manager = manager
        self.navigation = navigation
    }
    
    func notify(todo: Todo) async {
        await navigation?.receive(info: todo)
    }
}
