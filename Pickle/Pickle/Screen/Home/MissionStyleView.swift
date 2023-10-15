//
//  MissionStyle.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI
import HealthKit

struct CustomToggleButton: View {
    @Binding var buttonTitle: String
    @Binding var buttonToggle: Bool
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text(buttonTitle)
                    .font(.pizzaHeadline)
                    .foregroundColor(buttonToggle ? .gray : .white)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonToggle ? .white : .black)
            .cornerRadius(30.0)
            .overlay(RoundedRectangle(cornerRadius: 30.0)
                .stroke(Color(.systemGray4), lineWidth: 0.5))
        }
    }
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

struct MissionTextModifier: ViewModifier {
  func body(content: Content) -> some View {
      content
          .font(.system(size: 15))
          .frame(width: 70, height: 5)
          .padding()
          .background(.white)
          .cornerRadius(30.0)
          .overlay(RoundedRectangle(cornerRadius: 30.0)
              .stroke(Color(.systemGray4), lineWidth: 0.5))
  }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 50))
        return path
    }
}

struct MissionStyleView: View {
    @State private var buttonTitle: String = "🍕 받기"
    @State var buttonToggle: Bool
    
    @State var title: String
    var status: String
    var date: String
    
    @State private var isSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                }
                
                Spacer(minLength: 10)
                VStack {
                    if status == "완료" {
                        CustomToggleButton(buttonTitle: $buttonTitle, buttonToggle: $buttonToggle, action: {
                            buttonTitle = "성공"
                            buttonToggle = true
                            showsAlert = true
                        })
                        .disabled(buttonToggle)
                    } else {
                        CustomButton(buttonText: "피자 대기", buttonTextColor: .black, buttonColor: .white, action: {
                        })
                        .overlay(RoundedRectangle(cornerRadius: 30.0)
                            .stroke(Color(.black), lineWidth: 0.5))
                        .disabled(true)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8.0)
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

struct TimeMissionStyleView: View {
    @EnvironmentObject var missionStore: MissionStore
    @Binding var timeMission: TimeMission
    
    @State private var buttonTitle: String = "🍕 받기"
    @State private var buttonToggle: Bool = false
    
    private let currentTime: Date = Date()
    
    private let twoButton: Bool = true
    @State private var isTimeMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(timeMission.title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                    
                    Text("\(timeMission.wakeupTime.format("HH:mm"))")
                        .font(.pizzaBody)
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                VStack {
                    // 현재 시간과 목표 기상시간 비교
                    if currentTime > timeMission.wakeupTime.adding(minutes: -10) && currentTime < timeMission.wakeupTime.adding(minutes: 10) {
                        CustomToggleButton(buttonTitle: $buttonTitle, buttonToggle: $buttonToggle, action: {
                            buttonTitle = "성공"
                            buttonToggle = true
                            showsAlert = true
                        })
                        .disabled(buttonToggle)
                        
                    } else {
                        CustomButton(buttonText: "피자 대기", buttonTextColor: .black, buttonColor: .white, action: {
                        })
                        .overlay(RoundedRectangle(cornerRadius: 30.0)
                            .stroke(Color(.black), lineWidth: 0.5))
                        .disabled(true)
                    }
                    
                    if twoButton {
                        CustomButton(buttonText: "설정", buttonTextColor: .white, buttonColor: .black, action: {
                            isTimeMissionSettingModalPresented.toggle()
                        })
                        .sheet(isPresented: $isTimeMissionSettingModalPresented) {
                            TimeMissionSettingView(timeMission: $timeMission,
                                                   title: timeMission.title,
                                                   isTimeMissionSettingModalPresented: $isTimeMissionSettingModalPresented)
                            .presentationDetents([.fraction(0.4)])
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8.0)
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

struct BehaviorMissionStyleView: View {
    @EnvironmentObject var missionStore: MissionStore
    @Binding var behaviorMission: BehaviorMission
    
    @State private var buttonTitle1: String = "🍕 받기"
    @State private var buttonTitle2: String = "🍕 받기"
    @State private var buttonTitle3: String = "🍕 받기"
    @State private var buttonToggle1: Bool = false
    @State private var buttonToggle2: Bool = false
    @State private var buttonToggle3: Bool = false
    
    @State private var isBehaviorMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(behaviorMission.title)
                    .font(.pizzaTitle2Bold)
                    .padding(.bottom, 1)
                Spacer()
                
                Text("현재 \(lround(behaviorMission.myStep)) 걸음")
                    .font(.pizzaBody)
                    .foregroundColor(Color.black.opacity(0.6))
            }
            
            HStack {
                Spacer()
                ZStack {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                    
                    Text("1,000 보")
                        .modifier(MissionTextModifier())
                        .padding(.bottom, 5)
                }
                Spacer()
                ZStack {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                    
                    Text("5,000 보")
                        .modifier(MissionTextModifier())
                        .padding(.bottom, 20)
                }
                Spacer()
                ZStack {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                    
                    Text("10,000 보")
                        .modifier(MissionTextModifier())
                        .padding(.bottom, 35)
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                // 내 걸음수와 목표 걸음수 비교
                if behaviorMission.myStep >= 1000 {
                    CustomToggleButton(buttonTitle: $buttonTitle1, buttonToggle: $buttonToggle1, action: {
                        buttonTitle1 = "성공"
                        buttonToggle1 = true
                        showsAlert = true
                    })
                    .disabled(buttonToggle1)
                } else {
                    CustomButton(buttonText: "피자 대기", buttonTextColor: .black, buttonColor: .white, action: {
                    })
                    .overlay(RoundedRectangle(cornerRadius: 30.0)
                        .stroke(Color(.black), lineWidth: 0.5))
                    .disabled(true)
                }
                Spacer()
                if behaviorMission.myStep >= 5000 {
                    CustomToggleButton(buttonTitle: $buttonTitle2, buttonToggle: $buttonToggle2, action: {
                        buttonTitle2 = "성공"
                        buttonToggle2 = true
                        showsAlert = true
                    })
                    .disabled(buttonToggle2)
                } else {
                    CustomButton(buttonText: "피자 대기", buttonTextColor: .black, buttonColor: .white, action: {
                    })
                    .overlay(RoundedRectangle(cornerRadius: 30.0)
                        .stroke(Color(.black), lineWidth: 0.5))
                    .disabled(true)
                }
                Spacer()
                if behaviorMission.myStep >= 10000 {
                    CustomToggleButton(buttonTitle: $buttonTitle3, buttonToggle: $buttonToggle3, action: {
                        buttonTitle3 = "성공"
                        buttonToggle3 = true
                        showsAlert = true
                    })
                    .disabled(buttonToggle3)
                } else {
                    CustomButton(buttonText: "피자 대기", buttonTextColor: .black, buttonColor: .white, action: {
                    })
                    .overlay(RoundedRectangle(cornerRadius: 30.0)
                        .stroke(Color(.black), lineWidth: 0.5))
                    .disabled(true)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8.0)
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
        MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "완료", date: "9/27", showsAlert: .constant(false))
        TimeMissionStyleView(timeMission: .constant(TimeMission(id: "")), showsAlert: .constant(false))
        // .constant 고정값
        BehaviorMissionStyleView(behaviorMission: .constant(BehaviorMission(id: "")),
                                 showsAlert: .constant(false))
    }
}
