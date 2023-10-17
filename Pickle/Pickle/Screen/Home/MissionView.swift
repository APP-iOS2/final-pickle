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
    
    @State private var day: Date = Date()
    
    // 각각의 미션별로 구분해줘야함
    @State private var status: Status = .ready
    
    @State private var timeMissions: [TimeMission] = [
        TimeMission(id: UUID().uuidString, title: "기상 미션", status: .done, date: Date(), wakeupTime: Date())
    ]
    @State private var behaviorMissions: [BehaviorMission] = [
        BehaviorMission(id: UUID().uuidString, title: "걷기 미션", status: .ready, date: Date(), myStep: 5555.0, missionStep: 0.0)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // 일단 보류
//                MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "아직", date: "9/27", showsAlert: $showsAlert)
                
                ForEach($timeMissions) { $timeMission in
                    TimeMissionStyleView(timeMission: $timeMission, status: $status, showsAlert: $showsAlert)
                }
                
                ForEach($behaviorMissions) { behaviorMission in
                    BehaviorMissionStyleView(behaviorMission: behaviorMission,
                                             status: $status,
                                             showsAlert: $showsAlert,
                                             healthKitStore: healthKitStore)
                }
                
                Spacer()
            }
        }
        .onAppear {
            // 시간 말고 날짜만 비교
            if day.format("yyyy-mm-dd") != Date.now.format("yyyy-mm-dd") {
                // 상태 초기화 후 날짜 다시 저장
                timeMissions[0].status = .ready
                behaviorMissions[0].status = .ready
                self.day = Date.now
            }
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
        }
    }
}
