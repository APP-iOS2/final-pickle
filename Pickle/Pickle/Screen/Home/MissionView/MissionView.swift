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
    // 기상미션 주석처리
    //    @State private var timeMissions: [TimeMission] = [
    //        TimeMission(id: UUID().uuidString, title: "기상 미션", status: .done, date: Date(), wakeupTime: Date())
    //    ]
    @State private var behaviorMissions: [BehaviorMission] = []
    
    var body: some View {
        ScrollView {
            VStack {
                //                ForEach(timeMissions.indices, id: \.self) { index in
                //                    if let mission = timeMissions[safe: index] {
                //                        TimeMissionStyleView(timeMission: $timeMissions[index], showsAlert: $showsAlert, showSuccessAlert: $showSuccessAlert)
                //                    }
                //                }
                
                ForEach(behaviorMissions.indices, id: \.self) { index in
                    if let mission = behaviorMissions[safe: index] {
                        BehaviorMissionStyleView(behaviorMission: $behaviorMissions[index], showsAlert: $showsAlert, healthKitStore: healthKitStore)
                    }
                }
                
                Text("'설정 > 건강 > 데이터 접근 및 기기'에서 권한을 수정할 수 있습니다.")
                    .font(.nanumLt)
                    .foregroundStyle(.secondary)
                    .lineSpacing(5)
                    .padding(.top, 1)
                
                Spacer()
            }
        }
        .onAppear {
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
            
            healthKitStore.requestAuthorization { success in
                if success { healthKitStore.fetchStepCount() }
            }
            healthKitStore.fetchStepCount()
            missionFetch()
            
            // 기상미션 주석처리
            //            if let firstTimeMission = timeMissions.first, firstTimeMission.date.format("yyyy-MM-dd") != Date().format("yyyy-MM-dd") {
            //                missionStore.update(mission: .time(TimeMission(id: firstTimeMission.id,
            //                                                               title: firstTimeMission.title,
            //                                                               status: .ready,
            //                                                               date: Date(),
            //                                                               wakeupTime: firstTimeMission.changeWakeupTime,
            //                                                               changeWakeupTime: firstTimeMission.changeWakeupTime)))
            //            }
            //            if let firstBehaviorMission = behaviorMissions.first {
            //                missionStore.update(mission:
            //                        .behavior(
            //                            BehaviorMission(id: firstBehaviorMission.id,
            //                                            title: firstBehaviorMission.title,
            //                                            status: .ready,
            //                                            status1: .ready,
            //                                            status2: .ready,
            //                                            date: Date())
            //                        )
            //                )
            //            }
            
        }

        .refreshable {
            healthKitStore.fetchStepCount()
            missionFetch()
        }
        .onDisappear {
            //기상미션 주석처리
            //            if let firstTimeMission = timeMissions.first {
            //                missionStore.update(mission: .time(TimeMission(id: firstTimeMission.id,
            //                                                               title: firstTimeMission.title,
            //                                                               status: firstTimeMission.status,
            //                                                               date: firstTimeMission.date,
            //                                                               wakeupTime: firstTimeMission.wakeupTime,
            //                                                               changeWakeupTime: firstTimeMission.changeWakeupTime)))
            //            }
            //            if let firstBehaviorMission = behaviorMissions.first {
            //                missionStore.update(mission:
            //                        .behavior(
            //                            BehaviorMission(id: firstBehaviorMission.id,
            //                                            title: firstBehaviorMission.title,
            //                                            status: firstBehaviorMission.status,
            //                                            status1: firstBehaviorMission.status1,
            //                                            status2: firstBehaviorMission.status2,
            //                                            date: firstBehaviorMission.date)
            //                        )
            //                )
            //            }
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
        // 기상미션 주석처리
        //        .successAlert(content: alertContent)
    }
    
    // 기상미션 주석처리
    //    var alertContent: AlertContent {
    //        .init(isPresented: $showSuccessAlert,
    //              title: "수정 성공",
    //              alertContent: "기상 시간이 변경되었습니다",
    //              primaryButtonTitle: "확인",
    //              secondaryButtonTitle: "",
    //              primaryAction: { showSuccessAlert.toggle() })
    //    }
    
    func missionFetch() {
        missionStore.missionSetting()
        //        let (_timeMissions, _behaviorMissions) = missionStore.fetch()
        // 기상미션 주석처리
        // timeMissions = _timeMissions
        let temp = missionStore.behaviorMissions.filter { $0.date.isToday}
        print(missionStore.behaviorMissions)
        //print(temp)
        behaviorMissions = temp
        //print(behaviorMissions)
        
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
