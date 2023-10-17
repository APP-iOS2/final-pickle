//
//  HomeView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct HomeView: View {
    // @State private var userTotalPizza: Int = 0 // 사용자 프로퍼티로 추가 필요
    init() {
        navigationAppearenceSetting()
    }
    
    // @EnvironmentObject var sceneDelegate: SceneDelegate
    @EnvironmentObject var todoStore: TodoStore
    var healthKitStore: HealthKitStore = HealthKitStore()
    @EnvironmentObject var userStore: UserStore
    
    @State private var goalProgress: Double = 0.0
    @State private var pizzaText: String = "첫 피자를 만들어볼까요?"
    
    @State private var isShowingEditTodo: Bool = false
    @State private var isPizzaSeleted: Bool = false
    @State private var isPizzaPuchasePresented: Bool = false
    
    @State private var placeHolderContent: String = "?" // MARK: Dot Circle 뷰의 원 중심에 있는 content
    @State private var seletedTodo: Todo = Todo.sample
    
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
                makePizzaView()                 /* 피자 뷰 */
                pizzaSliceAndDescriptionView    /* 피자 슬라이스 텍스트 뷰 + description View */
                                                
                                                // MARK: 편집 일단 풀시트로 올라오게 했는데 네비게이션 링크로 바꿔도 됨
                                                // TODO: 현재 할일 목록이 없을때 나타낼 플레이스 홀더 내용이 필요함.
                todosTaskTableView              // 할일 목록 테이블 뷰
                
            }.padding(.top, 20)
                
        }
        .navigationSetting()                                    /* 뷰 네비게이션 셋팅 custom modifier */
                                                                /* leading - (MissionView), trailing - (RegisterView) */
        
        .fullScreenCover(isPresented: $isShowingEditTodo,       /* fullScreen cover // TODO: AddTodoView( 할일 수정뷰 - 추후 네이밍 변경) */
                         seletedTodo: $seletedTodo)             /* $isShowingEditTodo - 당연히 시트 띄우는 binding값 */
                                                                /* $seletedTodo - todosTaskTableView 에서 선택된 Todo 값 */
        
        .sheetModifier(isPresented: $isPizzaSeleted,            /* PizzaSelectedView 피자 뷰를 클릭했을시 실행되는 Modifier */
                       isPurchase: $isPizzaPuchasePresented)
        
        .showPizzaPurchaseAlert($isPizzaPuchasePresented)       /* 피자 선택 sheet에서 피자를 선택하면 실행되는 alert Modifier */
        .onAppear { /* */ }
        .task { await todoStore.fetch() }                       // MARK: Persistent 저장소에서 Todo 데이터 가져오기
        .onChange(of: userStore.user.currentPizzaSlice,         // MARK: 현재 피자조각 의 개수가 변할때 마다 호출되는 modifier
                  perform: { slice in
            placeHolderContent = slice == 0 ? "?" : ""          // 0일때는 place Holder content, 조각이 한개라도 존재하면 빈문자열
        })
    }
}

// MARK: HomeView Component , PizzaView, button, temp component, task complte label
extension HomeView {
    func makePizzaView() -> some View {
        ZStack {
            PizzaView(taskPercentage: taskPercentage, content: $placeHolderContent)
                .frame(width: CGFloat.screenWidth / 2,
                       height: CGFloat.screenWidth / 2)
                .padding()
                .onTapGesture {
                    withAnimation {
                        isPizzaSeleted.toggle()
                    }
                }
            tempView
        }
    }
    
    var pizzaSliceAndDescriptionView: some View {
        VStack(spacing: 0) {
            Text("\(pizzaTaskSlice)")
                .font(.chab)
                .foregroundStyle(Color.pickle)
            
            Text(pizzaText)
                .font(.pizzaHeadline)
        }
        .padding(.horizontal)
    }
    
    var todosTaskTableView: some View {
        ForEach(todoStore.todos, id: \.id) { todo in
            TodoCellView(todo: todo)
                .onTapGesture {
                    seletedTodo = todo
                    isShowingEditTodo.toggle()
                }
        }
    }
    
