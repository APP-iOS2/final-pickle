//
//  Mediator.swift
//  Pickle
//
//  Created by 박형환 on 11/10/23.
//

import Foundation

protocol Mediator: AnyObject {
    static var shared: Mediator { get set }
    var manager: NotificationService? { get set }
    var navigation: NotificationService? { get set }
    func notify(notification type: NotiType) async
}
