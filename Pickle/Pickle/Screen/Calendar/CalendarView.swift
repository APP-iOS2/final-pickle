//
//  CalendarView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var navigationStore: NavigationStore
    @Environment(\.scrollEnable) var scrollEnable: Binding<ScrollEnableKey>
    
    @StateObject private var calendarModel: CalendarViewModel = CalendarViewModel()
    
    @State private var filteredTasks: [Todo]?
    @State private var filteredTodayMission: [TimeMission]?
    @State private var weekToMonth: Bool = false
    @State private var offset: CGSize = CGSize()
    @State private var todayPieceOfPizza: Int = 0
    @State private var pizzaSummarySheet: Bool = false
    @State private var todayCompletedTasks: Int = 0
    @State private var wakeUpMission: Int = 0
    @State private var walkMission: Int = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(alignment: .leading) {
                headerView()
                currentPizzaSummaryView()
                
                ScrollView(.vertical) {
                    
                    taskView(tasks: filteredTasks ?? [])
                    
                }
                .scrollIndicators(.hidden)
                .frame(width: geometry.size.width)
                
            }
        }
        .task {
            await todoStore.fetch()
        }
        .onAppear {
            Log.debug("CalendarView onAppear")
            calendarModel.resetForTodayButton()
            filterTodayTasks(todo: todoStore.todos)
            
            todayPizzaCount(todayTasks: filteredTasks ?? [],
                            timeMissions: missionStore.timeMissions,
                            behaviorMissions: missionStore.behaviorMissions)
        }
        
        .onChange(of: calendarModel.currentDay) { _ in
            filterTodayTasks(todo: todoStore.todos)
            let time = missionStore.fetch().0
            let mission = missionStore.fetch().1
            todayPizzaCount(todayTasks: filteredTasks ?? [],
                            timeMissions: time,
                            behaviorMissions: mission)
        }
        .sheet(isPresented: $pizzaSummarySheet) {
            pizzaSheetView()
                .padding()
            Spacer()
                .presentationDetents([.height(300)])
        }
    }
    
    // MARK: - Header 뷰
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(calendarModel.currentDay.format("YYYY년 M월 d일"))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                HStack {
                    if calendarModel.currentDay.isToday {
                        Text("오늘")
                            .font(.largeTitle)
                            .bold()
                    } else {
                        Text(calendarModel.currentDay.format("EEEE"))
                            .font(.largeTitle)
                            .bold()
                    }
                    Spacer()
                    
                    Button(action: {
                        if weekToMonth {
                            calendarModel.currentMonthIndex -= 1
                        } else {
                            calendarModel.currentWeekIndex -= 1
                            calendarModel.createPreviousWeek()
                        }
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    Button(action: {
                        
                        calendarModel.resetForTodayButton()
                        
                    }, label: {
                        Text("오늘")
                            .font(.pizzaBody)
                        
                    })
                    Button(action: {
                        if weekToMonth {
                            calendarModel.currentMonthIndex += 1
                        } else {
                            calendarModel.currentWeekIndex += 1
                            calendarModel.createNextWeek()
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                    })
                    
                    Button(action: {
                        
                        weekToMonth.toggle()
                        calendarModel.resetForTodayButton()
                        
                    }, label: {
                        weekToMonth == true ? Text("월") : Text("주")
                            .font(.headline)
                            .bold()
                    })
                    .padding(.horizontal, 1)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 50))
                }
                weekHeaderView()
                    .padding(.top,5)
                
                if weekToMonth { monthlyView() }
                else { weekView(calendarModel.currentWeek)
                    .padding(.bottom, 5)}
            }
            .hLeading()
        }
        .padding(.horizontal)
        .padding(.top, 15)
    }
    
    func weekHeaderView() -> some View {
        
        HStack {
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            ForEach(days, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
            }
        }
        
    }
    
    // MARK: - Week View
    @ViewBuilder
    func weekView(_ week: [Date]) -> some View {
        HStack(spacing: 8) {
            ForEach(week, id: \.self) { day in
                VStack(spacing: 8) {
                    
                    Text(day.format("d"))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSameDate(day, date2: calendarModel.currentDay) ? .white : .gray)
                        .frame(width: 30, height: 30)
                        .background {
                            if isSameDate(day, date2: calendarModel.currentDay) {
                                Circle()
                                    .fill(Color.pickle)
                                
                            }
                            
                            if day.isToday {
                                Circle()
                                    .fill(Color.mainRed)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: -63)
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 20.0)
                            .stroke(Color.secondary, lineWidth: 1))
                    
                }
                .hCenter()
                .contentShape(.rect)
                .onTapGesture {
                    
                    // MARK: - Updating Current Date
                    withAnimation(.snappy) {
                        calendarModel.currentDay = day
                        calendarModel.currentWeekIndex = 0
                        
                    }
                }
            }
            
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    
                    if gesture.translation.width < -50 {
                        
                        withAnimation {
                            calendarModel.currentWeekIndex += 1
                            calendarModel.createNextWeek()
                            
                        }
                        
                    } else if gesture.translation.width > 50 {
                        
                        withAnimation {
                            
                            calendarModel.currentWeekIndex -= 1
                            calendarModel.createPreviousWeek()
                        }
                    }
                    self.offset = CGSize()
                }
        )
    }
    
    // MARK: - Montly View
    func monthlyView() -> some View {
        
        VStack {
            let dates = calendarModel.extractMonth()
            HStack {
                let colums = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: colums, spacing: 10) {
                    
                    ForEach(dates, id: \.self) { day in
                        
                        if day.day != -1 {
                            Text("\(day.day)")
                                .foregroundStyle(isSameDate(day.date, date2: calendarModel.currentDay) ? .white : .gray)
                                .font(.callout)
                                .frame(width: 30, height: 30)
                                .fontWeight(.semibold)
                                .background {
                                    
                                    if isSameDate(day.date, date2: calendarModel.currentDay) {
                                        Circle()
                                            .fill(Color.pickle)
                                    }
                                    
                                    // MARK: - Indicator to show, which one is Today
                                    if day.date.isToday {
                                        Circle()
                                            .fill(Color.mainRed)
                                            .frame(width: 5, height: 5)
                                            .vSpacing(.bottom)
                                            .offset(y: -33)
                                    }
                                    
                                }
                                .onTapGesture {
                                    calendarModel.currentDay = day.date
                                }
                            
                        } else { Text("") }
                    }
                    .padding(.vertical, 8)
                    .frame(height: 30)
                }
            }
            .onChange(of: calendarModel.currentMonthIndex) { newValue in
                calendarModel.currentDay = calendarModel.getCurrentMonth()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -50 {
                        
                        calendarModel.currentMonthIndex += 1
                        
                    } else if gesture.translation.width > 50 {
                        
                        calendarModel.currentMonthIndex -= 1
                        
                    }
                    self.offset = CGSize()
                }
        )
        
    }
    
    // MARK: - TaskView
    func taskView(tasks: [Todo]) -> some View {
        ForEach(tasks) { task in
            TaskRowView(task: task)
        }
    }
    
    func currentPizzaSummaryView() -> some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("오늘 구운 피자")
                Spacer()
                Text("🍕")
                Text("x")
                Text("\(todayPieceOfPizza)")
                    .font(.pizzaBody)
                
                    .foregroundStyle(Color.pickle)
                Text("조각")
            }
            .padding([.horizontal, .vertical])
            .overlay(RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color.secondary, lineWidth: 1))
            .onTapGesture {
                pizzaSummarySheet.toggle()
                print("\(pizzaSummarySheet)")
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
    
    func pizzaSheetView() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 25) {
                
                HStack {
                    Text("\(calendarModel.currentDay.format("M월 d일"))" + " 피자 🍕")
                        .font(.nanumBd)
                }
                
                Divider()
                
                HStack {
                    Text("✅")
                    Text("오늘 할일 완료")
                    Spacer()
                    Text("x" + " \(todayCompletedTasks)")
                }
                .font(.nanumRg)
                
                HStack {
                    Text("🏃")
                    Text("걷기 미션 완료")
                    Spacer()
                    Text("x" + " \(walkMission)")
                }
                .font(.nanumRg)
                
                HStack {
                    Text("☀️")
                    Text("기상 미션 완료")
                    Spacer()
                    Text("(곧 공개될 예정이에요!)")
                        .font(.callout)
                }
                .font(.nanumRg)
                
                Divider()
                HStack {
                    Text("Total Pizza")
                    Spacer()
                    Text("\(todayPieceOfPizza)" + " 조각")
                        .foregroundStyle(Color.pickle)
                }
                .font(.nanumBd)
                Divider()
                Spacer()
                
            }
            .padding()
        }
        
    }
    
    // MARK: - Filter Today Tasks
    func filterTodayTasks(todo: [Todo]?) {
        
        let calendar  = Calendar.current
        guard let afterTodo = todo else { return }
        let filtered = afterTodo.filter { calendar.isDate($0.startTime, inSameDayAs: calendarModel.currentDay)
        }
        
        filteredTasks =  filtered
        
    }
    
    func filterTodayTimeMission(mission: [TimeMission]) {
        
        let calendar  = Calendar.current
        
        let filtered = mission.filter { calendar.isDate($0.date, inSameDayAs: calendarModel.currentDay)
        }
        
        filteredTodayMission  =  filtered
        
    }
    
    func todayPizzaCount(todayTasks: [Todo],
                         timeMissions: [TimeMission],
                         behaviorMissions: [BehaviorMission]) {
        let calendar  = Calendar.current
        
        todayCompletedTasks = todayTasks.filter { $0.status == .done
        }.count
        
        let firstStepTimeMission =  timeMissions.filter { calendar.isDate($0.date, inSameDayAs: calendarModel.currentDay)
        }
        
        wakeUpMission = firstStepTimeMission.filter { $0.status == .done
        }.count
        
        let firstStepBehaviorMission =  behaviorMissions.filter { calendar.isDate($0.date, inSameDayAs: calendarModel.currentDay)
        }
        
        let tempBehaviorMissionTask0 = firstStepBehaviorMission.filter { $0.status == .done
            
        }
        
        let tempBehaviorMissionTask1 = firstStepBehaviorMission.filter {  $0.status1 == .done
            
        }
        
        let tempBehaviorMissionTask2 = firstStepBehaviorMission.filter {  $0.status2 == .done
            
        }
        walkMission = tempBehaviorMissionTask0.count +  tempBehaviorMissionTask1.count + tempBehaviorMissionTask2.count
        
        let finalPizzaCount = todayCompletedTasks + wakeUpMission + walkMission
        
        todayPieceOfPizza = finalPizzaCount
    }
    
}

#Preview {
    
    CalendarView()
        .environmentObject(TodoStore())
        .environmentObject(UserStore())
        .environmentObject(MissionStore())
    
}

extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
        
    }
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
    // MARK: - Checking Two dates are same
    func isSameDate(_ date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
