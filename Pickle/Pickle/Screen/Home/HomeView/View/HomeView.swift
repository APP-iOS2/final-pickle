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
    
    init() {
        navigationAppearenceSetting()
    }
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var pizzaStore: PizzaStore
    
    @State private var goalProgress: Double = 0.0
    @State private var animatedText = ""
    
    @State private var currentIndex = 0
    let fullText = "할일을 완료하고 피자를 모아보아요"
    
    @State private var tabBarvisibility: Visibility = .visible
    
    @State private var routingState: Routing = .none
    
    @State private var isShowingEditTodo: Bool = false
    @State private var isPizzaPuchasePresented: Bool = false
    @State private var showCompleteAlert: Bool = false
    @State private var selection: PizzaSelectedView.Selection = .init(pizzas: [],
                                                                      seletedPizza: .defaultPizza,
                                                                      currentPizza: .defaultPizza,
                                                                      isPizzaSelected: false)
    
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    
    @State private var seletedTodo: Todo = Todo.sample

    typealias PizzaImage = String
    
    private let goalTotal: Double = 8                   // 피자 완성 카운트
    
    private var taskPercentage: Double {
        Double(userStore.user.currentPizzaSlice) / goalTotal
    }
    
    /// Pizza  ex) 1 / 8 - 유저의 완료한 피자조각 갯수....
    private var pizzaTaskSlice: String {
        "\(Int(userStore.user.currentPizzaSlice)) / \(Int(goalTotal))"
    }
    
    var body: some View {
        ScrollView {
            VStack {
                makePizzaView(pizza: selection.currentPizza)                 /* 피자 뷰 */
                pizzaSliceAndDescriptionView    /* 피자 슬라이스 텍스트 뷰 + description View */
                
                // MARK: 편집 일단 풀시트로 올라오게 했는데 네비게이션 링크로 바꿔도 됨
                // TODO: 현재 할일 목록이 없을때 나타낼 플레이스 홀더 내용이 필요함. - ready 가 없을때로 변경 - 필터로 완료
                if todoStore.readyTodos.isEmpty {
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
                } else {
                    todosTaskTableView          // 할일 목록 테이블 뷰
                }
            }.padding(.vertical, 20)
        }
        .navigationSetting(tabBarvisibility: $tabBarvisibility) /* 뷰 네비게이션 셋팅 custom modifier */
                                                                /* leading - (MissionView), trailing - (RegisterView) */
        .completePizzaAlert(isPresented: $showCompleteAlert,
                            pizzaName: selection.seletedPizza.image,
                            title: "축하합니다", contents: selection.seletedPizza.name)
        .sheetModifier(selection: $selection)                   /* PizzaSelectedView 피자 뷰를 클릭했을시 실행되는 Modifier */
        .showPizzaPurchaseAlert(selection.seletedPizza,         /* 피자 선택 sheet에서 피자를 선택하면 실행되는 alert Modifier */
                                $isPizzaPuchasePresented) {     /* 두가지의 (액션)클로져를 받는다, */
            Log.debug("인앱 결제 액션")                             /* 1. 구매 액션 */
            // MARK: 잠금해제 액션 부터 해보자
            userStore.unLockPizza(pizza: selection.seletedPizza)
        }
        .onPreferenceChange(PizzaPuchasePresentKey.self) { bool in
            isPizzaPuchasePresented = bool
        }
        .onAppear { /* */
            /*updateSignal.toggle()*/
            selection.pizzas = userStore.user.pizzas
            placeHolderContent = userStore.user.currentPizzaSlice > 0 ? "" : "?"  // placeHolder 표시할지 말지 분기처리
        }
        
        .onChange(of: selection.seletedPizza) { pizzaLockAction(pizza: $0) }
        .task { await todoStore.fetch() }                       // MARK: Persistent 저장소에서 Todo 데이터 가져오기
        .onReceive(userStore.$user) { updateValue(user: $0) }
        .navigationDestination(for: Todo.self, destination: { todo in
            // AddTodoView(isShowingEditTodo: .constant(false), todo: .constant(todo))
            RegisterView(willUpdateTodo: .constant(Todo.sample),
                         successDelete: .constant(false),
                         isShowingEditTodo: .constant(false),
                         isModify: false)
            .backKeyModifier(tabBarvisibility: $tabBarvisibility)
        })
    }
    
    private func pizzaLockAction(pizza: Pizza) {
        if pizza.lock {
            isPizzaPuchasePresented.toggle()
        } else { /*currentPizzaImg = pizza.image*/
            selection.currentPizza = pizza
        }
    }
    
    private func updateValue(user: User) {
        placeHolderContent = user.currentPizzaSlice == 0 ? "?" : ""
        // 0일때는 place Holder content, 조각이 한개라도 존재하면 빈문자열
        
        if user.currentPizzaSlice % 8 == 0 {
            showCompleteAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.showCompleteAlert = false
            }
        }
    }
}

