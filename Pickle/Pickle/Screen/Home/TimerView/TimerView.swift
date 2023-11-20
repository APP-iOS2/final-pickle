
//
//  TimerView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase₩
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var timerVM: TimerViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
    var todo: Todo
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var realStartTime: Date = Date() // 실제 시작 시간
    @State private var settingTime: TimeInterval = 0 // 원형 타이머 설정용 시간
    @State private var completeLimit: TimeInterval = 5 * 60 // 5분 이후
    
    @State private var isDisabled: Bool = true // 5분기준 완료 용도
    @State private var isGiveupSign: Bool = false // alert 포기 vs 완료 구분용
    
    @State private var isStart: Bool = true // 3,2,1,시작 보여줄지 아닐지
    @State private var isComplete: Bool = false // '완료'버튼 누를때 시간 멈추기 확인용
    
    @State private var isShowingReportSheet: Bool = false
    @State private var isShowGiveupAlert: Bool = false
    @State private var showingAlert: Bool = false
    
    @Binding var isShowingTimerView: Bool
    
    @State private var wiseSaying: String = ""
    
    @AppStorage("isRunTimer") var isRunTimer: Bool = false
    @AppStorage("backgroundNumber") var backgroundNumber: Int = 0
    @AppStorage("todoId") var todoId: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                
                timerTitleView
                    .offset(y: -(.screenWidth * 0.80))
              
//                Spacer()
            }
            
            // MARK: 타이머 부분
            circleTimerView
                .offset(y: -(.screenWidth * 0.18))
        
            // MARK: 완료, 포기 버튼
            timerButtonView
                .offset(y: .screenWidth * 0.75 / 2 - 10 )
            
            VStack {
                Spacer()
                
                if isDisabled && !isStart {
                    completeDiscription
                } else if !isDisabled && !isStart {
                    wiseSayingView
                }
            }
            .offset(y: .screenWidth * 0.08 )
        }
        .onAppear {
            startTodo()
            timerVM.makeRandomSaying()
            timerVM.fetchTodo(todo: todo)
            todoId = todo.id
 
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingReportSheet) {
            TimerReportView(isShowingReportSheet: $isShowingReportSheet,
                            isShowingTimerView: $isShowingTimerView,
                            todo: timerVM.todo)
                .interactiveDismissDisabled()
        }
        .showGiveupAlert(isPresented: $showingAlert,
                         title: "포기하시겠어요?",
                         contents: "지금 포기하면 피자조각을 얻지 못해요",
                         primaryButtonTitle: "포기하기",
                         primaryAction: updateGiveup,
                         primaryparameter: timerVM.spendTime,
                         secondaryButton: "돌아가기",
                         secondaryAction: giveupSecondary)
    }
    
    func giveupSecondary() {
        isGiveupSign = false
        isComplete = false
    }
    // 시작 시 시간시간 업데이트, status ongoing으로
    func updateStart() {

        let todo = Todo(id: todo.id,
                        content: todo.content,
                        startTime: Date(),
                        targetTime: todo.targetTime,
                        spendTime: 0,
                        status: .ongoing)
        todoStore.update(todo: todo)
        timerVM.updateStart()

        self.realStartTime = Date()
        
        backgroundNumber = 1
        timerVM.activeNumber = 1
        isRunTimer = true

    }
    // 포기시 업데이트, status giveup으로
    func updateGiveup(spendTime: TimeInterval) {
        let todo = Todo(id: todo.id,
                        content: todo.content,
                        startTime: realStartTime,
                        targetTime: todo.targetTime,
                        spendTime: spendTime,
                        status: .giveUp)
        todoStore.update(todo: todo)
        timerVM.updateTodo(spendTime: spendTime, status: .giveUp)
        isRunTimer = false

        backgroundNumber = 0

        
        if spendTime < todo.targetTime {
            notificationManager.removeSpecificNotification(id: [todo.id])
        }
        isShowingReportSheet = true
        
    }
    // 완료 + 피자겟챠
    func updateDone(spendTime: TimeInterval) {
        let todo = Todo(id: todo.id,
                        content: todo.content,
                        startTime: realStartTime,
                        targetTime: todo.targetTime,
                        spendTime: spendTime,
                        status: .done)
        todoStore.update(todo: todo)
        timerVM.updateTodo(spendTime: spendTime, status: .done)
        isRunTimer = false

        backgroundNumber = 0
        
        do {
            try userStore.addPizzaSlice(slice: 1)
        } catch {
            Log.error("❌피자 조각 추가 실패❌")
        }
        

        if spendTime < todo.targetTime {
            todoStore.deleteNotificaton(todo: todo, noti: notificationManager)
    
        }
        

    }
    
    func convertSecondsToTime(timeInSecond: TimeInterval) -> String {
        let hours: Int = Int(timeInSecond / 3600)
        let minutes: Int = Int(timeInSecond - Double(hours) * 3600) / 60
        let seconds: Int = Int(timeInSecond.truncatingRemainder(dividingBy: 60))
        
        if timeInSecond >= 3600 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    // 목표시간 초 -> H시간 M분으로 보여주기
    func convertTargetTimeToString(timeInSecond: TimeInterval) -> String {
        let hours: Int = Int(timeInSecond / 3600)
        let minutes: Int = Int(timeInSecond - Double(hours) * 3600) / 60
        
        if timeInSecond >= 3600 {
            return String(format: "%i시간 %i분", hours, minutes)
        } else {
            return String(format: "%i분", minutes)
        }
    }
    
    func startTodo() {
        self.settingTime = 3
        timerVM.timeRemaining = settingTime
    }
    
    // 남은 시간 계산하기
    func calcRemain() {
        isStart = false
        updateStart()
        self.settingTime = todo.targetTime
        timerVM.timeRemaining = settingTime
        timerVM.spendTime = 0
//        timerVM.activeNumber = 1
//        backgroundNumber = 1
    }
    
    func turnMode() {
        timerVM.isDecresing = false
        Task {
            try? await notificationManager.requestNotiAuthorization()
            if notificationManager.isGranted {
                notificationManager.scheduleNotification(
                    localNotification: LocalNotification(identifier: UUID().uuidString,
                                                         title: "현실도 피자",
                                                         body: "목표시간이 완료됐어요!",
                                                         timeInterval: 1,
                                                         repeats: false,
                                                         type: .time)
                )
            } else {
                notificationManager.isAlertOccurred = true
            }
        }
    }
    
    func progress() -> CGFloat {
        if isStart {
            return CGFloat(0)
        } else {
            if timerVM.isDecresing {
                return (CGFloat(settingTime - timerVM.timeRemaining) / CGFloat(settingTime))
            } else {
                return 1
            }
        }
    }
}

