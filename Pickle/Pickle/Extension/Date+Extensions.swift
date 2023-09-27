//
//  Date+Extensions.swift
//  Pickle
//
//  Created by kaikim on 2023/09/26.
//

import SwiftUI

extension Date {
    
    // MARK: - Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
    
    // MARK: - Checking whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    var isPastHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    


    
    
    // MARK: - Fetching Week Based on given Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.autoupdatingCurrent
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
    
        // MARK: - iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    // MARK: - Creating Next Week, based on the Last Current Week's Date
    func createNextWeek() -> [WeekDay] {
        
        let calendar = Calendar.autoupdatingCurrent
        let startOfLastDate = calendar.startOfDay(for: self)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
        
    }

    // MARK: - Creating Previous Week, based on the First Current Week's Date
    func createPreviousWeek() -> [WeekDay] {
        
        let calendar = Calendar.autoupdatingCurrent
        let startOfFirstDate = calendar.startOfDay(for: self)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
    
        return fetchWeek(previousDate)
        
    }
}
