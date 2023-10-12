//
//  MissionView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

// TODO: // 타임 섹션
// 열
// 행동 섹션
// 열

// 미션 배치 (타임 + 행동)
// 열

struct MissionView: View {
    @EnvironmentObject var missionStore: MissionStore
    @State private var showsAlert: Bool = false
    
    @State private var timeMissions: [TimeMission] = [
        TimeMission(id: UUID().uuidString, title: "기상 미션", status: .ready, date: Date(), wakeupTime: Date())
    ]
    @State private var behaviorMissions: [BehaviorMission] = [
        BehaviorMission(id: UUID().uuidString, title: "걷기 미션", status: .done, date: Date(), myStep: 5555.0, missionStep: 0.0)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "아직", date: "9/27", showsAlert: $showsAlert)
                
                ForEach($timeMissions) { $timeMission in
                    TimeMissionStyleView(timeMission: $timeMission, showsAlert: $showsAlert)
                }
                
                ForEach($behaviorMissions) { behaviorMission in
                    BehaviorMissionStyleView(behaviorMission: behaviorMission, showsAlert: $showsAlert)
                }
                
                Spacer()
            }
        }
        .refreshable {
            
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
