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
    static let ALL: [[String]] = [WELCOME1, WELCOME2, WELCOME3, WELCOME4, WELCOME5]
    static let WELCOME1 = "오늘은 무슨일을 하실 생각 이세여?".map { String($0) }
    static let WELCOME2 = "피자가 드시고 싶으시다구요?".map { String($0) }
    static let WELCOME3 = "피자가 먹고 싶어요.........".map { String($0) }
    static let WELCOME4 = "저는 아무것도 모른답니당ㅎㅎ".map { String($0) }
    static let WELCOME5 = "ㅋ......ㅋ.....".map { String($0) }
}

struct RegisterView: View {
    
    @Environment(\.realm) var realm: Realm
    
    @State private var text: String = ""
    @State private var showingStartTimeSheet: Bool = false
    @State private var showingTargetTimeSheet: Bool = false
    @State private var showingWeekSheet: Bool = false
    
    @State private var startTimes = Date()
    @State private var targetTimes = Date()
    
    @State private var seletedAlarm: String = "시간 선택"
    @State private var placeHolderText: String = ""
    
    private let alarmCount: [String] = ["한번", "두번", "3번"]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    todoTitleInputField
                        .padding(.top, 40)
                    repeatDay
                    
                    timeConstraintPickButton("시작시간",
                                             binding: $startTimes,
                                             show: $showingStartTimeSheet)
                    
                    timeConstraintPickButton("목표시간",
                                             binding: $targetTimes,
                                             show: $showingTargetTimeSheet)
                    alarmSelector
                    Spacer()
                    confirmActionButton {
                        let todo = TodoObject.todo
                        try! realm.write {
                            realm.add(todo)
                        }
                    }
                }
                .frame(minHeight: geometry.size.height)
            }.frame(width: geometry.size.width)
        }
        .refreshable {
            updateTextField(Const.ALL.randomElement()!)
        }
        .onAppear {
            updateTextField(Const.ALL.randomElement()!)
        }
    }
    
    @State private var tasks: Task<Void, Error>? {
        willSet {
            self.placeHolderText = ""
            self.tasks?.cancel()
        }
    }
    
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
    
    @ViewBuilder
    private var todoTitleInputField: some View {
        VStack {
            Text("할일 추가")
                .font(Font.pizzaTitle2)
                .bold()
            
            TextField("\(placeHolderText)", text: $text)
                .padding(.horizontal, 16)
                .makeTextField {
                    print("\(text)")
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
    
    private func timeConstraintPickButton(_ label: String,
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
                .padding()
                .frame(width: 200)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
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
            }
            .padding(.vertical, 10)
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

#Preview {
    RegisterView()
}
