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
    
    @Binding var missionStep: Double
    @Binding var changedMissionStep: Double
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    changedMissionStep = 0.0
                    isBehaviorMissionSettingModalPresented.toggle()
                } label: {
                    Text("취소")
                }
                Spacer()
                
                Text("\(title) 설정")
                    .font(.pizzaTitle2Bold)
                Spacer()
                
                Button {
                    missionStep += changedMissionStep
                    changedMissionStep = 0.0
                    isBehaviorMissionSettingModalPresented.toggle()
                } label: {
                    Text("저장")
                }
            }
            .padding()
            
            Divider()
            
            HStack {
                Button(action: {
                    changedMissionStep += -1000.0
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                })
                .padding()
                
                Text("\(lround(missionStep + changedMissionStep))")
                    .font(.system(size: 40))
                    .padding()
                
                Button(action: {
                    changedMissionStep += 1000.0
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                })
                .padding()
            }
            .padding()
        }
        .padding()
    }
}

struct MissionSettingView_Previews: PreviewProvider {
    static var previews: some View {
//        MissionSettingView(title: .constant("기상 미션"), isSettingModalPresented: .constant(true))
//        TimeMissionSettingView(title: .constant("기상 미션"), isTimeMissionSettingModalPresented: .constant(true), wakeupTime: .constant(Date()), changedWakeupTime: Date())
        BehaviorMissionSettingView(title: .constant("걷기 미션"), isBehaviorMissionSettingModalPresented: .constant(true), missionStep: .constant(5000.0), changedMissionStep: .constant(1000.0))
    }
}
