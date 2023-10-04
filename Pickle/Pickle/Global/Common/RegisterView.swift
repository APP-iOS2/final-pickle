//
//  RegisterView.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI
import RealmSwift

// 등록에서 시작시간, target 시간 설정하기
// 시작시간에서 시작후 target 시간과 맞게 끝나면
// spendtime = target시간 동일
// target 넘어서 까지 하면
// spendtime > target

enum Const: CaseIterable {
    static let ALL: [[String]] = [WELCOME1, WELCOME2, WELCOME3, WELCOME4]
    static let WELCOME1 = "오늘은 무슨일을 하실 생각 이세여?".map { String($0) }
    static let WELCOME2 = "피자가 드시고 싶으시다구요?".map { String($0) }
    static let WELCOME3 = "피자가 먹고 싶어요.........".map { String($0) }
    static let WELCOME4 = "저는 아무것도 모른답니당ㅎㅎ".map { String($0) }
}

struct RegisterView: View {
    
    enum TimeUnit: Int {
        case ten = 10
        
        var value: Int {
            self.rawValue
        }
    }
    
    @Environment(\.dismiss) var dissmiss
    @Environment(\.realm) var realm: Realm
    
    @State private var content: String = ""
    @State private var showingStartTimeSheet: Bool = false
    @State private var showingTargetTimeSheet: Bool = false
    @State private var showingWeekSheet: Bool = false
    
    @State private var startTimes = Date()
    @State private var targetTimes: String = "10분"
    
    @State private var seletedAlarm: String = "시간 선택"
    @State private var placeHolderText: String = ""
    
    @State private var tasks: Task<Void, Error>? {
        willSet {
            self.placeHolderText = ""
            self.tasks?.cancel()
        }
    }
    private let alarmCount: [String] = ["한번", "두번", "3번"]
    private let targetTimeUnit: TimeUnit = .ten
    
    private var targetTimeUnitStrs: [String] {
        (0...300)
            .filter { $0 % targetTimeUnit.value == 0 }
            .reduce(into: [String]()) { original, value in
                original.append("\(value) 분")
            }
    }
    
    private var todoTimeResult: Date {
        let value = targetTimes
            .split(separator: "분")
            .compactMap { Int(String($0)) }
            .first
        if let value {
            return startTimes.adding(minutes: value)
        } else {
            return startTimes.adding(minutes: 10)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    // TODO: 현재 할일내용, 시작시간, 목표시간 3가지 타입의 데이터만 입력받음
                    // 추후 다른 input 타입 생각
                    todoTitleInputField
                        .padding(.top, 40)
                    
                    // repeatDay
                    
                    timeConstraintPickCell("시작시간",
                                             binding: $startTimes,
                                             show: $showingStartTimeSheet)
                    
                    targetTimePickCell("목표시간",
                                       binding: $targetTimes,
                                       show: $showingTargetTimeSheet)
                    Spacer()
                    
                    confirmActionButton {
                        let flag = false
                        
                        let resultTime = todoTimeResult
                        print("startTime: \(startTimes.adding(minutes: 0))")
                        print("resultTime : \(resultTime)")
                        if flag {
                            let todo = TodoObject(content: content ,
                                                  startTime: startTimes.adding(minutes: 0),
                                                  targetTime: resultTime,
                                                  spendTime: startTimes.adding(minutes: 0),
                                                  status: .ready)
                            try! realm.write {
                                realm.add(todo)
                            }
                        } else {
                            dissmiss()
                        }
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
        }
        .refreshable {
            updateTextField(Const.ALL.randomElement()!)
        }
        .onAppear {
            updateTextField(Const.ALL.randomElement()!)
        }
    }
    
    @ViewBuilder
    private var todoTitleInputField: some View {
        VStack {
            Text("할일 추가")
                .font(Font.pizzaTitle2)
                .bold()
            
            TextField("\(placeHolderText)", text: $content)
                .padding(.horizontal, 16)
                .makeTextField {
                    print("\(content)")
                }
                .padding()
        }
    }
    
    @ViewBuilder
    private var repeatDay: some View {
        HStack {
            Text("반복 요일")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            
            Spacer()
            Button {
                showingWeekSheet.toggle()
            } label: {
                Text("주말")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingWeekSheet) {
            alarmPickerView
        }
    }
    
    private func targetTimePickCell(_ label: String,
                                    binding: Binding<String>,
                                    show: Binding<Bool>) -> some View {
        HStack {
            Text("\(label)")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                show.wrappedValue.toggle()
            } label: {
                Text("\(binding.wrappedValue)")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: show) {
            VStack {
                targetTimePickerViewGenerator(binding: binding,
                                              show: show)
            }
        }
        .onTapGesture {
            show.wrappedValue.toggle()
        }
    }
    
    private func timeConstraintPickCell(_ label: String,
                                        binding: Binding<Date>,
                                        show: Binding<Bool>) -> some View {
        HStack {
            Text("\(label)")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                show.wrappedValue.toggle()
            } label: {
                Text("\(binding.wrappedValue.format("HH:mm"))")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: show) {
            VStack {
                datePickerGenerator(binding: binding, show: show)
            }
        }
        .onTapGesture {
            show.wrappedValue.toggle()
        }
    }
    
    @ViewBuilder
    private var alarmSelector: some View {
        HStack {
            Text("알림")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                showingWeekSheet.toggle()
            } label: {
                Text("\(seletedAlarm)")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingWeekSheet) {
            alarmPickerView
        }
    }
    
    private func confirmActionButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text("확인")
                .cornerRadiusModifier()
        }
    }
    
    @ViewBuilder
    private var alarmPickerView: some View {
        VStack {
            Picker("language", selection: $seletedAlarm) {
                ForEach(0..<alarmCount.count) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.fraction(0.3)])
            
            Button {
                showingWeekSheet.toggle()
            } label: {
                Text("확인")
            }
        }
    }
}

// MARK: Register PlaceHolder Task Function
extension RegisterView {
    private func updateTextField(_ strings: [String]) {
        tasks = Task {
            var result: String = ""
            for i in 0...strings.count - 1 {
                result += strings[i]
                try await Task.sleep(nanoseconds: UInt64(0.05 * Double(NSEC_PER_SEC)))
                self.placeHolderText = result
            }
        }
    }
}

// MARK: Register PickerView extension
extension RegisterView {
    
    private func datePickerGenerator(binding: Binding<Date>, show: Binding<Bool>) -> some View {
        VStack {
            DatePicker("시간 선택", selection: binding,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .presentationDetents([.fraction(0.4)])
            .labelsHidden()
            
            Spacer()
            
            Button {
                show.wrappedValue.toggle()
            } label: {
                Text("확인")
                    .tint(Color.textGray)
            }
            .padding(.vertical, 10)
        }
    }
    
    private func targetTimePickerViewGenerator(binding: Binding<String>, show: Binding<Bool>) -> some View {
        VStack {
            Picker("단위시간", selection: $targetTimes) {
                let times = targetTimeUnitStrs
                ForEach(times.indices, id: \.self) {
                    Text("\(times[$0])").tag(times[$0])
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.fraction(0.3)])
            
            Button {
                show.wrappedValue.toggle()
            } label: {
                Text("확인")
                    .tint(Color.textGray)
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    RegisterView()
}
