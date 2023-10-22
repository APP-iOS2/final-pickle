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
    @State private var filteredTodayMission: [TimeMission]?
    @State var todayPieceOfPizza: Int = 0
    @State private var offset: CGSize = CGSize()
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
                .padding(.top, 15)
                .padding(.bottom, 8)
            currentPizzaSummaryView()
                .padding(.horizontal)
            ScrollView(.vertical) {
                VStack {
                    taskView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .gesture(
           DragGesture()
             .onChanged { gesture in
                 self.offset = gesture.translation
             }
             .onEnded { gesture in
               if gesture.translation.width < -50 {
                   
                   if weekToMonth {
                     
                           calendarModel.currentMonthIndex += 1
                       
                       
                   } else {
                       withAnimation {
                           calendarModel.currentWeekIndex += 1
                           calendarModel.createNextWeek()
                           
                       }
                   }
                   
               } else if gesture.translation.width > 50 {
                   if weekToMonth {
                   
                           
                           calendarModel.currentMonthIndex -= 1
                       
                   } else {
                       withAnimation {
                           
                           calendarModel.currentWeekIndex -= 1
                           calendarModel.createPreviousWeek()
                       }
                   }
               }
                 self.offset = CGSize()
             }
         )
        .task {
            await todoStore.fetch()
            
        }
        .onAppear(perform: {
            calendarModel.resetForTodayButton()
            filterTodayTasks(todo: todoStore.todos)
         
            todayPizzaCount(todayTasks: filteredTasks ?? [],
                           timeMissions: missionStore.timeMissions,
                           behaviorMissions: missionStore.behaviorMissions)
        })
        
        .onChange(of: calendarModel.currentDay) { newValue in
            
            filterTodayTasks(todo: todoStore.todos)
            let time = missionStore.fetch().0
            let mission = missionStore.fetch().1
            todayPizzaCount(todayTasks: filteredTasks ?? [],
                           timeMissions: time,
                           behaviorMissions: mission)
        }
        
//        .onChange(of: offset) { newValue in
//            calendarModel.currentDay = calendarModel.getCurrentMonth()
//            calendarModel.currentWeek = calendarModel.
//        }
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
                        .padding(.bottom, 5)
                }
            }
            .hLeading()
        }
        .padding(.horizontal)
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
                                    .offset(y: -60)
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
                            
                        if day.day != -1 {
                            Text("\(day.day)")
                                .foregroundStyle(isSameDate(day.date, date2: calendarModel.currentDay) ? .white : .gray)
                                .font(.callout)
                                .frame(width: 30, height: 30)
                                .fontWeight(.semibold)
                            //                                .foregroundStyle(isSameDate(day, date2: calendarModel.currentDay) ? .white : .gray)
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
                                            .offset(y: -35)
                                    }
                                    
                                }
                                .onTapGesture {
                                    
                                    // MARK: - Updating Current Date
                                    withAnimation {
                                        calendarModel.currentDay = day.date
                                    }
                                        
                                    
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
                Text("x")
                Text("\(todayPieceOfPizza)")
                    .font(.pizzaBody)
                    .foregroundStyle(Color.pickle)
                Text("조각")
//                    .font()
                }
            .padding([.horizontal,.vertical])
                .overlay(RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color.secondary, lineWidth: 1))
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
        
        let tempTotalTodayTasks = todayTasks.filter { $0.status == .complete || $0.status == .done
        }
        
        let firstStepTimeMission =  timeMissions.filter { calendar.isDate($0.date, inSameDayAs: calendarModel.currentDay)
        }
        
        let tempTimeMissionTasks = firstStepTimeMission.filter { $0.status == .done
        }
        
        let firstStepBehaviorMission =  behaviorMissions.filter { calendar.isDate($0.date, inSameDayAs: calendarModel.currentDay)
        }
        
        let tempBehaviorMissionTask0 = firstStepBehaviorMission.filter { $0.status == .done
            
        }
        
        let tempBehaviorMissionTask1 = firstStepBehaviorMission.filter {  $0.status1 == .done
            
        }
        
        let tempBehaviorMissionTask2 = firstStepBehaviorMission.filter {  $0.status2 == .done
            
        }
        let totalBehaviorMissions = tempBehaviorMissionTask0 +  tempBehaviorMissionTask1 + tempBehaviorMissionTask2
        
        
        let finalPizzaCount = tempTotalTodayTasks.count + tempTimeMissionTasks.count + totalBehaviorMissions.count
        
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
