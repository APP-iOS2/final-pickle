//
//  MissionSettingView.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI

struct TimeMissionSettingView: View {
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var notificationManager: NotificationManager
    @Binding var timeMission: TimeMission
    @Binding var status: Status
    
    var title: String
    @Binding var isTimeMissionSettingModalPresented: Bool
    
    @State private var changedWakeupTime: Date = Date()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    isTimeMissionSettingModalPresented.toggle()
                } label: {
                    Text("취소")
                        .font(.pizzaBody)
                        .foregroundColor(.pickle)
                }
                Spacer()
                
                Text("\(title) 설정")
                    .font(.nanumEbTitle)
                Spacer()
                
                Button {
                    timeMission.wakeupTime = changedWakeupTime
                    
                    if status == .ready {
                        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: changedWakeupTime)
                        notificationManager.scheduleNotification(
                            localNotification: LocalNotification(identifier: UUID().uuidString,
                                                                 title: "기상 미션 알림",
                                                                 body: "기상 미션을 완료하고 피자조각을 획득하세요.",
                                                                 dateComponents: dateComponent,
                                                                 repeats: false,
                                                                 type: .calendar)
                        )
                        missionStore.update(mission: .time(TimeMission(id: timeMission.id,
                                                                       title: timeMission.title,
                                                                       status: timeMission.status,
                                                                       date: Date.now,
                                                                       wakeupTime: changedWakeupTime)))
                    }
                    isTimeMissionSettingModalPresented.toggle()
                } label: {
                    Text("저장")
                        .font(.pizzaBody)
                        .foregroundColor(.pickle)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            Divider()
            
            DatePicker("시간 선택", selection: $changedWakeupTime,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
        }
        .padding()
    }
}

struct MissionSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TimeMissionSettingView(timeMission: .constant(TimeMission(id: "")),
                               status: .constant(.ready),
                               title: "기상 미션",
                               isTimeMissionSettingModalPresented: .constant(true))
    }
}
