//
//  HomeView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct PizzaSelectionSheetKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        defaultValue = nextValue()
    }
}

struct HomeView: View {
    
    typealias PizzaSelection = PizzaSelectedView.Selection
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
    
    @State private var routingState: Routing = .none
    
    @State private var isShowingEditTodo: Bool = false
    @State private var isPizzaPuchasePresent: Bool = false
    @State private var showCompleteAlert: Bool = false
    
    @State private var selection: PizzaSelection = .init(pizzas: [],
                                                         seletedPizza: .defaultPizza,
                                                         currentPizza: .defaultPizza,
                                                         isPizzaSelected: false)
    
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    @State private var seletedTodo: Todo = Todo.sample
    
    @State private var goalProgress: Double = 0.0
    private let goalTotal: Double = 8                   // 피자 완성 카운트
    private var taskPercentage: Double {
        Double(userStore.user.currentPizzaSlice) / goalTotal
    }
    private var pizzaTaskSlice: String {
        /// Pizza  ex) 1 / 8 - 유저의 완료한 피자조각 갯수....
        "\(Int(userStore.user.currentPizzaSlice)) / \(Int(goalTotal))"
    }
    
    var body: some View {
        content
            .onPreferenceChange(PizzaPuchasePresentKey.self) { bool in isPizzaPuchasePresent = bool }
            .task { await todoStore.fetch() }  // MARK: Persistent 저장소에서 Todo 데이터 가져오기
            .onReceive(userStore.$user) { updateValue(user: $0) }
            .onChange(of: selection.seletedPizza) { pizzaPuchaseORSelectedAction(pizza: $0) }
    }
    
    private func updateValue(user: User) {
        assginAction(user: user)
        pizza_8_successAction(user: user)
    }
    
    private func assginAction(user: User) {
        Log.debug("onAppear Action")
        selection.pizzas = userStore.user.pizzas
        placeHolderContent = userStore.user.currentPizzaSlice > 0 ? "" : "?"
    }
    
    private func pizza_8_successAction(user: User) {
        if user.currentPizzaSlice % 8 == 0 {
            showCompleteAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.showCompleteAlert = false
            }
        }
    }
    
    private func pizzaPuchaseORSelectedAction(pizza: Pizza) {
        if pizza.lock {
            isPizzaPuchasePresent.toggle()
        } else {
            selection.currentPizza = pizza
        }
    }
    
    private func unLockPizzaAction() {
        Log.debug("Unlock Pizza Action")
        userStore.unLockPizza(pizza: selection.seletedPizza)
        self.selection.pizzas = self.userStore.user.pizzas
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
              pizzaName: selection.seletedPizza.image,
              title: "축하합니다",
              contents: selection.seletedPizza.name)
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
        .navigationDestination(for: Todo.self, destination: { todo in
            RegisterView(willUpdateTodo: .constant(Todo.sample),
                         successDelete: .constant(false),
                         isShowingEditTodo: .constant(false),
                         isModify: false)
            .backKeyModifier(tabBarvisibility: $tabBarvisibility)
        })
        .navigationSetting(tabBarvisibility: $tabBarvisibility) /* 뷰 네비게이션 셋팅 custom modifier */
                                                                /* leading - (MissionView), trailing - (RegisterView) */
        
        .completePizzaAlert(message: completeMessage)
        
        .sheetModifier(selection: $selection)                   /* PizzaSelectedView 피자 뷰를 클릭했을시 실행되는 Modifier */
        
        .showPizzaPurchaseAlert(selection.seletedPizza,         /* 피자 선택 sheet에서 피자를 선택하면 실행되는 alert Modifier */
                                $isPizzaPuchasePresent) {       /* 두가지의 (액션)클로져를 받는다, */
            Log.debug("인앱 결제 액션")                             /* 1. 구매 액션 */
            unLockPizzaAction()
        }
    }
    
    func makePizzaView(pizza: Pizza) -> some View {
        ZStack {
            PizzaView(taskPercentage: taskPercentage, currentPizza: pizza, content: $placeHolderContent)
                .frame(width: CGFloat.screenWidth / 2,
                       height: CGFloat.screenWidth / 2)
                .padding()
                .onTapGesture {
                    withAnimation {
                        /*isPizzaSelected.toggle()*/
                        selection.isPizzaSelected.toggle()
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
                    seletedTodo = todo
                    isShowingEditTodo.toggle()
                }
        }
        .fullScreenCover(isPresented: $isShowingEditTodo,         /* fullScreen cover */
                         seletedTodo: $seletedTodo)               /* $isShowingEditTodo - 당연히 시트 띄우는 binding값 */
                                                                  /* $seletedTodo - todosTaskTableView 에서 선택된 Todo 값 */
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
                .environmentObject(NotificationManager())
        }
    }
}

extension HomeView {
    enum Routing: Identifiable {
        var id: Self {
            return self
        }
        case isShowingEditTodo
        case isPizzaSeleted
        case isPizzaPuchasePresented
        case showCompleteAlert
        case none
    }
}
enum AlertType: Identifiable {
    var id: Self {
        return self
    }
    case isShowingEditTodo
    case isPizzaSeleted
    case isPizzaPuchasePresented
    case showCompleteAlert
    case none
}
