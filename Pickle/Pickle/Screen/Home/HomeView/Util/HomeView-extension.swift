//
//  HomeView-extension.swift
//  Pickle
//
//  Created by 박형환 on 11/7/23.
//

import SwiftUI


extension HomeView {
    
    struct SheetModifier: ViewModifier {        
        @Binding var selection: PizzaSelectedView.Selection
        /*@Binding var updateSignal: Bool*/ // TODO: 피자 업데이트 신호,,,추후 변경
        
        @GestureState private var offset = CGSize.zero
        @EnvironmentObject var pizzaStore: PizzaStore
        @EnvironmentObject var userStore: UserStore
        
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
}
