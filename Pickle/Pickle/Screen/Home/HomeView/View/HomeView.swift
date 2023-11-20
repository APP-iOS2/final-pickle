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
    @EnvironmentObject var navigationStore: NavigationStore
    @EnvironmentObject var timerVM: TimerViewModel
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    @Environment(\.scrollEnable) var scrollEnable
    
    @State private var tabBarvisibility: Visibility = .visible
    @State private var animatedText = ""
    @State private var currentIndex = 0
    @State private var showCompleteAlert: Bool = false
    private let fullText = "할일을 완료하고 피자를 모아보아요"
    
    @State private var pizzaSelection: PizzaSelection = .init()
    @State private var editSelection: TodoSelection = .init()
    @State private var timerSelection: TimerSelection = .init()
    @State private var description: String = ""
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    private let goalTotal: Double = 8                   // 피자 완성 카운트
    
    @State private var ongoingTodo: Todo = Todo(id: "",
                                                content: "",
                                                startTime: Date(),
                                                targetTime: 0,
                                                spendTime: 0,
                                                status: .ongoing)
    @AppStorage("isRunTimer") var isRunTimer: Bool = false
    @AppStorage("todoId") var todoId: String = ""
    
    var body: some View {
        content
            .task {
                await todoStore.fetch()  // MARK: Persistent 저장소에서 Todo 데이터 가져오기
                
                if isRunTimer { ongoingTodo = todoStore.getSeletedTodo(id: todoId) }
            }
            .onReceive(userStore.$user) {
                userUpdateAction(user: $0)
            }
            .onReceive(userStore.$currentPizza) { currentPizza in
                currentPizzaUpdateAction(currentPizza: currentPizza)
            }
            .onReceive(navigationStore.$homeSheet) { sheet in
                routing(route: sheet)
            }
            .onReceive(viewModel.$pizzaPosition) { _ in
                viewModel.trigger(action: .updatePosition(userStore.user))
            }
            .onChange(of: pizzaSelection.seletedPizza) { pizza in
                if pizza.lock == false { userStore.trigger(action: .select(pizza)) }
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
        }
        
        if route == .pushRegisterTodo {
            return AnyView(
                RegisterView(willUpdateTodo: .constant(Todo.sample),
                             successDelete: .constant(false),
                             isModify: false)
                .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            )
        }
        return AnyView(EmptyView())
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
            withAnimation {
                self.showCompleteAlert = flag
            }
        case .isShowingTimerView(let todo):
            self.timerSelection = .init(selectedTodo: todo,
                                        isShowingTimer: !timerSelection.isShowingTimer)
        default:
            break
        }
    }
    
    private func userUpdateAction(user: User) {
        pizzaSelection.pizzas = user.currentPizzas.compactMap { $0.pizza }
    }
    
    private func currentPizzaUpdateAction(currentPizza: CurrentPizza) {
        if let pizza = currentPizza.pizza {
            withAnimation(.easeIn(duration: 0.1)) {
                self.pizzaSelection.currentPizza = pizza
                self.viewModel.trigger(action: .updateCurrent(currentPizza))
            }
        }
        
        if currentPizza.currentPizzaSlice >= 8 {
            navigationStore.pushHomeView(home: .showCompleteAlert(true))
        }
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
    
    private func stopTodo() {
        let todo = Todo(id: timerVM.todo.id,
                        content: timerVM.todo.content,
                        startTime: timerVM.todo.startTime,
                        targetTime: timerVM.todo.targetTime,
                        spendTime: 0,
                        status: .giveUp)
        todoStore.update(todo: todo)
        isRunTimer = false
 
    }
    
    private func unLockPizzaAction() {
       let effect = viewModel.trigger(action: .unlock(userStore, pizzaSelection.seletedPizza))
        if case let .unlockFail(count) = effect {
            description = "피자 \(count)판을 더 모아야 잠금을 해제할 수 있어요"
            return
        }
        if case .success = effect {
            pizzaSelection.isPizzaPuchasePresent = false
            return
        }
   }
}

// MARK: HomeView Component , PizzaView, button, temp component, task complte label
extension HomeView {
    
