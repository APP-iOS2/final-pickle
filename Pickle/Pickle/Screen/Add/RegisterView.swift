//
//  RegisterView.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI

struct RegisterView: View {
    
    enum TimeUnit: Int {
        case ten = 10
        
        var value: Int {
            self.rawValue
        }
    }
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var willUpdateTodo: Todo
    @Binding var successDelete: Bool
    
    var isModify: Bool
    
    @State(wrappedValue: "") private var content: String
    @State private var showingStartTimeSheet: Bool = false
    @State private var showingTargetTimeSheet: Bool = false
    
    @State private var startTimes = Date()
    @State private var targetTimes: String = "1분"
    @State private var seletedAlarm: String = "시간 선택"
    
    // MARK: Alert State
    @State private var alertCondition: AlertCondition = .init()
    
    // MARK: 도도독 State, Task
    @State private var placeHolderText: String = ""
    @State private var tasks: Task<Void, Error>? {
        willSet {
            self.placeHolderText = ""
            self.tasks?.cancel()
        }
    }
    
    @State var dateFrom = Date()
    
    private let alarmCount: [String] = ["한번", "두번", "3번"]
    private let targetTimeUnit: TimeUnit = .ten
    
    private var targetTimeUnitStrs: [String] {
        (10...180)
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
        content.count >= 1
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
            } else {
                self.startTimes = Date()  // 시간 onAppear일때 수정
            }
            
            updateTextField(Const.ALL.randomElement()!)
        }
        .onChange(of: showSuccessAlert, perform: { if !$0 { resetContents() } })
        .differentTypeAlerts(showFailedAlert: $showFailedAlert,
                             showUpdateEqual: $showUpdateEqual,
                             showUpdateSuccessAlert: $showUpdateSuccessAlert,
                             showSuccessAlert: $showSuccessAlert,
                             successDelete: $successDelete,
                             isShowingEditTodo: $isShowingEditTodo)
        .preference(key: SuccessUpdateKey.self, value: alertCondition.isShowingEditTodo)
    }
    
    private func resetContents() {
        self.content = ""
        self.startTimes = Date()
        self.targetTimes = "1분"
    }
    
    private func targetToTimeString(_ time: TimeInterval) -> String {
        let value: Int = Int(time / 60)
        return "\(value)분"
    }
    
    private func todoAddUpdateAction() {
        if isModify && notEqualContent { //여기가 할일 추가 된건데 할일 추가 수정하면
            Task {
                let updatedTodo = todoStore.update(todo: computedTodo)
                _ = await todoStore.fetch()
                    //.fixnotification 여기가 알람 설정된거 수정하는거
                todoStore.fixNotification(todo: updatedTodo,
                                          noti: notificationManager)
                showUpdateSuccessAlert.toggle()
            }
        } else { // 여기가 할일 처음 추가할때
            if isModify { showUpdateEqual.toggle(); return }
            let flag = isRightContent
            let todo = computedTodo
            
            if flag {
                let addedTodo = todoStore.add(todo: todo)
                
                //처음 알람 설정하는곳  -> 디테일은 TODO에서 확인하기~
                todoStore.notificationAdding(todo: addedTodo,
                                             noti: notificationManager)
                showSuccessAlert.toggle()
            }
            else { showFailedAlert.toggle() }
        }
    }
    
    @ViewBuilder
    private var todoTitleInputField: some View {
        VStack(spacing: 0) {
            Text(isModify ? "수정하기" : "오늘 할일 추가")
                .font(Font.pizzaTitle2)
                .bold()
            
            TextField("\(placeHolderText)", text: $content)
                .frame(maxWidth: .infinity)
                .font(Font.pizzaBody)
                .makeTextField {
                    print("\(content)")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
        }
    }
    
    private func targetTimePickCell(_ label: String) -> some View {
        HStack {
            Text("\(label)")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                showingTargetTimeSheet.toggle()
            } label: {
                Text("\(targetTimes)")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingTargetTimeSheet) {
            VStack {
                targetTimePickerViewGenerator(targetTimes: $targetTimes,
                                              show: $showingTargetTimeSheet,
                                              targetTimeUnitStrs: targetTimeUnitStrs)
            }
        }
        .onTapGesture {
            showingTargetTimeSheet.toggle()
        }
    }
    
    private func timeConstraintPickCell(_ label: String) -> some View {
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
                    .presentationDetents([.fraction(0.4)])
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

#Preview {
    RegisterView(willUpdateTodo: .constant(Todo.sample),
                 successDelete: .constant(false),
    .environmentObject(TodoStore())
}
