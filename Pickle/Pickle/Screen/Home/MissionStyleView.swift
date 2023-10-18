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
        case .ready, .complete:
            return .white
        case .done:
            return .secondary
        default:
            return .black
        }
    }
    
    var buttonColor: Color {
        switch status {
        case .ready, .complete:
            return .pickle
        case .done:
            return Color(UIColor.secondarySystemBackground)
        default:
            return .white
        }
    }
    
    var buttonOpacity: Double {
        switch status {
        case .ready:
            return 0.4
        case .complete, .done:
            return 1
        default:
            return 1
        }
    }
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text(buttonTitle)
                    .font(.pizzaBody)
                    .foregroundColor(buttonTitleColor)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonColor)
            .opacity(buttonOpacity)
            .cornerRadius(10.0)
            .overlay(RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color(.systemGray4), lineWidth: 0.5))
        }
    }
}

struct PizzaTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 40))
            .background(
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                  .scaleEffect(1.6))
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
                    .font(.nanumEbTitle)
                    .foregroundColor(.primary)
                    .padding(.bottom, 1)
                    
                    Button(action: {
                        isTimeMissionSettingModalPresented.toggle()
                    }, label: {
                        HStack {
                            Text("\(timeMission.wakeupTime.format("HH:mm"))")
                                .font(.pizzaTitle2)
                            
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .foregroundColor(.secondary)
                    })
                    .sheet(isPresented: $isTimeMissionSettingModalPresented) {
                        TimeMissionSettingView(timeMission: $timeMission,
                                               title: timeMission.title,
                                               isTimeMissionSettingModalPresented: $isTimeMissionSettingModalPresented)
                        .presentationDetents([.fraction(0.4)])
                    }
            }
            
            Spacer(minLength: 10)
            // 현재 시간과 목표 기상시간 비교
            if currentTime > timeMission.wakeupTime.adding(minutes: -10) && currentTime < timeMission.wakeupTime.adding(minutes: 10) {
                
            }
            
            MissionButton(status: $status, action: {
                status = .done
                showsAlert = true
            })
            .disabled(buttonSwitch)
        }
        .onAppear {
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.clear)
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
    @Binding var status1: Status
    @Binding var status2: Status
    @Binding var status3: Status
//    let testStep: Int = 5555
    
    @State private var isBehaviorMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var healthKitStore: HealthKitStore
    var buttonSwitch1: Bool {
        switch status1 {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    var buttonSwitch2: Bool {
        switch status2 {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    var buttonSwitch3: Bool {
        switch status3 {
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
                .font(.nanumEbTitle)
                .bold()
                .padding(.bottom, 4)
            
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
                VStack {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                        .padding(.vertical, 2)
                    Text("1,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                }
                .padding(.leading, 3)
                Spacer()
                VStack {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                        .padding(.vertical, 2)
                    Text("5,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                }
                .padding(.leading, 4)
                Spacer()
                VStack {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                        .padding(.vertical, 2)
                    Text("10,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            
            HStack {
                    MissionButton(status: $status1) {
                        status1 = .done
                        showsAlert = true
                    }
                    .disabled(buttonSwitch1)
                
                    MissionButton(status: $status2) {
                        status2 = .done
                        showsAlert = true
                    }
                    .disabled(buttonSwitch2)
                
                    MissionButton(status: $status3) {
                        status3 = .done
                        showsAlert = true
                    }
                    .disabled(buttonSwitch3)
            }
        }
        .onAppear {
            healthKitStore.fetchStepCount()
            missionComplete()
        }
        .refreshable {
            healthKitStore.fetchStepCount()
            missionComplete()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.clear)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(20.0)
        .overlay(RoundedRectangle(cornerRadius: 20.0)
            .stroke(Color(.lightGray), lineWidth: 1))
        .padding(.horizontal)
        .padding(.top, 15)
    }
    
    func missionComplete() {
        if let stepCount = healthKitStore.stepCount {
            if stepCount >= 1000 {
                status1 = .complete
            }
            if stepCount >= 5000 {
                status1 = .complete
            }
            if stepCount >= 10000 {
                status1 = .complete
            }
        }
//        if testStep >= 1000 {
//            status1 = .complete
//        }
//        if testStep >= 5000 {
//            status2 = .complete
//        }
//        if testStep >= 10000 {
//            status3 = .complete
//        }
    }
}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
        // 일단 보류
        //        MissionStyleView(buttonToggle: false, title: "오늘의 할일 모두 완료", status: "완료", date: "9/27", showsAlert: .constant(false))
        TimeMissionStyleView(timeMission: .constant(TimeMission(id: "")), status: .constant(.ready), showsAlert: .constant(false))
        BehaviorMissionStyleView(behaviorMission: .constant(BehaviorMission(id: "")),
                                 status1: .constant(.ready),
                                 status2: .constant(.ready),
                                 status3: .constant(.ready),
                                 showsAlert: .constant(false),
                                 healthKitStore: HealthKitStore())
        MissionView()
            .environmentObject(MissionStore())
    }
}
