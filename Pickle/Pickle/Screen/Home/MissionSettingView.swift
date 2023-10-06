//
//  MissionSettingView.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI

struct MissionSettingView: View {
    @Binding var title: String
    @Binding var isSettingModalPresented: Bool
    
    var body: some View {
        VStack {
            Text("\(title) 설정")
                .font(.pizzaTitle2Bold)
                .padding(.bottom, 10)
            Spacer()
            
            Button {
                isSettingModalPresented.toggle()
            } label: {
                Text("수정")
            }

        }
        .padding()
    }
}

struct TimeMissionSettingView: View {
    
    @Binding var title: String
    @Binding var isTimeMissionSettingModalPresented: Bool
    
    @Binding var wakeupTime: Date
    @State var changedWakeupTime: Date
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    isTimeMissionSettingModalPresented.toggle()
                } label: {
                    Text("취소")
                }
                Spacer()
                
                Text("\(title) 설정")
                    .font(.pizzaTitle2Bold)
                Spacer()
                
                Button {
                    wakeupTime = changedWakeupTime
                    isTimeMissionSettingModalPresented.toggle()
                } label: {
                    Text("저장")
                }
            }
            .padding()
            
            Divider()
            
            DatePicker("시간 선택", selection: $changedWakeupTime,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
        }
        .padding()
    }
}

struct BehaviorMissionSettingView: View {
    @Binding var title: String
    @Binding var isBehaviorMissionSettingModalPresented: Bool
    
    var body: some View {
        VStack {
            Text("\(title) 설정")
                .font(.pizzaTitle2Bold)
                .padding(.bottom, 10)
            Spacer()
            
            Button {
                isBehaviorMissionSettingModalPresented.toggle()
            } label: {
                Text("수정")
            }

        }
        .padding()
    }
}

struct MissionSettingView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSettingView(title: .constant("오늘의 할일 완료 미션"), isSettingModalPresented: .constant(true))
        TimeMissionSettingView(title: .constant("기상 미션"),
    isTimeMissionSettingModalPresented: .constant(true),
    wakeupTime: .constant(Date()),
    changedWakeupTime: Date())
//        BehaviorMissionSettingView(title: .constant("걷기 미션"),
//                                   isBehaviorMissionSettingModalPresented: .constant(true))
    }
}
