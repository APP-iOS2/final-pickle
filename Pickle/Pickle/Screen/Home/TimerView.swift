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
    
    @State var settingTime: Int = 0
    @State var timeRemaining: Int = 0
    @State var timeExtra: Int = 0
    @State var isShowGiveupAlert: Bool = false
    
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
                    
                    // 남은시간 줄어드는 타이머
                    Text(convertSecondsToTime(timeInSecond: timeRemaining))
                        .font(Font.pizzaTitleBold)
                        .onReceive(timer) { _ in
                            timeRemaining -= 1
                        }
                        
                }
            }
            .onAppear {
                    calcRemain()
            }
            
            // TODO: 완료 버튼 크게 넓이 맞추기(비율)
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
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        
//        if timeInSecond >= 3600 {
//            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
//        } else {
//            return String(format: "%02i:%02i", minutes, seconds)
//        }
    }
    
    // 남은 시간 계산하기
    func calcRemain() {
        let calendar = Calendar.current
        // TODO: 이거 대신 그냥 tagetTime으로 변경
        let targetTime : Date = calendar.date(byAdding: .second, value: 3700, to: startTime, wrappingComponents: false) ?? Date()
        let remainSeconds = Int(targetTime.timeIntervalSince(startTime))
        self.settingTime = remainSeconds
        self.timeRemaining = remainSeconds
    }
    // 추가 시간 계산하기
    func calcExtra() {
        let calendar = Calendar.current
        // TODO: 이거 대신 그냥 tagetTime으로 변경
        let targetTime : Date = calendar.date(byAdding: .second, value: 3800, to: startTime, wrappingComponents: false) ?? Date()
        let remainSeconds = Int(currnetTime.timeIntervalSince(targetTime))
        self.settingTime = 3600 // 원을 한시간으로 잡기?
        self.timeExtra = remainSeconds
    }
    // 총 걸린 시간 계산하기
    func calcTotal() -> String {
        let spendTime = Date()
        let totalTime = Int(currnetTime.timeIntervalSince(spendTime))
        return self.convertSecondsToTime(timeInSecond: totalTime)
    }
    
    func progress() -> CGFloat {
        return (CGFloat(settingTime - timeRemaining) / CGFloat(settingTime))
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TimerView()
        }
    }
}
