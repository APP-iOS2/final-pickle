//
//  CalendarViewModel.swift
//  Pickle
//
//  Created by kaikim on 2023/09/25.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    
    @Published var storedTasks: [CalendarSampleTask] = [
        
        CalendarSampleTask(calendarTitle: "Meeting", calendarDescription: "Discuss", creationDate: Date(),isCompleted: true),
        CalendarSampleTask(calendarTitle: "ProtoType", calendarDescription: "Pizza", creationDate: Date()),
        CalendarSampleTask(calendarTitle: "Not Current Task", calendarDescription: "Pizza", creationDate: Date(timeIntervalSinceNow: 3000)),
        CalendarSampleTask(calendarTitle: "Past Task", calendarDescription: "Pizza", creationDate: Date(timeIntervalSinceNow: -8000)),
    ]
    
    
    
    // MARK: - 초기화
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    // MARK: - filtering today tasks
    @Published var filteredTasks: [CalendarSampleTask]?
    // MARK: - Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: - Current Month
    @Published var currentMonth: [Date.MonthDate] = []
    // MARK: - Current Day
    @Published var currentDay: Date = Date()
    
    @Published var currentMonthIndex: Int = 0
    @Published var currentWeekIndex: Int = 0
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    
    // MARK: - Filter Today Tasks
    func filterTodayTasks() {
        
        let calendar  = Calendar.current
        let filtered = storedTasks.filter {
            calendar.isDate($0.creationDate, inSameDayAs: self.currentDay)
        }
        
        self.filteredTasks = filtered.sorted(by: { $0.creationDate < $1.creationDate })
        
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
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
}
