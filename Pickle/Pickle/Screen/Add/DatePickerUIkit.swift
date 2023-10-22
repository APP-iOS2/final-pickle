//
//  DatePickerUIkit.swift
//  Pickle
//
//  Created by 박형환 on 10/22/23.
//

import UIKit
import SwiftUI

struct DatePickerUIKit: UIViewRepresentable {
    @Binding private var selection: Date

    private let range: ClosedRange<Date>?

    private var minimumDate: Date? {
         range?.lowerBound
    }

    private var maximumDate: Date? {
        range?.upperBound
    }

    private var minuteInterval: Int

    private let datePicker = UIDatePicker()

    init(selection: Binding<Date>, in range: ClosedRange<Date>?, minuteInterval: Int = 1) {
        self._selection = selection
        self.range = range
        self.minuteInterval = minuteInterval
    }

    func makeUIView(context: Context) -> UIDatePicker {
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = minuteInterval
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        datePicker.date = selection

    }

    func makeCoordinator() -> DatePickerUIKit.Coordinator {
        Coordinator(selection: $selection, in: range, minuteInterval: minuteInterval)
    }

    class Coordinator: NSObject {
        private let selection: Binding<Date>
        private let range: ClosedRange<Date>?
        private let minuteInterval: Int

        init(selection: Binding<Date>, in range: ClosedRange<Date>? = nil, minuteInterval: Int = 1) {
            self.selection = selection
            self.range = range
            self.minuteInterval = minuteInterval
        }

        @objc func changed(_ sender: UIDatePicker) {
            self.selection.wrappedValue = sender.date
        }
    }
}
