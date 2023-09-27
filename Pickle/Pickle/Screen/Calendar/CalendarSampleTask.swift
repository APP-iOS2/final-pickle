//
//  CalendarSampleModel.swift
//  Pickle
//
//  Created by kaikim on 2023/09/25.
//

import SwiftUI

struct CalendarSampleTask: Identifiable {
    
    var id = UUID().uuidString
    var calendarTitle: String
    var calendarDescription: String
    var creationDate: Date
    var isCompleted: Bool = false
}
