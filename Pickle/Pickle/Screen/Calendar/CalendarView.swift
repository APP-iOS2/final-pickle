//
//  CalendarView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var todoStore: TodoStore
    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var weekToMonth: Bool = false
    @State private var filteredTasks: [Todo]?
    
    @Namespace private var animation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            headerView()
            
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
        })

        .onChange(of: calendarModel.currentDay) { newValue in
          
            filterTodayTasks(todo: todoStore.todos)
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
                        print("주간")
                        weekToMonth.toggle()
                        
                    }, label: {
                        weekToMonth == true ? Text("월") : Text("주")
                            .font(.headline)
                            .bold()
                    })
                    .padding(.horizontal, 1)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 50))
                    
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
                        .foregroundStyle(isSameDate(day, date2: calendarModel.currentDay) ? .black : .gray)
                        .frame(width: 35, height: 35)
                        .background{
                            if isSameDate(day, date2: calendarModel.currentDay) {
                                Circle()
                                    .fill(Color.orange)
                            }
                            
                            if day.isToday {
                                Circle()
                                    .fill(Color.blue)
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
        let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
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
                                .fontWeight(.semibold)
                                .background {
                                    
                                    if isSameDate(day.date, date2: calendarModel.currentDay) {
                                        Circle()
                                            .fill(Color.orange)
                                    }
                                    
                                    // MARK: - Indicator to show, which one is Today
                                    if day.date.isToday {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 5, height: 5)
                                            .vSpacing(.bottom)
                                            .offset(y: -22)
                                    }
                                    
                                }
                                .onTapGesture {
                                    
                                    // MARK: - Updating Current Date
                                    withAnimation(.snappy) {
                                        calendarModel.currentDay = day.date
                                    }
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
    
    // MARK: - Filter Today Tasks
    func filterTodayTasks(todo: [Todo]?){
    
        let calendar  = Calendar.current
        guard let abc = todo else { return }
        let filtered = abc.filter { calendar.isDate($0.startTime, inSameDayAs: calendarModel.currentDay)
            }
            
        filteredTasks =  filtered

        }
    
}

#Preview {
    
    CalendarView()
            .environmentObject(TodoStore())
            .environmentObject(UserStore())
    
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
