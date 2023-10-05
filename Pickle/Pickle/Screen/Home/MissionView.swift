//
//  MissionView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct MissionView: View {
    var body: some View {
        VStack {
            MissionStyleView(title: "오늘의 할일 모두 완료", status: "완료", date: "9/27", buttonToggle: false)
            TimeMissionStyleView(twoButton: true, title: "기상 미션", status: "완료", date: "9/27", wakeupTime: Date(), currentTime: Date())
            BehaviorMissionStyleView(twoButton: true, title: "걷기 미션", status: "완료", date: "9/27", myStep: 1000.0, missionStep: 5000.0, changedMissionStep: 0.0)
            Spacer()
        }
        .navigationTitle("미션")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MissionView()
        }
    }
}
