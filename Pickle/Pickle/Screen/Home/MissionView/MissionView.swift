//
//  MissionView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct MissionView: View {
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var healthKitStore: HealthKitStore
    
    @AppStorage("is24HourClock") var is24HourClock: Bool = true
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    
    @State private var showsAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    
    @State private var timeMissions: [TimeMission] = [
        TimeMission(id: UUID().uuidString, title: "기상 미션", status: .done, date: Date(), wakeupTime: Date())
    ]
    @State private var behaviorMissions: [BehaviorMission] = [
        BehaviorMission(id: UUID().uuidString, title: "걷기 미션", status: .ready, status1: .ready, status2: .ready, date: Date())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(timeMissions.indices, id: \.self) { index in
                    if let mission = timeMissions[safe: index] {
                        TimeMissionStyleView(timeMission: $timeMissions[index], showsAlert: $showsAlert, showSuccessAlert: $showSuccessAlert)
                    }
                }
                
                ForEach(behaviorMissions.indices, id: \.self) { index in
                    if let mission = behaviorMissions[safe: index] {
                        BehaviorMissionStyleView(behaviorMission: $behaviorMissions[index], showsAlert: $showsAlert, healthKitStore: healthKitStore)
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
            healthKitStore.fetchStepCount()
            
            let (_timeMissions, _behaviorMissions) = missionStore.fetch()
            timeMissions = _timeMissions
            behaviorMissions = _behaviorMissions
            
            //TODO: 내일 기상 미션 알림 확인하기 -> 백그라운드에서 wakeupTime에 changeWakeupTime이 적용됐는지
            // 적용됐으면 알림은 울렸는지 오후 1:00
            print(timeMissions.first?.date) // Optional(2023-11-10 11:19:32 +0000)
            print(timeMissions.first?.wakeupTime) // Optional(2023-11-10 11:19:32 +0000)
            print(timeMissions.first?.changeWakeupTime) // Optional(2023-11-10 04:00:32 +0000)
            if let firstTimeMission = timeMissions.first, firstTimeMission.date.format("yyyy-MM-dd") != Date().format("yyyy-MM-dd") {
                missionStore.update(mission: .time(TimeMission(id: firstTimeMission.id,
                                                               title: firstTimeMission.title,
                                                               status: .ready,
                                                               date: Date(),
                                                               wakeupTime: firstTimeMission.changeWakeupTime,
                                                               changeWakeupTime: firstTimeMission.changeWakeupTime)))
                if let firstBehaviorMission = behaviorMissions.first {
                    missionStore.update(mission: .behavior(BehaviorMission(id: firstBehaviorMission.id,
                                                                           title: firstBehaviorMission.title,
                                                                           status: .ready,
                                                                           status1: .ready,
                                                                           status2: .ready,
                                                                           date: Date())))
                }
            }
        }
        .refreshable {
            healthKitStore.fetchStepCount()
            let (_timeMissions, _behaviorMissions) = missionStore.fetch()
            timeMissions = _timeMissions
            behaviorMissions = _behaviorMissions
        }
        .onDisappear {
            healthKitStore.fetchStepCount()
            if let firstTimeMission = timeMissions.first {
                missionStore.update(mission: .time(TimeMission(id: firstTimeMission.id,
                                                               title: firstTimeMission.title,
                                                               status: firstTimeMission.status,
                                                               date: firstTimeMission.date,
                                                               wakeupTime: firstTimeMission.wakeupTime,
                                                               changeWakeupTime: firstTimeMission.changeWakeupTime)))
            }
            if let firstBehaviorMission = behaviorMissions.first {
                missionStore.update(mission: .behavior(BehaviorMission(id: firstBehaviorMission.id,
                                                                       title: firstBehaviorMission.title,
                                                                       status: firstBehaviorMission.status,
                                                                       status1: firstBehaviorMission.status1,
                                                                       status2: firstBehaviorMission.status2,
                                                                       date: firstBehaviorMission.date)))
            }
        }
        .navigationTitle("미션")
        .navigationBarTitleDisplayMode(.inline)
        .getRewardAlert(
            isPresented: $showsAlert,
            title: "미션 성공",
            point: 1,
            primaryButtonTitle: "확인",
            primaryAction: {}
        )
        .successAlert(
            isPresented: $showSuccessAlert,
            title: "수정 성공",
            alertContent: "수정한 기상 미션은 내일부터 적용됩니다",
            primaryButtonTitle: "확인",
            secondaryButtonTitle: "",
            primaryAction: { showSuccessAlert.toggle() },
            secondaryAction: {},
            {}
        )
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MissionView()
                .environmentObject(MissionStore())
        }
    }
}
