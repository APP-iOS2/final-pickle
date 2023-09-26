//
//  RegisterView.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var text: String = ""
    @State private var showingAlarmSelectSheet: Bool = false
    @State private var showingDateSelectSheet: Bool = false
    @State private var wakeUp = Date()
    
    @State private var seletedTimes: Date = Date()
    @State private var seletedAlarm: String = "시간 선택"
    private let alarmCount: [String] = ["한번", "두번", "3번"]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    todoTitleInputField
                        .padding(.top, 40)
                    repeatDay
                    timeConstraint
                    alarmSelector
                    Spacer()
                    comfirmButton
                }
                .frame(minHeight: geometry.size.height)
            }.frame(width: geometry.size.width)
        }
    }
    
    @ViewBuilder
    private var todoTitleInputField: some View {
        VStack {
            Text("할일 추가")
                .font(Font.pizzaTitle2)
                .bold()
            
            TextField("안녕하신가", text: $text)
                .padding(.horizontal, 16)
                .makeTextField {
                    print("\(text)")
                }
                .padding()
        }
    }
        
    @ViewBuilder
    private var repeatDay: some View {
        HStack {
            Text("반복 요일")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            
            Spacer()
            Button {
                showingAlarmSelectSheet.toggle()
            } label: {
                Text("주말")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingAlarmSelectSheet) {
            alarmPickerView
        }
    }
    
    @ViewBuilder
    private var timeConstraint: some View {
        HStack {
            Text("시작조건")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                showingDateSelectSheet.toggle()
            } label: {
                Text("시간 선택")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingDateSelectSheet) {
            VStack {
                dataPickerView
            }
        }
    }
    
    @ViewBuilder
    private var alarmSelector: some View {
        HStack {
            Text("알림")
                .font(Font.pizzaBody)
                .bold()
                .padding(.vertical, 16)
                .padding(.leading, 16)
            Spacer()
            Button {
                showingAlarmSelectSheet.toggle()
            } label: {
                Text("\(seletedAlarm)")
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .tint(Color.textGray)
            }
        }
        .asRoundBackground()
        .sheet(isPresented: $showingAlarmSelectSheet) {
            alarmPickerView
        }
    }
    
    @ViewBuilder
    private var comfirmButton: some View {
        Button {
            
        } label: {
            Text("확인")
                .padding()
                .frame(width: 200)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private var dataPickerView: some View {
        VStack {
            DatePicker("시간 선택", selection: $wakeUp,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .presentationDetents([.fraction(0.3)])
            
            Button {
                showingDateSelectSheet.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
    @ViewBuilder
    private var alarmPickerView: some View {
        VStack {
            Picker("language", selection: $seletedAlarm) {
                ForEach(0..<alarmCount.count) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.fraction(0.3)])
            
            Button {
                showingAlarmSelectSheet.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
