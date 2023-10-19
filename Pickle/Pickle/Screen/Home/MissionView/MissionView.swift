//
//  MissionView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct MissionView: View {
    @EnvironmentObject var missionStore: MissionStore
    var healthKitStore: HealthKitStore = HealthKitStore()
    @State private var showsAlert: Bool = false
    
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
                    TimeMissionStyleView(timeMission: $timeMissions[index], showsAlert: $showsAlert)
                }
                
                ForEach(timeMissions.indices, id: \.self) { index in
                    BehaviorMissionStyleView(behaviorMission: $behaviorMissions[index],
                                             showsAlert: $showsAlert,
                                             healthKitStore: healthKitStore)
                }
                Spacer()
            }
        }
        .onAppear {
            print("onApear")
            print("mission: \(timeMissions[0].date.format("yyyy-MM-dd"))")
            print("Date: \(Date().format("yyyy-MM-dd"))")
            print("status: \(timeMissions[0].status)")
            // 시간 말고 날짜만 비교
            // 상태 초기화 후 날짜 다시 저장
            let (_timeMissions, _behaviorMissions) = missionStore.fetch()
            timeMissions = _timeMissions
            behaviorMissions = _behaviorMissions
            
            if timeMissions.isEmpty { return }
            if behaviorMissions.isEmpty { return }
            
            if timeMissions[0].date.format("yyyy-MM-dd") != Date().format("yyyy-MM-dd") {
                missionStore.update(mission: .time(TimeMission(id: timeMissions[0].id,
                                                               title: timeMissions[0].title,
                                                               status: .ready,
                                                               date: Date(),
                                                               wakeupTime: timeMissions[0].wakeupTime)))
                missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMissions[0].id,
                                                                       title: behaviorMissions[0].title,
                                                                       status: .ready,
                                                                       status1: .ready,
                                                                       status2: .ready,
                                                                       date: Date())))
            }
            missionStore.update(mission: .time(TimeMission(id: timeMissions[0].id,
                                                           title: timeMissions[0].title,
                                                           status: timeMissions[0].status,
                                                           date: timeMissions[0].date,
                                                           wakeupTime: timeMissions[0].wakeupTime)))
            missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMissions[0].id,
                                                                   title: behaviorMissions[0].title,
                                                                   status: behaviorMissions[0].status,
                                                                   status1: behaviorMissions[0].status1,
                                                                   status2: behaviorMissions[0].status2,
                                                                   date: behaviorMissions[0].date)))
        }
        .refreshable {
            print("refreshable")
            print("mission: \(timeMissions[0].date.format("yyyy-MM-dd"))")
            print("Date: \(Date().format("yyyy-MM-dd"))")
            print("status: \(timeMissions[0].status)")
            missionStore.update(mission: .time(TimeMission(id: timeMissions[0].id,
                                                           title: timeMissions[0].title,
                                                           status: timeMissions[0].status,
                                                           date: timeMissions[0].date,
                                                           wakeupTime: timeMissions[0].wakeupTime)))
            missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMissions[0].id,
                                                                   title: behaviorMissions[0].title,
                                                                   status: behaviorMissions[0].status,
                                                                   status1: behaviorMissions[0].status1,
                                                                   status2: behaviorMissions[0].status2,
                                                                   date: behaviorMissions[0].date)))
        }
        .onDisappear {
            print("onDisappear")
            print("mission: \(timeMissions[0].date.format("yyyy-MM-dd"))")
            print("Date: \(Date().format("yyyy-MM-dd"))")
            print("status: \(timeMissions[0].status)")
            missionStore.update(mission: .time(TimeMission(id: timeMissions[0].id,
                                                           title: timeMissions[0].title,
                                                           status: timeMissions[0].status,
                                                           date: Date(),
                                                           wakeupTime: timeMissions[0].wakeupTime)))
            missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMissions[0].id,
                                                                   title: behaviorMissions[0].title,
                                                                   status: behaviorMissions[0].status,
                                                                   status1: behaviorMissions[0].status1,
                                                                   status2: behaviorMissions[0].status2,
                                                                   date: Date())))
        }
        .navigationTitle("미션")
        .navigationBarTitleDisplayMode(.inline)
        .getRewardAlert(
            isPresented: $showsAlert,
            title: "미션 성공",
            point: 1,
            primaryButtonTitle: "확인",
            primaryAction: { /* 피자 획득 로직 */ }
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
