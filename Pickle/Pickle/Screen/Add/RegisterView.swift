//
//  RegisterView.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI
import RealmSwift

// TODO: onAppear Strat Time refresh 변경 - onAppear에서 수정 - 완료
// TODO: 등록 5글자에서 1글자로 변경 - 완료
// TODO: 20글자로 추가
// TODO: Delete 했을시 Alert 뒤로가기로 눌러야지만 뒤로가짐, - 완료
// TODO: 검은 화면 클릭했을시 뒤로 사라지게 변경해야함 - 완료

// TODO: Pizza Collection List -> User Data 안쪽으로 연결구조 realm 공식문서 살펴보기 - 좀있다하고
// MARK: Ursert 로 강제 수정으로 처리 - 80%

// TODO: 할일 설정 시간을 현재 시간 이후로만 설정할수 있게 변경 - 진행중 - 완료....
// TODO: Alert 구조 refactoring - 추후 리팩토링 진행중
// TODO: Alert TimerView의 알럿으로 통일하기 - 100%  완료

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
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var willUpdateTodo: Todo
    @Binding var successDelete: Bool
    @Binding var isShowingEditTodo: Bool
    var isModify: Bool
    
    @State(wrappedValue: "") private var content: String
    @State private var showingStartTimeSheet: Bool = false
    @State private var showingTargetTimeSheet: Bool = false
    @State private var showingWeekSheet: Bool = false
    
    @State private var startTimes = Date()
    @State private var targetTimes: String = "1분"
    @State private var seletedAlarm: String = "시간 선택"
    
    // MARK: Alert State
    @State private var showSuccessAlert: Bool = false
    @State private var showFailedAlert: Bool = false
    @State private var showUpdateSuccessAlert: Bool = false
    @State private var showUpdateEqual: Bool = false
    
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
                             showSuccessAlert: Binding<Bool>,
                             successDelete: Binding<Bool>,
                             isShowingEditTodo: Binding<Bool>) -> some View {
        modifier(RegisterView.DifferentTypeAlerts(showFailedAlert: showFailedAlert,
                                                  showUpdateEqual: showUpdateEqual,
                                                  showUpdateSuccessAlert: showUpdateSuccessAlert,
                                                  showSuccessAlert: showSuccessAlert,
                                                  successDelete: successDelete,
                                                  isShowingEditTodo: isShowingEditTodo))
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
        @Binding var successDelete: Bool
        @Binding var isShowingEditTodo: Bool
        
        func body(content: Content) -> some View {
            content
                .failedAlert(
                    isPresented: $showFailedAlert,
                    title: "실패",
                    alertContent: "1글자 이상 입력해주세요",
                    primaryButtonTitle: "확인",
                    secondaryButtonTitle: "",
                    primaryAction: { /* 알럿 확인 버튼 액션 */  },
                    secondaryAction: { }
                )
                .failedAlert(
                    isPresented: $showUpdateEqual,
                    title: "실패",
                    alertContent: "같은 내용입니다.",
                    primaryButtonTitle: "확인",
                    secondaryButtonTitle: "뒤로가기",
                    primaryAction: {   },
                    secondaryAction: { dissmiss() }
                )
                .successAlert(
                    isPresented: $showUpdateSuccessAlert,
                    title: "수정 성공",
                    alertContent: "성공적으로 수정했습니다",
                    primaryButtonTitle: "수정하기",
                    secondaryButtonTitle: "뒤로가기",
                    primaryAction: {   },
                    secondaryAction: { dissmiss() }
                )
                .successAlert(
                    isPresented: $showSuccessAlert,
                    title: "저장 성공",
                    alertContent: "성공적으로 할일을 등록했습니다",
                    primaryButtonTitle: "계속 추가하기",
                    secondaryButtonTitle: "뒤로가기",
                    primaryAction: {   },
                    secondaryAction: { dissmiss() }
                )
                // Success Delete Alert
                .successAlert(
                    isPresented: $successDelete,
                    title: "삭제",
                    alertContent: "삭제 하시겠습니까?",
                    primaryButtonTitle: "취소하기",
                    secondaryButtonTitle: "삭제하기",
                    primaryAction: {
                        isShowingEditTodo.toggle()
                        //4번 할일이 삭제 되었을 경우, 해당 등록된 알림도 삭제해야함. 해당 할일의 아이디 넣어줘야함
                    },
                    secondaryAction: {}
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
    
    var timeConstraint: ClosedRange<Date> {
        let value = Date().format("yyyy-MM-dd-HH-mm")
        
        let dates = value.split(separator: "-").map { Int(String($0))! }
        let start: DateComponents = DateComponents(timeZone: TimeZone(identifier: "KST"),
                                                   year: dates[safe: 0],
                                                   month: dates[safe: 1],
                                                   day: dates[safe: 2],
                                                   hour: dates[safe: 3],
                                                   minute: dates[safe: 4])
        let end: DateComponents = DateComponents(timeZone: TimeZone(identifier: "KST"),
                                                 year: dates[safe: 0],
                                                 month: dates[safe: 1],
                                                 day: dates[safe: 2],
                                                 hour: 23,
                                                 minute: 59)
        return PickerView.constraint(start: start,
                                     end: end)
    }
    
    private func datePickerGenerator(binding: Binding<Date>, show: Binding<Bool>) -> some View {
        PickerView(isTimeMissionSettingModalPresented: show,
                   changedWakeupTime: binding,
                   title: "오늘 할일 시간",
                   action: { show.wrappedValue.toggle() },
                   closedRange: timeConstraint)
    }
    
    private func targetTimePickerViewGenerator(binding: Binding<String>, show: Binding<Bool>) -> some View {
        VStack {
            Picker("단위시간", selection: $targetTimes) {
                let times = ["1분"] + targetTimeUnitStrs    // TODO: 테스트용 1분 추가 추후 삭제
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
    RegisterView(willUpdateTodo: .constant(Todo.sample),
                 successDelete: .constant(false),
                 isShowingEditTodo: .constant(false),
                 isModify: true)
    .environmentObject(TodoStore())
}
