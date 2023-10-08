//
//  SettingView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct SettingView: View {
    @State private var is24HourClock: Bool = true
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    
                    Toggle("24시간제", isOn: $is24HourClock)
                    // TODO: 시간 표시하는 곳 체크해서 24시/12시 변환하기
                }
            }
            
            Section {
                NavigationLink {
                    // MARK: 테마
                } label: {
                    HStack {
                        Image(systemName: "circle.lefthalf.filled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        
                        Text("테마")
                    }
                }
                
                NavigationLink {
                    // MARK: 알림 설정
                } label: {
                    HStack {
                        Image(systemName: "bell.badge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        
                        Text("알림")
                    }
                }
            }
            
            Section {
                NavigationLink {
                    // MARK: 통계
                } label: {
                    HStack {
                        Image(systemName: "chart.pie")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        
                        Text("통계")
                    }
                }
                
                NavigationLink {
                    // MARK: 뱃지
                } label: {
                    HStack {
                        Image(systemName: "trophy")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        
                        Text("뱃지")
                    }
                }
            }
        }
        .navigationTitle("설정")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView()
        }
    }
}
