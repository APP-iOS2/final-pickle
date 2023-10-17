//
//  MissionStyle.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI
import HealthKit

struct MissionButton: View {
    @Binding var status: Status
    
    var buttonTitle: String {
        switch status {
        case .ready:
            return "피자 대기"
        case .complete:
            return "피자 받기"
        case .done:
            return "획득 완료"
        default:
            return "피자"
        }
    }
    
    var buttonTitleColor: Color {
        switch status {
        case .ready:
            return .defaultGray
        case .complete, .done:
            return .white
        default:
            return .black
        }
    }
    
    var buttonColor: Color {
        switch status {
        case .ready:
            return .lightGray
        case .complete, .done:
            return .black
        default:
            return .white
        }
    }
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text(buttonTitle)
                    .font(.pizzaHeadline)
                    .foregroundColor(buttonTitleColor)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonColor)
            .cornerRadius(10.0)
            .overlay(RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color(.systemGray4), lineWidth: 0.5))
        }
    }
}

struct EditButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text("수정")
                    .font(.pizzaFootnote)
                    .foregroundColor(.textGray)
            }
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
    @Binding var status: Status
    
    @State var title: String
    var date: String
    
    var buttonSwitch: Bool {
        switch status {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    
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
                    if status == .complete {
                        MissionButton(status: $status, action: {
                            status = .done
                            showsAlert = true
                        })
                        .disabled(buttonSwitch)
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
    @Binding var status: Status
    
    @State private var isTimeMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    private let currentTime: Date = Date()
    var buttonSwitch: Bool {
        switch status {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(timeMission.title)
                    .font(.pizzaTitle2Bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 1)
                
                HStack {
                    Text("\(timeMission.wakeupTime.format("HH:mm"))")
                        .font(.pizzaTitle2)
                        .foregroundColor(.textGray)
                    
                    EditButton(action: {
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
            
            Spacer(minLength: 10)
            // 현재 시간과 목표 기상시간 비교
            if currentTime > timeMission.wakeupTime.adding(minutes: -10) && currentTime < timeMission.wakeupTime.adding(minutes: 10) {
                MissionButton(status: $status, action: {
                    status = .done
                    showsAlert = true
                })
                .disabled(buttonSwitch)
            }
        }
        .onAppear {
            
        }
        .padding()
        .background(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(20.0)
        .overlay(RoundedRectangle(cornerRadius: 20.0)
            .stroke(Color(.lightGray), lineWidth: 1))
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

struct BehaviorMissionStyleView: View {
    @EnvironmentObject var missionStore: MissionStore
    @Binding var behaviorMission: BehaviorMission
    @Binding var status: Status
    
    @State private var isBehaviorMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var healthKitStore: HealthKitStore
    var buttonSwitch: Bool {
        switch status {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                Text(behaviorMission.title)
                    .font(.pizzaTitle2Bold)
                    .padding(.bottom, 1)
            
                if let stepCount = healthKitStore.stepCount {
                    Text("현재 \(stepCount) 걸음")
                        .font(.pizzaBody)
                        .foregroundColor(.textGray)
                } else {
                    Text("현재 0 걸음")
                        .font(.pizzaBody)
                        .foregroundColor(.textGray)
                }
            
            HStack {
                // 내 걸음수와 목표 걸음수 비교
                if healthKitStore.stepCount ?? 0 >= 1000 {
                    MissionButton(status: $status, action: {
                        status = .done
                        showsAlert = true
                    })
                    .disabled(buttonSwitch)
                }
                if behaviorMission.myStep >= 5000 {
                    MissionButton(status: $status, action: {
                        status = .done
                        showsAlert = true
                    })
                    .disabled(buttonSwitch)
                }
                if behaviorMission.myStep >= 10000 {
                    MissionButton(status: $status, action: {
                        status = .done
                        showsAlert = true
                    })
                    .disabled(buttonSwitch)
                }
            }
        }
        .onAppear {
            healthKitStore.fetchStepCount()
        }
        .refreshable {
            healthKitStore.fetchStepCount()
        }
        .padding()
        .background(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(20.0)
        .overlay(RoundedRectangle(cornerRadius: 20.0)
            .stroke(Color(.lightGray), lineWidth: 1))
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
        // 일단 보류
        //        MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "완료", date: "9/27", showsAlert: .constant(false))
        TimeMissionStyleView(timeMission: .constant(TimeMission(id: "")), status: .constant(.ready), showsAlert: .constant(false))
        BehaviorMissionStyleView(behaviorMission: .constant(BehaviorMission(id: "")),
                                 status: .constant(.ready), showsAlert: .constant(false), healthKitStore: HealthKitStore())
        MissionView()
    }
}
