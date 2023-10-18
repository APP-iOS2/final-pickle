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
    
    @State private var timeStatus: Status = .ready
    @State private var behaviorStatus1: Status = .ready
    @State private var behaviorStatus2: Status = .ready
    @State private var behaviorStatus3: Status = .ready
    
    @State private var timeMissions: [TimeMission] = [
        TimeMission(id: UUID().uuidString, title: "기상 미션", status: .done, date: Date(), wakeupTime: Date())
    ]
    @State private var behaviorMissions: [BehaviorMission] = [
        BehaviorMission(id: UUID().uuidString, title: "걷기 미션", status: .ready, date: Date())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // 일단 보류
                //                MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "아직", date: "9/27", showsAlert: $showsAlert)
                
                ForEach($timeMissions) { $timeMission in
                    TimeMissionStyleView(timeMission: $timeMission, status: $timeStatus, showsAlert: $showsAlert)
                }
                
                ForEach($behaviorMissions) { behaviorMission in
                    BehaviorMissionStyleView(behaviorMission: behaviorMission,
                                             status1: $behaviorStatus1,
                                             status2: $behaviorStatus2,
                                             status3: $behaviorStatus3,
                                             showsAlert: $showsAlert,
                                             healthKitStore: healthKitStore)
                }
                Spacer()
            }
        }
        .onAppear {
            // 시간 말고 날짜만 비교
            // 상태 초기화 후 날짜 다시 저장
//            Task {
//                let (_timeMissions, _behaviorMissions) = await missionStore.fetch()
//                timeMissions = _timeMissions
//                behaviorMissions = _behaviorMissions
//                
//                if timeMissions.isEmpty { return }
//                if behaviorMissions.isEmpty { return }
//                
//                if timeMissions[0].date.format("yyyy-mm-dd") != Date.now.format("yyyy-mm-dd") {
//                    missionStore.update(mission: .time(TimeMission(id: timeMissions[0].id,
//                                                                   title: timeMissions[0].title,
//                                                                   status: .ready,
//                                                                   date: Date.now,
//                                                                   wakeupTime: timeMissions[0].wakeupTime)))
//                    missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMissions[0].id,
//                                                                           title: behaviorMissions[0].title,
//                                                                           status: .ready,
//                                                                           date: Date.now)))
//                }
//            }
        }
        .refreshable {
            healthKitStore.fetchStepCount()
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
