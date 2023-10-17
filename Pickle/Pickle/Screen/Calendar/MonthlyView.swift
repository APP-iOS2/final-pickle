////
////  MonthlyView.swift
////  Pickle
////
////  Created by kaikim on 2023/10/11.
////
//
//import SwiftUI
//
//struct MonthlyView: View {
//    
//    //@Binding  var currentDate: Date
//    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
//    
//    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
//    var body: some View {
//        
//        VStack {
//            
//            HStack {
//                ForEach(days, id: \.self) { day in
//                    Text(day)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            HStack {
//                let colums = Array(repeating: GridItem(.flexible()), count: 7)
//                LazyVGrid(columns: colums, spacing: 15) {
//                    
//                    ForEach(calendarModel.fetchCurrentMonth(), id: \.self) { day in
//                        
//                        Text(day.format("dd"))
//                            .font(.callout)
//                            .fontWeight(.semibold)
//                    }
//                    
//                }
//            }
//            
//        }
//    }
//}
//
//#Preview {
//    MonthlyView()
//}
