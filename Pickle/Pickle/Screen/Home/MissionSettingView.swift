//
//  MissionSettingView.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI

struct MissionSettingView: View {
    @Binding var title: String
    @Binding var isSettingModalPresented: Bool
    
    var body: some View {
        VStack {
            Text("\(title) 설정")
                .font(.pizzaTitle2Bold)
                .padding(.bottom, 10)
            
            DatePicker(selection: .constant(Date()), label: { Text("기상 시간") })
                .datePickerStyle(.compact)
            Spacer()
            
            Button {
                isSettingModalPresented.toggle()
            } label: {
                Text("수정")
            }

        }
        .padding()
//        .navigationTitle("\(title) 설정")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing:
//                                Button {
//            self.isSettingModalPresented.toggle()
//        } label: {
//            Text("수정")
//        })
    }
}

struct MissionSettingView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSettingView(title: .constant("기상 미션"), isSettingModalPresented: .constant(true))
    }
}
