//
//  TimerView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var toDo: String = "타이머뷰 완성하기...."
    let currnetTime = Date()
    let startTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var targetTime: Int = 1 // 목표소요시간
    @State var timeRemaining: Int = 0 // 남은 시간
    @State var spendTime: Int = 0 // 실제 소요시간
    @State var timeExtra: Int = 0 // 추가소요시간
    @State var settingTime: Int = 0 // 원형 타이머 설정용 시간
    @State var isShowGiveupAlert: Bool = false
    @State var isDecresing: Bool = true
    
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
                    .trim(from: 0, to: progress())
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 19, lineCap: .round))
                    .frame(width: CGFloat.screenWidth * 0.75)
                    .rotationEffect(.degrees(-90))
                VStack {
                    Image("smilePizza")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat.screenWidth * 0.5)
                    
                    if isDecresing {
                        // 남은시간 줄어드는 타이머
                        Text(convertSecondsToTime(timeInSecond: timeRemaining))
                            .font(Font.pizzaTitleBold)
                            .onReceive(timer) { _ in
                                timeRemaining -= 1
                                if timeRemaining == 0 {
                                    turnMode()
                                }
                            }
                    } else {
                        // 추가시간 늘어나는 타이머
                        Text("+ \(convertSecondsToTime(timeInSecond: timeExtra))")
                            .font(Font.pizzaTitleBold)
                            .onReceive(timer) { _ in
                                timeExtra += 1
                                if timeExtra % 60 == 0 {
                                    turnMode()
                                }
                            }
                    }
                    
                    // 실제 소요시간 타이머
                    Text(convertSecondsToTime(timeInSecond: spendTime))
                        .foregroundColor(Color.textGray)
                        .onReceive(timer) { _ in
                            spendTime += 1
                        }
                        
                }
            }
            .onAppear {
                calcRemain()
            }
                        
            // 완료, 포기 버튼
            HStack {
                // TODO: 완료 버튼 크게 넓이 맞추기
                Button(action: {
                    // 완료
                }, label: {
                    Image(systemName: "checkmark.seal")
                    Text("완료")
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
            .padding(.top, 10)
            
            // 지금 하는 일
            HStack {
                VStack(alignment: .leading) {
                    Text(toDo)
                        .font(Font.pizzaHeadline)
                        .padding(.bottom)
                    Text("오후 5:00")
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
    // TODO: 한시간 안넘어가면 분, 초 만 보여주기
    // 초 -> HH:MM:SS로 보여주기
    func convertSecondsToTime(timeInSecond: Int) -> String {
        let hours = timeInSecond / 3600 // 시
        let minutes = (timeInSecond - hours*3600) / 60 // 분
        let seconds = timeInSecond % 60 // 초
        
        if timeInSecond >= 3600 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    // TODO: data 구조보고 변수명 바꿔주기
    // 남은 시간 계산하기
    func calcRemain() {
        self.settingTime = targetTime * 60
        self.timeRemaining = settingTime
    }

    func turnMode() {
        self.isDecresing = false
        self.settingTime = 600
    }
    
    func progress() -> CGFloat {
        if isDecresing {
            return (CGFloat(settingTime - timeRemaining) / CGFloat(settingTime))
        } else {
            return (CGFloat(timeExtra % 60) / CGFloat(settingTime))
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