// MARK: HomeView Component , PizzaView, button, temp component, task complte label
extension HomeView {
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
}

// MARK: HomeView Modifier
extension View {
    
    @ViewBuilder
    func routing(routing: Binding<HomeView.Routing>) -> some View {
        
    }
    
    func navigationSetting(tabBarvisibility: Binding<Visibility>) -> some View {
        modifier(NavigationModifier(tabBarvisibility: tabBarvisibility))
    }
    
    func mutilpleModifier(selection: Binding<PizzaSelectedView.Selection>,
                          isPresented: Binding<Bool>,
                          seletedTodo item: Binding<Todo>,
                          value: PZAContent) {
        modifier(<#T##modifier: T##T#>)
    }
    
    func sheetModifier(selection: Binding<PizzaSelectedView.Selection>) -> some View {
        
        modifier(HomeView.SheetModifier(selection: selection))
    }
    
    func fullScreenCover(isPresented: Binding<Bool>,
                         seletedTodo item: Binding<Todo>) -> some View {
        
        modifier(HomeView.FullScreenCoverModifier(isPresented: isPresented,
                                                  seletedTodo: item))
    }
    
    func showPizzaPurchaseAlert(_ pizza: Pizza,
                                _ isPizzaPuchasePresented: Binding<Bool>,
                                _ purchaseAction: @escaping () -> Void,
                                _ navAction: (() -> Void)? = nil) -> some View {
        modifier(PizzaAlertModifier(isPresented: isPizzaPuchasePresented,
                                    title: "\(pizza.name)",
                                    price: "",
                                    descripation: "피자 2판을 완성하면 얻을수 있어요",
                                    image: "\(pizza.image)",
                                    lock: pizza.lock,
                                    puchaseButtonTitle: "피자 구매하기 (₩1,200)",
                                    primaryButtonTitle: "피자 완성하러 가기",
                                    primaryAction: purchaseAction,
                                    pizzaMakeNavAction: navAction))
    }
}

extension HomeView {
    
    struct SheetModifier: ViewModifier {
        @State private var pizzas: [Pizza] = []
                
        @Binding var selection: PizzaSelectedView.Selection
        /*@Binding var updateSignal: Bool*/ // TODO: 피자 업데이트 신호,,,추후 변경
        
        @GestureState private var offset = CGSize.zero
        @EnvironmentObject var pizzaStore: PizzaStore
        @EnvironmentObject var userStore: UserStore
        
        func fetchPizza() async {
            pizzas = await pizzaStore.fetch()
            Log.debug("pizzas: \(pizzas.map(\.lock))")
        }
        
        func body(content: Content) -> some View {
            
            content
                .overlay {
                    if selection.isPizzaSelected {
                        // For getting frame for image
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .global)
                            Color.black
                                .opacity(0.3)
                                .frame(width: frame.width, height: frame.height)
                        }
                        .ignoresSafeArea()
                        
                        CustomSheetView(isPresented: $selection.isPizzaSelected) {
                            PizzaSelectedView(selection: $selection)
                        }.transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .toolbar(selection.isPizzaSelected ? .hidden : .visible, for: .tabBar)
        }
    }
    
