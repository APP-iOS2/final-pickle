//
//  MissionStyle.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI

struct MissionStyle: Equatable {
    var twoButton: Bool
    var title: String
    var settingValue: String
}

struct CustomButton: View {
    @State var buttonText: String
    @State var buttonTextColor: Color
    @State var buttonColor: Color
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text(buttonText)
                    .font(.pizzaHeadline)
                    .foregroundColor(buttonTextColor)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonColor)
            .cornerRadius(30.0)
            .overlay(RoundedRectangle(cornerRadius: 30.0)
                .stroke(Color(.systemGray4), lineWidth: 0.5))
        }
    }
}

struct MissionStyleView: View {
    var twoButton: Bool = false
    
    @State var title: String
    var status: String
    var date: String
    
    @State var isSettingModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                }
                
                Spacer(minLength: 10)
                VStack {
                    if status == "완료" {
                        CustomButton(buttonText: "완료", buttonTextColor: .white, buttonColor: .black, action: {
                        })
                    } else {
                        CustomButton(buttonText: "완료", buttonTextColor: .gray, buttonColor: .white, action: {
                        })
                        .disabled(true)
                    }
                    
                    if twoButton {
                        CustomButton(buttonText: "설정", buttonTextColor: .white, buttonColor: .black, action: {
                            isSettingModalPresented.toggle()
                        })
                        .sheet(isPresented: $isSettingModalPresented) {
                            MissionSettingView(title: $title, isSettingModalPresented: $isSettingModalPresented)
                                .presentationDetents([.fraction(0.3)])
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(15.0)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
        .padding(.top, 15)
    }
}

struct TimeMissionStyleView: View {
    var calendarViewModel: CalendarViewModel = CalendarViewModel()
    var twoButton: Bool = false
    
    @State var title: String
    var status: String
    var date: String
    
    @State var wakeupTime: Date
    var currentTime: Date
    var limitTime: Int = 600
        
    @State var isTimeMissionSettingModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                    
                    Text("\(calendarViewModel.extractDate(date: wakeupTime, format: "HH:mm"))")
                        .font(.pizzaBody)
                        .foregroundColor(Color.black.opacity(0.6))
                    
                    Text("currentTime: \(currentTime) / wakeupTime: \(wakeupTime)")
                }
                
                Spacer(minLength: 10)
                VStack {
                    // 현재 시간과 목표 기상시간 비교
                    if currentTime == wakeupTime {
                        CustomButton(buttonText: "완료", buttonTextColor: .white, buttonColor: .black, action: {
                        })
                        .disabled(false)
                    } else {
                        CustomButton(buttonText: "완료", buttonTextColor: .gray, buttonColor: .white, action: {
                        })
                        .disabled(true)
                    }
                    
                    if twoButton {
                        CustomButton(buttonText: "설정", buttonTextColor: .white, buttonColor: .black, action: {
                            isTimeMissionSettingModalPresented.toggle()
                        })
                        .sheet(isPresented: $isTimeMissionSettingModalPresented) {
                            TimeMissionSettingView(title: $title, isTimeMissionSettingModalPresented: $isTimeMissionSettingModalPresented, wakeupTime: $wakeupTime, changedWakeupTime: Date())
                                .presentationDetents([.fraction(0.4)])
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(15.0)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
        .padding(.top, 15)
    }
}

struct BehaviorMissionStyleView: View {
    var twoButton: Bool = false
    
    @State var title: String
    var status: String
    var date: String
    
    @State var myStep: Double
    @State var missionStep: Double
    @State var changedMissionStep: Double
    
    @State var isBehaviorMissionSettingModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                    
                    Text("\(lround(myStep)) / \(lround(missionStep)) 보")
                        .font(.pizzaBody)
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                VStack {
                    // 내 걸음수와 목표 걸음수 비교
                    if myStep >= missionStep {
                        CustomButton(buttonText: "완료", buttonTextColor: .white, buttonColor: .black, action: {
                        })
                    } else {
                        CustomButton(buttonText: "완료", buttonTextColor: .gray, buttonColor: .white, action: {
                        })
                        .disabled(true)
                    }
                    
                    if twoButton {
                        CustomButton(buttonText: "설정", buttonTextColor: .white, buttonColor: .black, action: {
                            isBehaviorMissionSettingModalPresented.toggle()
                        })
                        .sheet(isPresented: $isBehaviorMissionSettingModalPresented) {
                            BehaviorMissionSettingView(title: $title, isBehaviorMissionSettingModalPresented: $isBehaviorMissionSettingModalPresented, missionStep: $missionStep, changedMissionStep: $changedMissionStep)
                                .presentationDetents([.fraction(0.28)])
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(15.0)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
        .padding(.top, 15)
    }
}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
//        MissionStyleView(title: "오늘의 할일 모두 완료", status: "완료", date: "9/27")
//        TimeMissionStyleView(twoButton: true, title: "기상 미션", status: "완료", date: "9/27", wakeupTime: Date(), currentTime: Date())
        BehaviorMissionStyleView(twoButton: true, title: "걷기 미션", status: "완료", date: "9/27", myStep: 1000.0, missionStep: 5000.0, changedMissionStep: 0.0)
    }
}
