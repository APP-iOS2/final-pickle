//
//  TimeUnitPickerView.swift
//  Pickle
//
//  Created by 박형환 on 11/20/23.
//

import SwiftUI

struct TimeUnitPickerView: View {
    @Binding var targetTimes: String
    @Binding var show: Bool
    var targetTimeUnitStrs: [String]
    
    var body: some View {
        VStack {
            Picker("단위시간", selection: $targetTimes) {
                let times = targetTimeUnitStrs
                ForEach(times.indices, id: \.self) {
                    Text("\(times[$0])").tag(times[$0])
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.fraction(0.3)])
            
            Button {
                show.toggle()
            } label: {
                Text("확인")
                    .tint(Color.textGray)
            }
            .padding(.vertical, 10)
        }
    }
}
