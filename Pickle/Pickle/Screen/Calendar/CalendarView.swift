//
//  CalendarView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            ForEach(calendarModel.currentWeek, id: \.self) { day in
                                
                                VStack(spacing: 10) {
                                    Text(calendarModel.extractDate(date: day, format: "dd"))
                                        .fontWeight(.semibold)
                                    Text(calendarModel.extractDate(date: day, format: "EEE"))
                                        .fontWeight(.semibold)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(calendarModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(calendarModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(calendarModel.isToday(date: day) ? .white : .black)
                                .frame(width: 45, height: 90)
                                .background(
                                    
                                    ZStack {
                                        
                                        if calendarModel.isToday(date: day) {
                                            
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        calendarModel.currentDay = day
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                    TasksView()
                    
                } header: {
                    HeaderView()
                        
                }
                
            }
            
            VStack {
                Text("여기 아래로 내일 미션 현황 넣기")
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        
    }
    
    // MARK: - 캘린더 뷰
    func TasksView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = calendarModel.filteredTasks {
                
                if tasks.isEmpty {
                    Text("No tasks found!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                        
                    }
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
            
        }
        .padding()
        .padding(.top)
        .onChange(of: calendarModel.currentDay) { newValue in
            calendarModel.filterTodayTasks()
        }
    }
    
    // MARK: - task card View
    func TaskCardView(task: CalendarSampleTask) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(calendarModel.isCurrentHour(date: task.calendarDate) ? .black : .white)
                    .frame(width: 15, height: 15)
                    .background(
                        
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                        
                    )
                    .scaleEffect(!calendarModel.isCurrentHour(date: task.calendarDate) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            VStack {
             
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(task.calendarTitle)
                                .font(.title2.bold())
                            Text(task.calendarDescription)
                        }
                        .hLeading()
                        
                        Text(task.calendarDate.formatted(date: .omitted, time: .shortened))
                    }
            }
            .foregroundColor(calendarModel.isCurrentHour(date: task.calendarDate) ? .white :  .black)
            .padding(calendarModel.isCurrentHour(date: task.calendarDate) ? 15 : 0)
            .padding(.bottom, calendarModel.isCurrentHour(date: task.calendarDate) ? 0 : 10)
            .hLeading()
            .background(
                Color.black
                    .cornerRadius(25)
                    .opacity(calendarModel.isCurrentHour(date: task.calendarDate) ? 1 : 0)
            )
        }
        .hLeading()
        
    }
    
    // MARK: - Header 뷰
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                Text("Today")
                    .font(.largeTitle)
                    .bold()
            }
            .hLeading()
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
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
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        
    }
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
        
    }
    func hCenter() -> some View {
        self
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        
    }
    // MARK: - Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}
