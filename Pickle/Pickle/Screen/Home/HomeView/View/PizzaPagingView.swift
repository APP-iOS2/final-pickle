//
//  PizzaPagingView.swift
//  Pickle
//
//  Created by 박형환 on 11/18/23.
//

import SwiftUI

//enum ScrollPizzaID: Identifiable, Hashable {
//    var id: Self {
//        self
//    }
//    case pizza(String)
//}
//
//struct HomePagingView {
//    
//    @EnvironmentObject var userStore: UserStore
//    @EnvironmentObject var navigationStore: NavigationStore
//    @ObservedObject var viewModel: HomeViewModel
//    
//    private var btnFrame: CGFloat {
//        30
//    }
//    private var btnPadding: CGFloat {
//        8
//    }
//    private var pagePadding: CGFloat {
//        (btnFrame * 2) + (btnPadding * 4)
//    }
//    
//    var body: some View {
//        currentPizzaPagingView()
//    }
//    
//    private func currentPizzaPagingView() -> some View {
//        GeometryReader { geo in
//            HStack(spacing: 0) {
//                
//                pagingButton(false) {
//                    viewModel.nextPizzaScrollPosition(user: userStore.user, direction: false)
//                }
//                
//                pizzaPagingView(geo: geo)
//                
//                pagingButton(true) {
//                    viewModel.nextPizzaScrollPosition(user: userStore.user, direction: true)
//                }
//                
//            }.fixSize(geo)
//        }
//        .scrollIndicators(.hidden)
//    }
//    
//    private func pagingButton(_ right: Bool, _ action: @escaping () -> Void) -> some View {
//        Button {
//            action()
//        } label: {
//            Image(systemName: right ? "arrowshape.right.fill" : "arrowshape.left.fill" )
//                .resizable()
//                .foregroundStyle(Color.pickle)
//                .frame(width: btnFrame, height: btnFrame)
//        }
//        .padding(.horizontal, btnPadding)
//    }
//    
//    private func pizzaPagingView(geo: GeometryProxy) -> some View {
//        ScrollViewReader { proxy in
//            ScrollView(.horizontal) {
//                VStack(spacing: 0) {
//                    scrollObservableView
//                    LazyHStack(spacing: 0) {
//                        ForEach(userStore.user.currentPizzas, id: \.id) { currentPizza in
//                            ZStack {
//                                makePizzaView(currentPizza: currentPizza)
//                            }.fixSize(geo, diffX: -pagePadding)
//                                .id(ScrollPizzaID.pizza(currentPizza.pizza!.id))
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                viewModel.scrollViewDifference = geo.size.width - pagePadding
//            }
//            .coordinateSpace(name: "pizzaOffset")
//            .onPreferenceChange(ScrollOffsetKey.self) { value in
//                //  Log.debug("value : \(viewModel.remainder(offset: value))")
//                if viewModel.remainder(offset: value) == 0 {
//                    Log.debug("values : \(value)")
//                    viewModel.offset = value
//                }
//            }
//            .onReceive(viewModel.$pizzaPosition) { value in
//                withAnimation {
//                    proxy.scrollTo(value)
//                }
//            }
//        }
//    }
//    
//    private var scrollObservableView: some View {
//        GeometryReader { proxy in
//            let offsetX = proxy.frame(in: .named("pizzaOffset")).origin.x
//            Color.clear
//                .preference(
//                    key: ScrollOffsetKey.self,
//                    value: offsetX
//                )
//                .onAppear {
//                    viewModel.offset = offsetX  /* 나타날때 뷰의 최초위치를 저장하는 로직 */
//                }
//        }
//        .frame(height: 0)
//    }
//    
//    private func makePizzaView(currentPizza: CurrentPizza) -> some View {
//        PizzaView(
//            currentPizza: currentPizza
//        )
//        .frame(width: CGFloat.screenWidth / 2,
//               height: CGFloat.screenWidth / 2)
//        .padding()
//        .onTapGesture {
//            withAnimation {
//                navigationStore.pushHomeView(home: .isPizzaSeleted(true))
//            }
//        }
//    }
//}
