//
//  CalendarViewModel.swift
//  Pickle
//
//  Created by kaikim on 2023/09/25.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    
//    @EnvironmentObject var todoStore: TodoStore
    
    @Published var storedTasks: [CalendarSampleTask] = [
        
        CalendarSampleTask(calendarTitle: "Meeting", calendarDescription: "Discuss", creationDate: Date(),isCompleted: true),
        CalendarSampleTask(calendarTitle: "ProtoType", calendarDescription: "Pizza", creationDate: Date()),
        CalendarSampleTask(calendarTitle: "Not Current Task", calendarDescription: "Pizza", creationDate: Date(timeIntervalSinceNow: 3000)),
        CalendarSampleTask(calendarTitle: "Past Task", calendarDescription: "Pizza", creationDate: Date(timeIntervalSinceNow: -8000)),
    ]
    
    
    // MARK: - 초기화
    init() {
        fetchCurrentWeek(date: currentDay)
//        filterTodayTasks()
    }
    // MARK: - filtering today tasks
    @Published var filteredTasks: [Todo]?
    // MARK: - Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: - Current Month
    @Published var currentMonth: [Date.MonthDate] = []
    // MARK: - Current Day
    @Published var currentDay: Date = Date()
    
    @Published var currentMonthIndex: Int = 0
    @Published var currentWeekIndex: Int = 0
    
    func fetchCurrentWeek(date: Date = Date()) {
        currentWeek.removeAll()
        let calendar = Calendar.autoupdatingCurrent
        let startOfDate = calendar.startOfDay(for: date)
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)

//        
//        let week = week.dateInterval(of: .weekOfMonth, for: date)
//        
        guard let firstWeekDay = weekForDate?.start else {
            return
        }
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: - Filter Today Tasks
//    func filterTodayTasks(task: TodoStore) {
//    
//        let calendar  = Calendar.current
////        let filtered : [Todo]
//        if task.todos.isEmpty {
//            self.filteredTasks?.append(Todo.sample)
//        } else {
//            let filtered = task.todos.filter { calendar.isDate($0.startTime, inSameDayAs: self.currentDay)
//            }
//            self.filteredTasks = filtered.sorted(by: { $0.startTime < $1.startTime })
//        }
////        let filtered = storedTasks.filter {
////            calendar.isDate($0.creationDate, inSameDayAs: self.currentDay)
////        }
//        
//    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func getCurrentWeek() -> Date {
        
        let calendar = Calendar.autoupdatingCurrent
        
        guard let currentWeek =  calendar.date(byAdding: .day, value: 7 * self.currentWeekIndex, to: Date()) else { return Date() }
        let startOfDate = calendar.startOfDay(for: currentWeek)
        
        
        return currentWeek
    }
    
    func getCurrentMonth() -> Date {
        
        let calendar = Calendar.autoupdatingCurrent
        
        guard let currentMonth =  calendar.date(byAdding: .month, value: self.currentMonthIndex, to: Date()) else { return Date() }
        
        return currentMonth
    }
    //해당 월을 저장하기 위함
    func extractMonth() -> [Date.MonthDate] {
        let calendar = Calendar.autoupdatingCurrent
        
        let currentMonth = getCurrentMonth()
        
        var resultMonth = currentMonth.fetchMonth().compactMap { date -> Date.MonthDate in
            let day = calendar.component(.day, from: date)
            let resultDay = Date.MonthDate(day: day, date: date)
            
            return resultDay
            
        }
        
        let firstWeekDay = calendar.component(.weekday, from: resultMonth.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1 {
            resultMonth.insert(Date.MonthDate(day: -1, date: Date()), at: 0)
        }
        
        return resultMonth
        
    }
    
    // MARK: - checking if current date is today or not
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: - Checking ifthe currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
    
    //    func getCurrentMonth() -> Date {
    //        let calendar = Calendar.autoupdatingCurrent
    //
    //        guard let currentMonth = calendar.date(byAdding: .month, value: self.current, to: <#T##Date#>)
    //    }
    
    // MARK: - Creating Next Week, based on the Last Current Week's Date
    func createNextWeek(){
        currentWeek.removeAll()
        let calendar = Calendar.autoupdatingCurrent
        let startOfLastDate = calendar.startOfDay(for: currentDay)
        
        let nextDate = calendar.date(byAdding: .day, value: 7 * currentWeekIndex, to: startOfLastDate)
        print(nextDate!)
        return fetchCurrentWeek(date: nextDate!)
        
    }
    
    // MARK: - Creating Previous Week, based on the First Current Week's Date
    func createPreviousWeek() {
        currentWeek.removeAll()
        let calendar = Calendar.autoupdatingCurrent
        let startOfFirstDate = calendar.startOfDay(for: currentDay)
        
        let previousDate = calendar.date(byAdding: .day, value: 7 * currentWeekIndex, to: startOfFirstDate)

        return fetchCurrentWeek(date: previousDate!)
        
    }
    
    
    func resetForTodayButton() {
        currentMonthIndex = 0
        currentWeekIndex = 0
        currentDay = Date()
        fetchCurrentWeek(date: Date())
    }
}