    private var tempView: some View {
        // MARK: 임시 이미지 추가
        HStack {
            Spacer()
            VStack {
                Image(systemName: "house")
                    .renderingMode(.template)
                    .foregroundStyle(Color.pickle)
                    .frame(width: 33, height: 33)
                    .padding(.horizontal, 15)
                
                Text("상점")
                    .font(.pizzaStoreSmall)
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
}

// MARK: HomeView Modifier
extension View {
    func navigationSetting() -> some View {
        modifier(NavigationModifier())
    }
    
    func sheetModifier(isPresented: Binding<Bool>,
                       isPurchase: Binding<Bool>) -> some View {
        modifier(HomeView.SheetModifier(isPresented: isPresented,
                                        isPizzaPuchasePresented: isPurchase))
    }
    
    func fullScreenCover(isPresented: Binding<Bool>,
                         seletedTodo item: Binding<Todo>) -> some View {
        
        modifier(HomeView.FullScreenCoverModifier(isPresented: isPresented,
                                                  seletedTodo: item))
    }
    
    func showPizzaPurchaseAlert(_ isPresented: Binding<Bool>) -> some View {
        modifier(PizzaAlertModifier(isPresented: isPresented,
                                    title: "치즈피자",
                                    price: "1,200원",
                                    descripation: "피자 2판을 완성하면 얻을수 있어요",
                                    image: "potatoPizza",
                                    puchaseButtonTitle: "피자 구매하기",
                                    primaryButtonTitle: "피자 완성하러 가기",
                                    primaryAction: { Log.debug("showPizzaPurchaseAlert") }))
    }
}

extension HomeView {
//    struct SheetModifier: ViewModifier {
//        @Binding var isPresented: Bool
//        @Binding var isPizzaPuchasePresented: Bool
//        func body(content: Content) -> some View {
//            content.sheet(isPresented: $isPresented) {
//                /* 피자 선택 뷰 */
//                PizzaSelectedView(isPresented: $isPizzaPuchasePresented)
//                    .presentationDetents(
//                        isPizzaPuchasePresented ? [.height(CGFloat.screenHeight / 4), .medium] : [.height(CGFloat.screenHeight / 3), .medium]
//                    )
//                    .interactiveDismissDisabled(isPizzaPuchasePresented)
//                    .presentationDragIndicator(.automatic)
//                    .onTapGesture {
//                        Log.debug("value Tap Gesture")
//                    }
//            }
//        }
//    }
    
    struct SheetModifier: ViewModifier {
        @Binding var isPresented: Bool
        @Binding var isPizzaPuchasePresented: Bool
        
        @GestureState private var offset = CGSize.zero
        
        func body(content: Content) -> some View {
            
            content
                .overlay {
                    if isPresented {
                        // For getting frame for image
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .global)
                            Color.black
                                .opacity(0.5)
                                .frame(width: frame.width, height: frame.height)
                        }
            //            .blur(radius: getBlurRadius()) // BlurRadius change depends on offset
                        .ignoresSafeArea()
                        
                        CustomSheetView(isPizzaPuchasePresented: $isPresented) {
                            PizzaSelectedView(isPresented: $isPizzaPuchasePresented)
                        }.transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .onChange(of: offset, perform: { offset in
                    Log.debug("offset: \(offset)")
                })
                .toolbar(isPresented ? .hidden : .visible, for: .tabBar)
        }
    }
    
    struct FullScreenCoverModifier: ViewModifier {
        @Binding var isPresented: Bool
        @Binding var seletedTodo: Todo
        func body(content: Content) -> some View {
            content.fullScreenCover(isPresented: $isPresented) {
                AddTodoView(isShowingEditTodo: $isPresented,
                            todo: $seletedTodo)
            }
        }
    }
}

private struct NavigationModifier: ViewModifier {
    
    @State private var tabBarVisibility: Visibility = .visible
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(Date().format("MM월 dd일 EEEE"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarBuillder }
            .toolbar( tabBarVisibility, for: .tabBar)
    }
    
    // MARK: Navigation Tool Bar , MissionView, RegisterView
    @ToolbarContentBuilder
    var toolbarBuillder: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                RegisterView(willUpdateTodo: .constant(Todo.sample), isModify: false) /* 등록할때는 willUpdateTodo 사용 x 임으로 샘플값 */
                    .backKeyModifier(visible: false)
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundStyle(Color.pickle)
                // .foregroundColor(.primary)
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                MissionView()
                    .backKeyModifier(visible: false)
            } label: {
                // TODO: 다크모드 대응
                Image("mission")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.pickle)
                    .frame(width: 24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(TodoStore())
    }
}
