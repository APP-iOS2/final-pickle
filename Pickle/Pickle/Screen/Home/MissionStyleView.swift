//
//  MissionStyle.swift
//  Pickle
//
//  Created by Suji Jang on 2023/09/25.
//

import SwiftUI

struct MissionStyle: Equatable {
    var twoButton: Bool
    var title: String
    var settingValue: String
}

struct CustomButton: View {
    @State var buttonText: String
    @State var buttonTextColor: Color
    @State var buttonColor: Color
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text(buttonText)
                    .font(.pizzaHeadline)
                        .foregroundColor(buttonTextColor)
            }
            .frame(width: 70, height: 5)
            .padding()
            .background(buttonColor)
            .cornerRadius(30.0)
            .overlay(RoundedRectangle(cornerRadius: 30.0)
                .stroke(Color(.systemGray4), lineWidth: 0.5))
        }
    }
}

struct MissionStyleView: View {
    var twoButton: Bool = false
    @State var title: String
    var settingValue: String
    var time: Int
    
    @State var isSettingModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.pizzaTitle2Bold)
                        .padding(.bottom, 1)
                    
                    Text(settingValue)
                        .font(.pizzaBody)
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                VStack {
                    if time == 7 {
                        CustomButton(buttonText: "완료", buttonTextColor: .white, buttonColor: .black, action: {
                        })
                    } else {
                        CustomButton(buttonText: "완료", buttonTextColor: .gray, buttonColor: .white, action: {
                        })
                        .disabled(true)
                    }
                    
                    if twoButton {
                        CustomButton(buttonText: "설정", buttonTextColor: .white, buttonColor: .black, action: {
                            isSettingModalPresented.toggle()
                        })
                        .sheet(isPresented: $isSettingModalPresented) {
                                MissionSettingView(title: $title, isSettingModalPresented: $isSettingModalPresented)
                                    .presentationDetents([.fraction(0.3)])
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(15.0)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
        .padding(.top, 15)
    }}

struct MissionStyle_Previews: PreviewProvider {
    static var previews: some View {
        MissionStyleView(twoButton: true, title: "기상 미션", settingValue: "오전 7시", time: 7)
    }
}
