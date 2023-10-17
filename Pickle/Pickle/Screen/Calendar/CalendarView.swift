//
//  CalendarView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var weekToMonth: Bool = false
    
    @State private var tasks = CalendarViewModel().filteredTasks
    
    @Namespace private var animation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HeaderView()
            
            ScrollView(.vertical) {
                VStack {
                    taskView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                    
                }
            }
        }
        .onChange(of: calendarModel.currentDay) { newValue in
            calendarModel.filterTodayTasks()
        }
        //        .onChange(of: calendarModel.currentMonth) { newValue in
        //
        //        }
        
    }
    
    //    func paginationWeek() {
    //
    //        // MARK: - safe check
    //        if weekSlider.indices.contains(currentWeekIndex) {
    //            if let firstDate =  weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
    //
    //                // MARK: - inserting new week at 0th index and removing last arry item
    //                weekSlider.insert(firstDate.createPreviousWeek(), at: 0 )
    //                weekSlider.removeLast()
    //                currentWeekIndex = 1
    //
    //            }
    //
    //            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
    //
    //                // MARK: - Appending new week at last index and removing first arry item
    //                weekSlider.append(lastDate.createNextWeek())
    //                weekSlider.removeFirst()
    //
    //                currentWeekIndex = weekSlider.count - 2
    //            }
    //
    //        }
    //
    //    }
    
    // MARK: - Header 뷰
    @ViewBuilder
    func HeaderView() -> some View {
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
                        print(weekToMonth)
                    }, label: {
                        Text("주간")
                            .font(.headline)
                            .bold()
                    })
                    .padding(.horizontal, 1)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 50))
                    
                    Button(action: {
                        calendarModel.currentMonthIndex -= 1
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    Button(action: {
                        calendarModel.currentMonthIndex = 0
                        calendarModel.currentDay = Date()
                    }, label: {
                        Text("오늘")
                            .font(.pizzaBody)
                        
                    })
                    Button(action: {
                        calendarModel.currentMonthIndex += 1
                    }, label: {
                        Image(systemName: "chevron.right")
                    })
                    
                }
                monthlyView()
            }
            .hLeading()
        }
        .padding()
        .hSpacing(.leading)
        //        .onChange(of: currentWeekIndex) { newValue in
        //
        //            // MARK: - Creating when it reaches first/last page
        //            if newValue == 0 || newValue == (weekSlider.count - 1) {
        //                createWeek = true
        //            }
        //        }
    }
    
    // MARK: - Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(isSameDate(day.date, date2: calendarModel.currentDay) ? .white : .gray)
                        .frame(width: 35, height: 35)
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
                                    .offset(y: -66)
                            }
                            Circle()
                                .fill(Color.red)
                                .frame(width: 5, height: 5)
                                .vSpacing(.bottom)
                                .offset(y: 12)
                            
                        }
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hCenter()
                .contentShape(.rect)
                //                .onTapGesture {
                //
                //                    // MARK: - Updating Current Date
                //                    withAnimation(.snappy) {
                //                        calendarModel.currentDay = day.date
                //                    }
                //                }
                
            }
            
        }
        //        .background {
        //            GeometryReader {
        //                let minX = $0.frame(in: .global).minX
        //
        //                Color.clear
        //                    .preference(key: OffsetKey.self, value: minX)
        //                    .onPreferenceChange(OffsetKey.self) { value in
        //                        // MARK: - when the offset reaches 15 and the createweek is toggled then generating next set of week
        //                        if value.rounded() == 15 && createWeek {
        //                            paginationWeek()
        //                            print("Generate")
        //                            createWeek =  false
        //                        }
        //                    }
        //            }
        //        }
        
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

            ForEach(calendarModel.filteredTasks!) { task in

                TaskRowView(task: task)
            }
        }
        .padding([.vertical, .leading], 15)
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
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
