//
//  TimerView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var timer: String = "30:00"
    @State var isShowGiveupAlert: Bool = false
    var toDo: String = "타이머뷰 완성하기...."
    var startTime: String = "오후 5:00"
    
    var body: some View {
        VStack {
            // 멘트부분
            Text("시작이 반이다! \n벌써 할 일 반 했네 최고다~~~")
                .font(Font.pizzaTitleBold)
                .padding(.top)
                .padding(.bottom, 50)
            // 타이머 부분
            ZStack {
                Circle()
                    .fill(Color.lightGray)
                    .frame(width: CGFloat.screenWidth * 0.75)
                    .overlay(Circle().stroke(Color.defaultGray, lineWidth: 20))
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 19, lineCap: .round))
                    .frame(width: CGFloat.screenWidth * 0.75)
                    .rotationEffect(.degrees(-90))
                VStack {
                    Image("smilePizza")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat.screenWidth * 0.5)
                    Text(timer)
                        .font(Font.pizzaTitleBold)
                }
            }
            
            // TODO: 완료 버튼~~~~~ 크게~~~~
            Button(action: {
                // 완료
            }, label: {
                Text("완료")
            })
            .buttonStyle(.borderedProminent)
            .tint(Color.black)
            .padding(.top)
            
            // 일시정지, 포기
            HStack {
                Button(action: {
                    // 일시정지
                }, label: {
                    HStack {
                        Image(systemName: "pause.fill")
                        Text("일시 정지")
                    }
                })
                Button(action: {
                    // 포기 alert띄우기
                    isShowGiveupAlert = true
                }, label: {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("포기")
                    }
                })
                
            }
            .buttonStyle(.bordered)
            .tint(Color.black)
            .padding(.top, 5)
            
            // 지금 하는 일
            HStack {
                VStack(alignment: .leading) {
                    Text(toDo)
                        .font(Font.pizzaHeadline)
                        .padding(.bottom)
                    Text(startTime)
                        .font(Font.pizzaFootnote)
                }
                Spacer()
            }
            .padding()
            .background(Color.lightGray)
            .cornerRadius(15)
            .padding([.leading, .trailing, .top], 30)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
            }
        }
        .alert(isPresented: $isShowGiveupAlert) {
            Alert(title: Text("정말 포기하시겠습니까?"),
                  message: Text("지금 포기하면 피자조각을 얻지 못해요"),
                  primaryButton: .destructive(Text("포기하기")) {
                // 포기하기 함수
                dismiss()
            }, secondaryButton: .cancel(Text("취소")))
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TimerView()
        }
    }
}
