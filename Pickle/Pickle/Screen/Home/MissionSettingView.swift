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
    
    @State var wakeupTime: Date
    
    var body: some View {
        VStack {
            Text("\(title) 설정")
                .font(.pizzaTitle2Bold)
                .padding(.bottom, 10)
            
            DatePicker("", selection: $wakeupTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .pickerStyle(.inline)
            Spacer()
            
            Button {
                isTimeMissionSettingModalPresented.toggle()
            } label: {
                Text("수정")
            }

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
//        MissionSettingView(title: .constant("기상 미션"), isSettingModalPresented: .constant(true))
        TimeMissionSettingView(title: .constant("기상 미션"), isTimeMissionSettingModalPresented: .constant(true), wakeupTime: Date())
    }
}
