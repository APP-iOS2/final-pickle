//
//  TodoCellView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TodoCellView: View {
    var content: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lightGray)
                .frame(height: 80)
                .padding(.horizontal)
                .padding(.vertical, 4)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(content)
                        .font(.pizzaBody)
                    
                    Text("오후 5:00")
                        .font(.pizzaFootnote)
                }
                
                Spacer()
                
                NavigationLink {
                    TimerView()
                } label: {
                    Image(systemName: "play.fill")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {
        TodoCellView(content: "할일")
    }
}
