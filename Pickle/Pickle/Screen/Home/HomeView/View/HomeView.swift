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
    @EnvironmentObject var navigationStore: NavigationStore
    
    @Environment(\.scrollEnable) var scrollEnable
    
    @State private var tabBarvisibility: Visibility = .visible
    @State private var animatedText = ""
    @State private var currentIndex = 0
    private let fullText = "할일을 완료하고 피자를 모아보아요"
    @State var pizzaPosition: ScrollPizzaID = .pizza("")
    
    @State private var showCompleteAlert: Bool = false
    
    @State private var pizzaSelection: PizzaSelection = .init()
    @State private var editSelection: TodoSelection = .init()
    @State private var timerSelection: TimerSelection = .init()
    
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    
    var body: some View {
        content
            .task { 
                await todoStore.fetch()  // MARK: Persistent 저장소에서 Todo 데이터 가져오기
            }
            .onReceive(userStore.$user) {
                userUpdateAction(user: $0)
            }
            .onReceive(userStore.$currentPizza) { currentPizza in
                Log.debug("onReceive - userStore.$currentPizza: \(currentPizza.currentPizzaSlice)")
                if let pizza = currentPizza.pizza {
                    self.pizzaSelection.currentPizza = pizza
                    self.pizzaPosition = .pizza(pizza.id)
                }
            }
            .onReceive(navigationStore.$homeSheet) { sheet in
                routing(route: sheet)
            }
            .onChange(of: pizzaSelection.seletedPizza) { value in
                if value.lock == false {
                    userStore.trigger(action: .select(value))
                }
            }
            .navigationDestination(for: HomeView.Routing.self) { route in
                routing(stack: route)
            }
    }
    
    private func routing(stack route: HomeView.Routing) -> some View {
        if route == .pushMission {
            return AnyView(
                MissionView()
                .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            )
        } else if route == .pushRegisterTodo {
            return AnyView(
                RegisterView(willUpdateTodo: .constant(Todo.sample),
                             successDelete: .constant(false),
                             isShowingEditTodo: .constant(false),
                             isModify: false)
                .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func routing(route: HomeView.Routing) {
        switch route {
        case .isPizzaSeleted(let flag):
            withAnimation {
                pizzaSelection.isPizzaSelected = flag
            }
        case .isShowingEditTodo(let flag, let todo):
            self.editSelection = TodoSelection.init(isShowing: flag, seleted: todo)
        
        case .showCompleteAlert(let flag):
            self.showCompleteAlert = flag
            
        case .isShowingTimerView(let todo):
            self.timerSelection = .init(selectedTodo: todo,
                                        isShowingTimer: !timerSelection.isShowingTimer)
        default:
            break
        }
    }
    
    private func userUpdateAction(user: User) {
        pizzaUpdate(user: user)
        pizzaCompleteSuccessUpdate(user: user)
    }
    
    private func pizzaPuchaseORSelectedAction(pizza: Pizza) {
        if pizza.lock {
            /* selection.toggle() */
        } else {
             // pizzaSelection.currentPizza = pizza
             // CurrentPizza는 홈뷰가
        }
    }
    
    private func pizzaUpdate(user: User) {
        // TODO: 변경 필요
        //
        pizzaSelection.pizzas = userStore.user.currentPizzas.compactMap { $0.pizza }
        // placeHolderContent = userStore.user.currentPizzaSlice > 0 ? "" : "?"
    }
    
    // TODO: 변경 필요
    private func pizzaCompleteSuccessUpdate(user: User) {
        // if user.currentPizzaSlice % 8 == 0 {
        //     navigationStore.pushHomeView(home: .showCompleteAlert(true))
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        //         navigationStore.dismiss(home: .showCompleteAlert(false))
        //     }
        // }
    }
    
    private func unLockPizzaAction() {
        userStore.unLockPizza(pizza: pizzaSelection.seletedPizza)
        // TODO: 변경 필요
        // self.pizzaSelection.pizzas = self.userStore.user.pizzas
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
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    EmptyView()
                        .id(ScrollAnchor.home)
                    
                    currentPizzaPagingView()
                        .frame(width: CGFloat.screenWidth,
                               height: CGFloat.screenWidth / 2 + 44,
                               alignment: .center)

                    pizzaSliceAndDescriptionView    /* 피자 슬라이스 텍스트 뷰 + description View */
                    
                    if todoStore.readyTodos.isEmpty {
                        todayTodoEmptyView
                    } else {
                        todosTaskTableView          // 할일 목록 테이블 뷰
                    }
                }.padding(.vertical, 20)
            }.onChange(of: scrollEnable.root.wrappedValue) { enable in
                if enable { withAnimation { proxy.scrollTo(ScrollAnchor.home) } }
            }
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
    
    enum ScrollPizzaID: Identifiable, Hashable {
        var id: Self {
            self
        }
        case pizza(String)
    }
    
    private var btnFrame: CGFloat {
        30
    }
    private var btnPadding: CGFloat {
        8
    }
    private var pagePadding: CGFloat {
        (btnFrame * 2) + (btnPadding * 4)
    }
    
    private func currentPizzaPagingView() -> some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                
                pagingButton(false) {  }
                
                pizzaPagingView(geo: geo)
                
                pagingButton(true) { }
                
            }.fixSize(geo)
        }
        .onAppear { UIScrollView.appearance().isPagingEnabled = true }
        .scrollIndicators(.hidden)
    }
    
    private func pizzaPagingView(geo: GeometryProxy) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                VStack(spacing: 0) {
                    // FIX: spacing 으로 인한 scrollView 간격 불일치 0으로 해결
                    LazyHStack(spacing: 0) {
                        ForEach(userStore.user.currentPizzas, id: \.id) { currentPizza in
                            ZStack {
                                makePizzaView(currentPizza: currentPizza)
                            }.fixSize(geo, diffX: -pagePadding)
                                .id(ScrollPizzaID.pizza(currentPizza.pizza!.id))
                        }
                    }
                }
            }.onChange(of: pizzaPosition) { value in
                withAnimation {
                    proxy.scrollTo(value)
                }
            }
        } // .border(.brown)
    }
    
    private func makePizzaView(currentPizza: CurrentPizza) -> some View {
        PizzaView(
            currentPizza: currentPizza
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
    
    private func pagingButton(_ right: Bool, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: right ? "arrowshape.right.fill" : "arrowshape.left.fill" )
                .resizable()
                .foregroundStyle(Color.pickle)
                .frame(width: btnFrame, height: btnFrame)
        }
        .padding(.horizontal, btnPadding)
    }
    
    var pizzaSliceAndDescriptionView: some View {
        VStack(spacing: 0) {
            
            tempButton
            
            Text("\(userStore.currentPizza.pizzaTaskSlice)")
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
                .environmentObject(NavigationStore(mediator: NotiMediator()))
                .environmentObject(NotificationManager(mediator: NotiMediator()))
                .environment(\.scrollEnable, .constant(.init()))
        }
    }
}
