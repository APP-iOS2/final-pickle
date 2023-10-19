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
                    .font(.pizzaBoldButtonTitle)
                    .foregroundColor(buttonTitleColor)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonColor)
            .opacity(buttonOpacity)
            .cornerRadius(10.0)
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

struct TimeMissionStyleView: View {
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var userStore: UserStore
    @Binding var timeMission: TimeMission
    
    @State private var isTimeMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var buttonSwitch: Bool {
        switch timeMission.status {
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
            
            MissionButton(status: $timeMission.status, action: {
                timeMission.status = .done
                missionStore.update(mission: .time(TimeMission(id: timeMission.id,
                                                               title: timeMission.title,
                                                               status: .done,
                                                               date: timeMission.date,
                                                               wakeupTime: timeMission.wakeupTime)))
                
                withAnimation {
                    do {
                        try userStore.addPizzaSlice(slice: 1)
                        print("pizza +1")
                    } catch {
                        Log.error("❌피자 조각 추가 실패❌")
                    }
                }
                showsAlert = true
            })
            .disabled(buttonSwitch)
        }
        .onAppear {
            missionComplet()
        }
        .refreshable {
            missionComplet()
            print("timeMissionView")
            print("mission: \(timeMission.date.format("yyyy-mm-dd"))")
            print("Date: \(Date().format("yyyy-mm-dd"))")
            print("status: \(timeMission.status)")
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
    
    func missionComplet() {
        // 현재 시간과 목표 기상시간 비교
        if Date() > timeMission.wakeupTime.adding(minutes: -10)
            && Date() < timeMission.wakeupTime.adding(minutes: 10)
            && timeMission.status == . ready {
                timeMission.status = .complete
        }
    }
}

struct BehaviorMissionStyleView: View {
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var userStore: UserStore
    @Binding var behaviorMission: BehaviorMission
    
    @State private var isBehaviorMissionSettingModalPresented = false
    @Binding var showsAlert: Bool
    
    var healthKitStore: HealthKitStore
    var buttonSwitch1: Bool {
        switch behaviorMission.status {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    var buttonSwitch2: Bool {
        switch behaviorMission.status2 {
        case .ready, .done:
            return true
        case .complete:
            return false
        default:
            return false
        }
    }
    var buttonSwitch3: Bool {
        switch behaviorMission.status3 {
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
                VStack(alignment: .center) {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                    
                    Text("1,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                        .padding(.vertical, 3)
                    
                    MissionButton(status: $behaviorMission.status) {
                        behaviorMission.status = .done
                        
                        missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMission.id,
                                                                               title: behaviorMission.title,
                                                                               status: .done,
                                                                               status2: behaviorMission.status2,
                                                                               status3: behaviorMission.status3,
                                                                               date: behaviorMission.date)))
                        
                        withAnimation {
                            do {
                                try userStore.addPizzaSlice(slice: 1)
                            } catch {
                                Log.error("❌피자 조각 추가 실패❌")
                            }
                        }
                        showsAlert = true
                    }
                    .disabled(buttonSwitch1)
                }
                VStack(alignment: .center) {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                    
                    Text("5,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                        .padding(.vertical, 3)
                    
                    MissionButton(status: $behaviorMission.status2) {
                        behaviorMission.status2 = .done
                        
                        missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMission.id,
                                                                               title: behaviorMission.title,
                                                                               status: behaviorMission.status,
                                                                               status2: .done,
                                                                               status3: behaviorMission.status3,
                                                                               date: behaviorMission.date)))
                        withAnimation {
                            do {
                                try userStore.addPizzaSlice(slice: 1)
                            } catch {
                                Log.error("❌피자 조각 추가 실패❌")
                            }
                        }
                        showsAlert = true
                    }
                    .disabled(buttonSwitch2)
                }
                VStack(alignment: .center) {
                    Text("🍕")
                        .modifier(PizzaTextModifier())
                        .padding()
                    
                    Text("10,000걸음")
                        .font(.pizzaRegularSmallTitle)
                        .bold()
                        .padding(.vertical, 3)
                    
                    MissionButton(status: $behaviorMission.status3) {
                        behaviorMission.status3 = .done
                        
                        missionStore.update(mission: .behavior(BehaviorMission(id: behaviorMission.id,
                                                                               title: behaviorMission.title,
                                                                               status: behaviorMission.status,
                                                                               status2: behaviorMission.status2,
                                                                               status3: .done,
                                                                               date: behaviorMission.date)))
                        withAnimation {
                            do {
                                try userStore.addPizzaSlice(slice: 1)
                            } catch {
                                Log.error("❌피자 조각 추가 실패❌")
                            }
                        }
                        showsAlert = true
                    }
                    .disabled(buttonSwitch3)
                }
            }
        }
        .onAppear {
            healthKitStore.fetchStepCount({ self.missionComplete() })
        }
        .refreshable {
            healthKitStore.fetchStepCount { self.missionComplete() }
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
            if behaviorMission.status == .ready {
                if stepCount >= 100 {
                    behaviorMission.status = .complete
                }
                if stepCount >= 5000 {
                    behaviorMission.status2 = .complete
                }
                if stepCount >= 10000 {
                    behaviorMission.status3 = .complete
                }
            }
        }
    }
}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
        TimeMissionStyleView(timeMission: .constant(TimeMission(id: "")), showsAlert: .constant(false))
        BehaviorMissionStyleView(behaviorMission: .constant(BehaviorMission(id: "",
                                                                            title: "",
                                                                            status: .ready,
                                                                            status2: .ready,
                                                                            status3: .ready,
                                                                            date: Date())),
                                 showsAlert: .constant(false),
                                 healthKitStore: HealthKitStore())
        MissionView()
            .environmentObject(MissionStore())
    }
}
