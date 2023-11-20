//
//  NotificationService.swift
//  Pickle
//
//  Created by 박형환 on 11/10/23.
//

import Foundation

protocol NotificationService: AnyObject {
    var mediator: Mediator { get }
    func post(notification type: NotiType) async
    func receive(notification type: NotiType) async
}
