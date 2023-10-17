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
    
    @EnvironmentObject var todoStore: TodoStore
    
    @Binding var willUpdateTodo: Todo
    
    var isModify: Bool
    
    @State(wrappedValue: "") private var content: String
    @State private var showingStartTimeSheet: Bool = false
    @State private var showingTargetTimeSheet: Bool = false
    @State private var showingWeekSheet: Bool = false
    
    @State private var startTimes = Date()
    @State private var targetTimes: String = "10분"
    @State private var seletedAlarm: String = "시간 선택"
    
    @State private var showSuccessAlert: Bool = false
    @State private var showFailedAlert: Bool = false
    @State private var showUpdateSuccessAlert: Bool = false
    @State private var showUpdateEqual: Bool = false
    
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
        (10...300)
            .filter { $0 % targetTimeUnit.value == 0 }
            .reduce(into: [String]()) { original, value in
                original.append("\(value)분")
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
    
    private var computedTodo: Todo {
        let resultTime = todoTimeResult.adding(minutes: 0)
        let startTime = startTimes.adding(minutes: 0)
        let isPersisted = willUpdateTodo.isNotPersisted()
        return Todo(id: isPersisted ? UUID().uuidString : willUpdateTodo.id,
                    content: content,
                    startTime: startTime,
                    targetTime: resultTime.timeIntervalSince(startTime),
                    spendTime: 0,
                    status: .ready)
    }
    
    private var notEqualContent: Bool {
        !computedTodo.isEqualContent(todo: willUpdateTodo)
    }
    
    private var isRightContent: Bool {
        content.count >= 5
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    // TODO: 현재 할일내용, 시작시간, 목표시간 3가지 타입의 데이터만 입력받음
                    // 추후 다른 input 타입 생각
                    todoTitleInputField
                        .padding(.top, 40)
                    
                    timeConstraintPickCell("시작시간",
                                           binding: $startTimes,
                                           show: $showingStartTimeSheet)
                    
                    targetTimePickCell("목표시간",
                                       binding: $targetTimes,
                                       show: $showingTargetTimeSheet)
                    Spacer()
                    
                    confirmActionButton {
                        todoAddUpdateAction()
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
            if isModify {
                self.content = willUpdateTodo.content
                self.targetTimes = targetToTimeString(willUpdateTodo.targetTime)
                self.startTimes = willUpdateTodo.startTime
            }
            updateTextField(Const.ALL.randomElement()!)
        }
        .differentTypeAlerts(showFailedAlert: $showFailedAlert,
                             showUpdateEqual: $showUpdateEqual,
                             showUpdateSuccessAlert: $showUpdateSuccessAlert,
                             showSuccessAlert: $showSuccessAlert)
    }
    
    private func targetToTimeString(_ time: TimeInterval) -> String {
        let value: Int = Int(time / 60)
        return "\(value)분"
    }
    
    private func todoAddUpdateAction() {
        if isModify && notEqualContent {
            Task {
                todoStore.update(todo: computedTodo)
                _ = await todoStore.fetch()
                showUpdateSuccessAlert.toggle()
            }
        } else {
            if isModify { showUpdateEqual.toggle(); return }
            
            let flag = isRightContent
            let todo = computedTodo
            
            if flag { todoStore.add(todo: todo); showSuccessAlert.toggle() }
            else { showFailedAlert.toggle() }
        }
    }
    
    @ViewBuilder
    private var todoTitleInputField: some View {
        VStack {
            Text(isModify ? "수정하기" : "할일 추가")
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
    
    typealias Completion = () -> Void
    
    private func confirmActionButton(_ action: @escaping Completion) -> some View {
        Button {
            action()
        } label: {
            Text( isModify ? "수정" : "확인")
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

// MARK: View modifier extension
extension View {
    func differentTypeAlerts(showFailedAlert: Binding<Bool>,
                             showUpdateEqual: Binding<Bool>,
                             showUpdateSuccessAlert: Binding<Bool>,
                             showSuccessAlert: Binding<Bool>) -> some View {
        modifier(RegisterView.DifferentTypeAlerts(showFailedAlert: showFailedAlert,
                                                  showUpdateEqual: showUpdateEqual,
                                                  showUpdateSuccessAlert: showUpdateSuccessAlert,
                                                  showSuccessAlert: showSuccessAlert))
    }
}

// MARK: Show Alert View Modifier
extension RegisterView {
    
    struct DifferentTypeAlerts: ViewModifier {
        @Environment(\.dismiss) var dissmiss
        @Binding var showFailedAlert: Bool
        @Binding var showUpdateEqual: Bool
        @Binding var showUpdateSuccessAlert: Bool
        @Binding var showSuccessAlert: Bool
        
        func body(content: Content) -> some View {
            content
                .failedAlert(
                    isPresented: $showFailedAlert,
                    title: "실패",
                    alertContent: "5글자 이상 입력해주세요",
                    primaryButtonTitle: "확인",
                    primaryAction: { /* 알럿 확인 버튼 액션 */  }
                )
                .failedAlert(
                    isPresented: $showUpdateEqual,
                    title: "실패",
                    alertContent: "같은 내용입니다.",
                    primaryButtonTitle: "확인",
                    primaryAction: {   }
                )
                .successAlert(
                    isPresented: $showUpdateSuccessAlert,
                    title: "수정 성공",
                    alertContent: "성공적으로 수정하셨습니다",
                    primaryButtonTitle: "뒤로가기",
                    primaryAction: { dissmiss() }
                )
                .successAlert(
                    isPresented: $showSuccessAlert,
                    title: "저장 성공",
                    alertContent: "성공적으로 할일을 등록하셨습니다",
                    primaryButtonTitle: "뒤로가기",
                    primaryAction: { dissmiss() }
                )
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
    RegisterView(willUpdateTodo: .constant(Todo.sample), isModify: true)
}
