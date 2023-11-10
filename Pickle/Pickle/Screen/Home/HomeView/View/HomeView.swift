//
//  HomeView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct HomeView: View {
    typealias PizzaSelection = PizzaSelectedView.Selection
    typealias TodoSelection = UpdateTodoView.Selection
    typealias TimerSelection = TodoCellView.Selection
    typealias PizzaImage = String
    
    init() {
        navigationAppearenceSetting()
    }
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var pizzaStore: PizzaStore
    
    @State private var animatedText = ""
    @State private var currentIndex = 0
    private let fullText = "할일을 완료하고 피자를 모아보아요"
    
    @State private var tabBarvisibility: Visibility = .visible
    
    @State private var showCompleteAlert: Bool = false
    
    @State private var pizzaSelection: PizzaSelection = .init()
    @State private var editSelection: TodoSelection = .init()
    @State private var timerSelection: TimerSelection = .init()
    
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    private let goalTotal: Double = 8                   // 피자 완성 카운트
    
    var body: some View {
        content
            .task { 
                await todoStore.fetch()  // MARK: Persistent 저장소에서 Todo 데이터 가져오기
            }
            .onReceive(userStore.$user) {
                updateValue(user: $0)
            }
            .onChange(of: pizzaSelection.seletedPizza) {
                pizzaPuchaseORSelectedAction(pizza: $0)
            }
            .onReceive(navigationStore.$homeSheet) { sheet in 
                routing(route: sheet)
            }
            
            .navigationDestination(for: HomeView.Routing.self) { route in
                routing(stack: route)
            }
    }
    }
    
    private func updateValue(user: User) {
        assginAction(user: user)
        pizza_8_successAction(user: user)
    }
    
    private func assginAction(user: User) {
        pizzaSelection.pizzas = userStore.user.pizzas
        placeHolderContent = userStore.user.currentPizzaSlice > 0 ? "" : "?"
    }
    
    private func pizza_8_successAction(user: User) {
        if user.currentPizzaSlice % 8 == 0 {
            navigationStore.pushHomeView(home: .showCompleteAlert(true))
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                navigationStore.dismiss(home: .showCompleteAlert(false))
            }
        }
    }
    
    private func pizzaPuchaseORSelectedAction(pizza: Pizza) {
        if pizza.lock {
            /*selection.toggle()*/
        } else {
            pizzaSelection.currentPizza = pizza
        }
    }
    
    private func unLockPizzaAction() {
        Log.debug("Unlock Pizza Action")
        userStore.unLockPizza(pizza: pizzaSelection.seletedPizza)
        self.pizzaSelection.pizzas = self.userStore.user.pizzas
    }
    
    private func startTyping() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            animatedText.append(fullText[index])
            currentIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                startTyping()
            }
        }
    }
}

// MARK: HomeView Component , PizzaView, button, temp component, task complte label
extension HomeView {
    
    var completeMessage: CompleteMessage {
        .init(isPresented: $showCompleteAlert,
              pizzaName: pizzaSelection.seletedPizza.image,
              title: "축하합니다",
              contents: pizzaSelection.seletedPizza.name)
    }
    
    var content: some View {
        ScrollView {
            VStack {
                makePizzaView(pizza: selection.currentPizza)                 /* 피자 뷰 */
                
                pizzaSliceAndDescriptionView    /* 피자 슬라이스 텍스트 뷰 + description View */
                
                if todoStore.readyTodos.isEmpty {
                    todayTodoEmptyView
                } else {
                    todosTaskTableView          // 할일 목록 테이블 뷰
                }
            }.padding(.vertical, 20)
        }
        .navigationSetting(tabBarvisibility: $tabBarvisibility) /* 뷰 네비게이션 셋팅 custom modifier */
                                                                /* leading - (MissionView), trailing - (RegisterView) */
        .completePizzaAlert(message: completeMessage)
        
        .sheetModifier(selection: $pizzaSelection)              /* PizzaSelectedView 피자 뷰를 클릭했을시 실행되는 Modifier */
        
        .fullScreenCover(edit: $editSelection)                  /* 풀스크린 Todo 수정뷰 모달 */
        .fullScreenCover(timer: $timerSelection)                /* 풀스크린  Timer 뷰  모달 */
        
        .showPizzaPurchaseAlert(pizzaSelection.seletedPizza,                   /* 피자 선택 sheet에서 피자를 선택하면 실행되는 alert Modifier */
                                $pizzaSelection.isPizzaPuchasePresent) {       /* 두가지의 (액션)클로져를 받는다, */
            Log.debug("인앱 결제 액션")                                            /* 1. 구매 액션 */
            unLockPizzaAction()
        }
        
    }
    
    private var taskPercentage: Double {
        Double(userStore.user.currentPizzaSlice) / goalTotal
    }
    private var pizzaTaskSlice: String {
        /// Pizza  ex) 1 / 8 - 유저의 완료한 피자조각 갯수....
        "\(Int(userStore.user.currentPizzaSlice)) / \(Int(goalTotal))"
    }
    
    func makePizzaView(pizza: Pizza) -> some View {
        ZStack {
            PizzaView(
                taskPercentage: taskPercentage,
                currentPizza: pizza,
                content: $placeHolderContent
            )
            .frame(width: CGFloat.screenWidth / 2,
                   height: CGFloat.screenWidth / 2)
            .padding()
            .onTapGesture {
                withAnimation {
                    navigationStore.pushHomeView(home: .isPizzaSeleted(true))
                }
            }
        }
    }
    
    var pizzaSliceAndDescriptionView: some View {
        VStack(spacing: 0) {
            
            tempButton
            
            Text("\(pizzaTaskSlice)")
                .font(.chab)
                .foregroundStyle(Color.pickle)
            
            Text(animatedText)
                .font(.pizzaHeadline)
                .onAppear {
                    currentIndex = 0
                    animatedText = ""
                    startTyping()
                }
                .padding(.vertical, 8)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }
    
    var todosTaskTableView: some View {
        // MARK: .ready 필터시 포기, 완료하면 시트 슈루룩 사라져버림
        ForEach(todoStore.readyTodos, id: \.id) { todo in
            TodoCellView(todo: todo)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .onTapGesture {
                    navigationStore.pushHomeView(home: .isShowingEditTodo(true, todo))
                }
        }
    }
    
    private var tempButton: some View {
        // MARK: 테스트용, 추후 삭제
        Button("할일 완료") {
            withAnimation {
                do {
                    try userStore.addPizzaSlice(slice: 1)
                } catch {
                    Log.error("❌피자 조각 추가 실패❌")
                }
            }
        }
        .foregroundStyle(.secondary)
    }
    
    private var todayTodoEmptyView: some View {
        VStack(spacing: 16) {
            Image("picklePizza")
                .resizable()
                .scaledToFit()
                .frame(width: .screenWidth - 200)
            
            Text("오늘 할일을 추가해 주세요!")
                .frame(maxWidth: .infinity)
                .font(.pizzaRegularSmallTitle)
        }
        .padding(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            let _ = PreviewsContainer.setUpDependency()
            let todo = TodoStore()
            let pizza = PizzaStore()
            let user = UserStore()
            let mission = MissionStore()
            let _ = PreviewsContainer.dependencySetting(pizza: pizza,
                                                        user: user,
                                                        todo: todo,
                                                        mission: mission)
            HomeView()
                .environmentObject(todo)
                .environmentObject(pizza)
                .environmentObject(user)
                .environmentObject(mission)
                .environmentObject(NotificationManager(mediator: NotiMediator()))
        }
    }
}