    struct FullScreenCoverModifier: ViewModifier {
        @Binding var isPresented: Bool
        @Binding var seletedTodo: Todo
        func body(content: Content) -> some View {
            content.fullScreenCover(isPresented: $isPresented) {
                UpdateTodoView(isShowingEditTodo: $isPresented,
                            todo: $seletedTodo)
            }
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
}

private struct NavigationModifier: ViewModifier {
    
    @Binding var tabBarvisibility: Visibility
        
    func body(content: Content) -> some View {
        content
            .navigationTitle(Date().format("MM월 dd일 EEEE"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarBuillder }
            .toolbar( tabBarvisibility, for: .tabBar)
    }
    
    // MARK: Navigation Tool Bar , MissionView, RegisterView
    @ToolbarContentBuilder
    var toolbarBuillder: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                RegisterView(willUpdateTodo: .constant(Todo.sample),
                             successDelete: .constant(false),
                             isShowingEditTodo: .constant(false),
                             isModify: false)
                .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundStyle(Color.pickle)
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                MissionView()
                    .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            } label: {
                Image("mission")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
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


//
//extension EnvironmentValues {
//    var pizzaSeleted: Bool {
//        get { self[Bool.self] }
//        set { self[Bool.self] = newValue }
//    }
//
//}


//onReceive User : User(id: "6548af6741e16193d2b38866", nickName: "Guest", currentPizzaCount: 2, currentPizzaSlice: 6, pizzas: [Pickle.Pizza(id: "23F68A94-1CB2-48D2-AD99-C4A0CD50C9FE", name: "페퍼로니 피자", image: "pepperoni", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "51178CA9-30A4-463D-B5BA-74D77697BC8B", name: "치즈 피자", image: "cheese", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "E0F8995A-C3CD-49ED-AA06-4D64F86EB699", name: "포테이토 피자", image: "potato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "58B24BBE-FBC1-4A09-B12D-FCB43F39C45C", name: "베이컨 포테이토 피자", image: "baconPotato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "B412295E-21C1-4DEE-B424-5F9A5656C131", name: "하와이안 피자", image: "hawaiian", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "48C6E204-0732-4695-A731-B4E62625D35F", name: "고구마 피자", image: "sweetPotato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "B21FB3CC-0F5F-4E98-BD38-860CE2EC5427", name: "마르게리타 피자", image: "margherita", lock: false, createdAt: 2023-11-06 09:18:30 +0000)], currentPizzas: [], createdAt: 2023-11-06 09:18:30 +0000)
//
//onReceive User : User(id: "6548af6741e16193d2b38866", nickName: "Guest", currentPizzaCount: 2, currentPizzaSlice: 6, pizzas: [Pickle.Pizza(id: "F6E88F55-C997-46C0-AE61-73FCFFB79F60", name: "페퍼로니 피자", image: "pepperoni", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "40740DF3-3418-42E7-8758-2632D85CD37D", name: "치즈 피자", image: "cheese", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "A4516E6E-1281-473D-985C-9F35A06D0CA2", name: "포테이토 피자", image: "potato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "5A976839-E3A1-46B7-875E-07C435EE4AB7", name: "베이컨 포테이토 피자", image: "baconPotato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "A2693762-0F2D-4B4B-A5F6-949692D9D55F", name: "하와이안 피자", image: "hawaiian", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "75230584-0732-4548-B5E2-705E6248BB8A", name: "고구마 피자", image: "sweetPotato", lock: false, createdAt: 2023-11-06 09:18:30 +0000), Pickle.Pizza(id: "C5E572FB-AFA9-478B-A7E8-F6B033184FAA", name: "마르게리타 피자", image: "margherita", lock: false, createdAt: 2023-11-06 09:18:30 +0000)], currentPizzas: [], createdAt: 2023-11-06 09:18:30 +0000)
