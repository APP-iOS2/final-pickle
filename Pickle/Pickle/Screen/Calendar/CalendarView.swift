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
    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var weekToMonth: Bool = false
    @State private var filteredTasks: [Todo]?
    @State var todayPieceOfPizza: Int = 0
//    var indicatorColor: Color {
//        return task.startTime.isSameHour ? .pickle : .primary
//        {
//            return .green
//        }
//        return task.creationDate.isSameHour ? .blue : (task.creationDate.isPastHour ? .red : .black)
//    }

    @Namespace private var animation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            headerView()
            currentPizzaSummaryView()
                .padding(.horizontal)

            ScrollView(.vertical) {
                VStack {
                    taskView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .task {
            await todoStore.fetch()
            
        }
        .onAppear(perform: {
            calendarModel.resetForTodayButton()
            filterTodayTasks(todo: todoStore.todos)
            missionStore.fetch()
            todayPizzaCont(todayTasks: filteredTasks ?? [],
                           timeMissions: missionStore.timeMissions,
                           behaviorMissions: missionStore.behaviorMissions)
        })
        
        .onChange(of: calendarModel.currentDay) { newValue in
            
            filterTodayTasks(todo: todoStore.todos)
//            missionStore.fetch()
            todayPizzaCont(todayTasks: filteredTasks ?? [],
                           timeMissions: missionStore.timeMissions,
                           behaviorMissions: missionStore.behaviorMissions)
        }
    }
    
    // MARK: - Header 뷰
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(calendarModel.currentDay.format("YYYY년 MM월 dd일"))
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
                        print("주간")
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
                if weekToMonth {
                    
                    monthlyView()
                } else {
                    weekView(calendarModel.currentWeek)
                }
            }
            .hLeading()
        }
        .padding()
        .hSpacing(.leading)
    }
    
    // MARK: - Week View
    @ViewBuilder
    func weekView(_ week: [Date]) -> some View {
        HStack(spacing: 0) {
            ForEach(week, id:\.self) { day in
                VStack(spacing: 8) {
                    Text(day.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(day.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(isSameDate(day, date2: calendarModel.currentDay) ? .white : .gray)
                        .frame(width: 30, height: 30)
                        .background{
                            if isSameDate(day, date2: calendarModel.currentDay) {
                                Circle()
                                    .fill(Color.pickle)
                            }
                            
                            if day.isToday {
                                Circle()
                                    .fill(Color.mainRed)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: -66)
                            }
                        }
                    
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hCenter()
                .contentShape(.rect)
                .onTapGesture {
                    
                    // MARK: - Updating Current Date
                    withAnimation(.snappy) {
                        calendarModel.currentDay = day
                    }
                }
                
            }
            
        }
    }
    
    // MARK: - Montly View
    func monthlyView() -> some View {
        let days: [String] = ["일", "월", "화", "수", "목", "금", "토", ]
        let dates = calendarModel.extractMonth()
        return VStack {
            
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                }
            }
            HStack {
                let colums = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: colums, spacing: 15) {
                    
                    ForEach(dates, id: \.self) { day in
                        
                        if day.day == -1 {
                            Text("")
                        } else {
                            
                            Text("\(day.day)")
                                .font(.callout)
                                .frame(width: 30, height: 30)
                                .fontWeight(.semibold)
                            //                                .foregroundStyle(isSameDate(day, date2: calendarModel.currentDay) ? .white : .gray)
                                .background {
                                    
                                    if isSameDate(day.date, date2: calendarModel.currentDay) {
                                        Circle()
                                            .fill(Color.pickle)
                                            .frame(width: 25, height: 25)
                                    }
                                    
                                    // MARK: - Indicator to show, which one is Today
                                    if day.date.isToday {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 5, height: 5)
                                            .vSpacing(.bottom)
                                            .offset(y: -32)
                                    }
                                    
                                }
                                .onTapGesture {
                                    
                                    // MARK: - Updating Current Date
                                
                                        calendarModel.currentDay = day.date
                                    
                                }
                        }

                        
                        
                    }
                    .padding(.vertical, 8)
                    .frame(height: 30)
                    
                }
            }
            .onChange(of: calendarModel.currentMonthIndex) { newValue in
                calendarModel.currentDay = calendarModel.getCurrentMonth()
            }
        }
        
    }
    
    // MARK: - TaskView
    func taskView() -> some View {
        
        VStack(alignment: .leading, spacing: 35) {
            
            ForEach(filteredTasks ?? []) { task in
                TaskRowView(task: task)
            }
        }
        .padding([.vertical, .leading], 15)
    }
    
    func currentPizzaSummaryView() -> some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("오늘 구운 피자")
                Spacer()
                Text("🍕")
                    .bold()
                Text("x")
                Text("\(todayPieceOfPizza)")
                    .font(.pizzaBody)
                    .foregroundStyle(Color.pickle)
                Text("조각")
//                    .font()
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color(.lightGray), lineWidth: 1))
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
    
    func todayPizzaCont(todayTasks: [Todo],
                        timeMissions: [TimeMission],
                        behaviorMissions: [BehaviorMission]) {
        
        let tempTotalTodayTasks = todayTasks.filter { $0.status == .complete || $0.status == .done
        }
        
        let tempTimeMissionTasks = timeMissions.filter { $0.status == .done
        }
        
        let tempBehaviorMissionTasks = behaviorMissions.filter { $0.status == .done || $0.status2 == .done || $0.status3 == .done
        }
    
        let finalPizzaCount = tempTotalTodayTasks.count + tempTimeMissionTasks.count + tempBehaviorMissionTasks.count
        
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
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        
    }
    
    // MARK: - Checking Two dates are same
    func isSameDate(_ date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