extension TimerView {

    var timerTitleView: some View {
        VStack {
            // 멘트부분
            if isStart {
                Text("따라 읽어봐요!")
                    .font(.pizzaRegularTitle)
            
            } else {
                VStack(spacing: 30) {
                    Text(todo.content)
                        .font(.pizzaRegularTitle)
                        .frame(width: .screenWidth - 50)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.horizontal, 10)
                    
//                    Text("🍕가 구워지고 있어요")
//                        .font(.pizzaBody)
//                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top, .screenHeight * 0.05)
        
    }
    
    var circleTimerView: some View {
        ZStack {
            Circle()
                .fill(.clear)
                .frame(width: .screenWidth * 0.75)
                .overlay(Circle().stroke(.tertiary, lineWidth: 5))
            Circle()
                .trim(from: 0, to: progress())
                .stroke(Color.pickle, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: .screenWidth * 0.75)
                .rotationEffect(.degrees(-90))
            
            if isStart {
                if timerVM.timeRemaining > 0 {
                    Text(String(format: "%g", timerVM.timeRemaining))
                        .foregroundColor(.pickle)
                        .font(.pizzaTimerNum)
                        .onReceive(timer) { _ in
                            timerVM.timeRemaining -= 1
                        }
                } else {
                    Text("시작")
                        .foregroundColor(.pickle)
                        .font(.pizzaTimerNum)
                        .onReceive(timer) { _ in
                            calcRemain()
                        }
                }
            } else {
                
                if timerVM.isDecresing {
                    // 남은시간 줄어드는 타이머
                    Text(convertSecondsToTime(timeInSecond: timerVM.timeRemaining))
                        .foregroundColor(.pickle)
                        .font(.pizzaTimerNum)
                        .onReceive(timer) { _ in
                            if !isComplete || timerVM.isPuase {
                                timerVM.timeRemaining -= 1
                          
                                timerVM.spendTime += 1
                        
                                
                                if timerVM.spendTime > completeLimit {
                                    isDisabled = false
                                }
                                if timerVM.timeRemaining <= 0 {
                                    turnMode()
                                }
                            }
                        }
                } else {
                    // 추가시간 늘어나는 타이머
                    HStack {
                        Text("+ \(convertSecondsToTime(timeInSecond: timerVM.timeExtra))")
                            .foregroundColor(.pickle)
                            .font(.pizzaTimerNum)
                            .onReceive(timer) { _ in
                                // disabled가 풀리기 전에 background 갔다가 오는 경우를 위해
                                if timerVM.spendTime > completeLimit {
                                    isDisabled = false
                                }
                                if (!isStart && !isComplete) || timerVM.isPuase {
                                    timerVM.timeExtra += 1
                                    timerVM.spendTime += 1
                                }
                            }
                    }
                }
                
                // 목표시간 명시
                Text(convertTargetTimeToString(timeInSecond: todo.targetTime))
                    .font(.pizzaRegularSmallTitle)
                    .foregroundColor(.secondary)
                    .offset(y: 40)
            }
        }
    }
    
    var timerButtonView: some View {
        HStack {
            // 완료 버튼
            
            Button {
                isComplete = true
                updateDone(spendTime: timerVM.spendTime)
            
                isShowingReportSheet = true

            } label: {
                Text("완료")
                    .font(.pizzaHeadline)
                    .frame(width: 75, height: 75)
                    .foregroundColor(isDisabled ? .secondary : .green)
                    .background(isDisabled ? Color(.secondarySystemBackground) : Color(hex: 0xDAFFD9))
                    .clipShape(Circle())
            }
            .disabled(isDisabled)
            .opacity(isStart ? 0.5 : 1)
            .padding([.leading, .trailing], 75)
            
            // 포기버튼
            Button(action: {
                isComplete = true
                isGiveupSign = true
                showingAlert = true
            }, label: {
                Text("포기")
                    .font(.pizzaHeadline)
                    .frame(width: 75, height: 75)
                    .foregroundColor(isStart ? .secondary : .red)
                    .background(isStart ? Color(.secondarySystemBackground) :Color(hex: 0xFFDBDB))
                    .clipShape(Circle())
            })
            .disabled(isStart)
            .opacity(isStart ? 0.5 : 1)
            .padding([.leading, .trailing], 75)
            
        }
        .padding(.top, 10)
    }
    
    var completeDiscription: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("최소 5분 할 일을 하면\n피자 조각을 얻을 수 있어요!")
        }
        .multilineTextAlignment(.center)
        .lineSpacing(10)
        .font(.pizzaBoldButtonTitle15)
        .foregroundColor(.secondary)
        .frame(width: .screenWidth - 50)
        .lineLimit(2)
        .padding(.top, 50)
        .padding(.bottom, .screenHeight * 0.1)
        .padding(.horizontal, 20)

    }
    
    var wiseSayingView: some View {
        Text("\(timerVM.wiseSaying)")
            .multilineTextAlignment(.center)
            .lineSpacing(10)
            .font(.pizzaBoldButtonTitle15)
            .foregroundColor(.secondary)
            .frame(width: .screenWidth - 50)
            .lineLimit(4)
            .minimumScaleFactor(0.7)
            .padding(.top, 50)
            .padding(.bottom, .screenHeight * 0.1)
            .padding(.horizontal, 20)

    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TimerView(todo: Todo(id: UUID().uuidString,
                                 content: "이력서 작성하기dfs",
                                 startTime: Date(),
                                 targetTime: 15,
                                 spendTime: 5400,
                                 status: .ready), isShowingTimerView: .constant(false))
            .environmentObject(TodoStore())
            .environmentObject(TimerViewModel())
            .environmentObject(UserStore())
            .environmentObject(NotificationManager(mediator: NotiMediator()))
        }
    }
}
