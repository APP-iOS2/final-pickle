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
    
    var title: String
    @Binding var isTimeMissionSettingModalPresented: Bool
    @Binding var showSuccessAlert: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    missionStore.update(mission: .time(TimeMission(id: timeMission.id,
                                                                   title: timeMission.title,
                                                                   status: timeMission.status,
                                                                   date: timeMission.date,
                                                                   wakeupTime: timeMission.wakeupTime,
                                                                   changeWakeupTime: timeMission.wakeupTime)))
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
                    missionStore.update(mission: .time(TimeMission(id: timeMission.id,
                                                                   title: timeMission.title,
                                                                   status: timeMission.status,
                                                                   date: timeMission.date,
                                                                   wakeupTime: timeMission.wakeupTime,
                                                                   changeWakeupTime: timeMission.changeWakeupTime)))
                    updateAlarm()
                    showSuccessAlert.toggle()
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
            
            DatePicker("시간 선택", selection: $timeMission.changeWakeupTime,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
        }
        .padding()
    }
    
    func updateAlarm() {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: timeMission.changeWakeupTime)
        
        notificationManager.scheduleNotification(
            localNotification: LocalNotification(identifier: UUID().uuidString,
                                                 title: "현실도 피자",
                                                 body: "기상 미션을 완료하고 피자조각을 획득하세요!",
                                                 dateComponents: dateComponent,
                                                 repeats: true,
                                                 type: .wakeUp)
        )
    }
}

struct MissionSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TimeMissionSettingView(timeMission: .constant(TimeMission(id: "")),
                               title: "기상 미션",
                               isTimeMissionSettingModalPresented: .constant(true), showSuccessAlert: .constant(false))
    }
}
