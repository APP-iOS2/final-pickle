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
            MissionStyleView(twoButton: true, title: "기상 미션", settingValue: "오전 7시", time: 0)
            MissionStyleView(twoButton: true, title: "걷기 미션", settingValue: "5000보", time: 7)
            MissionStyleView(twoButton: false, title: "오늘의 할일 모두 완료", settingValue: "", time: 7)
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