    private var completeMessage: CompleteMessage {
        .init(isPresented: $showCompleteAlert,
              pizzaName: userStore.currentPizza.pizza?.image ?? "",
              title: "축하합니다",
              contents: userStore.currentPizza.pizza?.name ?? "",
              action: {
            userStore.addPizzaCount()
            navigationStore.dismiss(home: .showCompleteAlert(false))
        })
    }
    
    private var stopAlertContent: AlertContent {
        .init(isPresented: $timerVM.showOngoingAlert,
              title: "타이머 중단",
              alertContent: "앱이 종료되어 피자굽기를 실패하였습니다",
              primaryButtonTitle: "확인",
              secondaryButtonTitle: "",
              primaryAction: stopTodo,
              externalTapAction: stopTodo)
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
                }
                .padding(.vertical, 20)
            }
            .onChange(of: scrollEnable.root.wrappedValue) { enable in
                if enable { withAnimation { proxy.scrollTo(ScrollAnchor.home) } }
            }
            
        }
        .navigationSetting(tabBarvisibility: $tabBarvisibility) /* 뷰 네비게이션 셋팅 custom modifier */
                                                                /* leading - (MissionView), trailing - (RegisterView) */
        .completePizzaAlert(message: completeMessage) 
        
        .sheetModifier(selection: $pizzaSelection)              /* PizzaSelectedView 피자 뷰를 클릭했을시 실행되는 Modifier */
        
        .fullScreenCover(edit: $editSelection)                  /* 풀스크린 Todo 수정뷰 모달 */
        
        .fullScreenCover(timer: $timerSelection)                /* 풀스크린  Timer 뷰  모달 */
        
        .stopAlert(content: stopAlertContent)                   /* 할일 타이머 실패시 띄울 Alert */
        
        .showPizzaPurchaseAlert($pizzaSelection, $description, unLockPizzaAction) /* 피자 선택 sheet에서 피자를 선택하면 실행되는 alert Modifier */
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
                pizzaPagingView(geo: geo)
            }.fixSize(geo)
        }
        .scrollIndicators(.hidden)
    }
    
    private func pizzaPagingView(geo: GeometryProxy) -> some View {
        LazyHStack {
            TabView(selection: $viewModel.pizzaPosition) {
                ForEach(Array(zip(userStore.user.currentPizzas,
                                  userStore.user.currentPizzas.indices)),
                        id: \.1) { currentPizza in
                    ZStack {
                        makePizzaView(currentPizza: currentPizza.0)
                    }
                    .fixSize(geo, diffX: -pagePadding)
                    .tag(ScrollPizzaID.pizza(currentPizza.0.pizza!.id))
                }.padding(.bottom, 10)
                    .padding(.top, -10)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .fixSize(geo, diffY: 30)
        }
        .onAppear {
            viewModel.pizzaScrollViewWidth = geo.size.width - pagePadding
            setupAppearance()
        }
    }
    
    private func setupAppearance() {
        let color = UIColor(Color.pickle)
        UIPageControl.appearance().currentPageIndicatorTintColor = color
        UIPageControl.appearance().pageIndicatorTintColor = color.withAlphaComponent(0.3)
    }
    
    private var scrollObservableView: some View {
        GeometryReader { proxy in
            let offsetX = proxy.frame(in: .named("pizzaOffset")).origin.x
            Color.red
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetX
                )
                .onAppear {
                    viewModel.offset = offsetX  /* 나타날때 뷰의 최초위치를 저장하는 로직 */
                }
        }
        .frame(width: 0, height: 0)
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
            
            pizzaName
                .padding(.bottom, 10)
            
//            tempButton
            
            Text("\(viewModel.currentPositionPizza.pizzaTaskSlice)")
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
    
    private var pizzaName: some View {
        // Text("\(userStore.currentPizza.pizza?.name ?? "N/A")")
        Text("\(viewModel.currentPositionPizza.pizza?.name ?? "N/A")")
            .font(.pizzaStoreMiddle)
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
                .environmentObject(TimerViewModel())
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
