//
//  TodoCellView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TodoCellView: View {
    var content: String
    var startTime: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lightGray)
                .frame(height: 80)
                .padding(.horizontal)
                .padding(.vertical, 4)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(content)
                        .font(.pizzaBody)
                    
                    Text("\(startTime.format("a h:mm")) - \(startTime.adding(minutes: 10).format("a h:mm")) (10분)")
                        .font(.pizzaFootnote)
                }
                
                Spacer()
                
                NavigationLink {
                    TimerView()
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.clear)
                        
                        Image(systemName: "play.fill")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {
        TodoCellView(content: "할일", startTime: Date())
    }
}
