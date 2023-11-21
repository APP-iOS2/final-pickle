//
//  ClendarView+extension.swift
//  Pickle
//
//  Created by 박형환 on 11/9/23.
//

import SwiftUI

extension CalendarView {
    enum Routing: Hashable, Identifiable {
        var id: Self {
            return self
        }
        case calendar
    }
}
