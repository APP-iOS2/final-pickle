//
//  NotificationManager.swift
//  Pickle
//
//  Created by 최소정 on 10/10/23.
//

import SwiftUI
import UserNotifications

@MainActor
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
//    @Published var isGranted: Bool = UserDefaults.standard.bool(forKey: "hasUserAgreedNoti") {
//        didSet {
//            if isGranted {
//                // On Action - 1
//                UserDefaults.standard.set(true, forKey: "hasUserAgreedNoti")
//                requestNotiAuthorization()
//            } else {
//                // Off Action - 2
//                UserDefaults.standard.set(false, forKey: "hasUserAgreedNoti")
//                requestNotiAuthorization()
//            }
//        }
//    }
    
    // 현재 알림 설정 권한 담는 변수
    @Published var isGranted: Bool = false
    
    // MARK: SetNotiView DatePicker 연결, 알림 테스트용..삭제 예정
    @Published var notiTime: Date = Date() {
        didSet {
            // Set Notification with the Time - 3
            removeAllNotifications()
            addNotification(with: notiTime)
        }
    }
    
    // 설정탭에서 알림 설정 권장 Alert
    @Published var isAlertOccurred: Bool = false

    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // 앱이 실행중일때 알림이 도착하면 채택하여 구현한 메서드 호출, 사용자에게 배너와 소리로 알림 표시
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])
    }

    // 푸시 알림 권한 요청
    func requestNotiAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .alert])
        
        await getCurrentSetting()
    }
    
    // 현재 알림 설정 확인
    func getCurrentSetting() async {
        let currentSetting = await notificationCenter.notificationSettings()
        
        isGranted = (currentSetting.authorizationStatus == .authorized)
    }
    
    // MARK: SetNotiView DatePicker 연결, 알림 테스트용..삭제 예정
    func addNotification(with time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "🍕 현실도 피자~"
        content.body = "현실 도피는 이제 그만!"
        content.sound = UNNotificationSound.default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    // 알림 타입별 구분
    func scheduleNotification(localNotification: LocalNotification) {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = UNNotificationSound.default
        let repeats = localNotification.repeats
        
        switch localNotification.type {
        // 특정 날짜 및 시간에 알림 예약
        case .calendar:
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            notificationCenter.add(request)
        // 몇 초 후 알림
        case .time:
            guard let timeInterval = localNotification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            notificationCenter.add(request)
        }
    }
    
    func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()        // 전달된 노티피케이션 제거
        notificationCenter.removeAllPendingNotificationRequests()   // 보류중인 노티피케이션 제거
    }
        
    // 설정 앱으로 이동
    func openSettings() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
}
