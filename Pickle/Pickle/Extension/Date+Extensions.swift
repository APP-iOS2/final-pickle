//
//  Date+Extensions.swift
//  Pickle
//
//  Created by kaikim on 2023/09/26.
//

import SwiftUI

extension Date {
    
    static let formatter = DateFormatter()
    
    // MARK: - Custom Date Format
    func format(_ format: String) -> String {
        Date.formatter.dateFormat = format
        Date.formatter.locale = Locale(identifier: "ko_KR")
        Date.formatter.timeZone = TimeZone(identifier: "KST")
        return Date.formatter.string(from: self)

    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
    
    struct MonthDate: Identifiable,Hashable {
        var id = UUID().uuidString
        var day: Int
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
    
    /// '분' 더하는 메소드
    /// - Parameter minutes: 분
    /// - Returns: 더해진 날짜
    func adding(minutes: Int) -> Date {
        let date = Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        let formatter = Date.formatter
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = NSTimeZone(name: "ko_KR") as? TimeZone
        let str = formatter.string(from: date)
        return formatter.date(from: str)!
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
    
    func fetchMonth() -> [Date] {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = calendar.date(from: Calendar.autoupdatingCurrent.dateComponents([.year, .month], from: self))!
        var range = calendar.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate)!
        }
        
    }
    
    func fetchWeek() -> [Date] {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = calendar.date(from: Calendar.autoupdatingCurrent.dateComponents([.year, .month], from: self))!
        
        //let ddate = calendar.date(from: Calendar.autoupdatingCurrent.dateComponents([.], from: <#T##Date#>))
        var range = calendar.range(of: .day, in: .weekOfMonth, for: startDate)!
        range.removeLast()
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate)!
        }
        
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
