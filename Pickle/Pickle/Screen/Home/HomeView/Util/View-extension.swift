//
//  View.swift
//  Pickle
//
//  Created by 박형환 on 11/7/23.
//

import SwiftUI

// MARK: HomeView Modifier
extension View {
    
    func navigationSetting(tabBarvisibility: Binding<Visibility>) -> some View {
        modifier(NavigationModifier(tabBarvisibility: tabBarvisibility))
    }
    
    func sheetModifier(selection: Binding<PizzaSelectedView.Selection>) -> some View {
        
        modifier(HomeView.SheetModifier(selection: selection))
    }
    
    func fullScreenCover(edit selection: Binding<UpdateTodoView.Selection>) -> some View {
        
        modifier(HomeView.FullScreenCoverModifier(selection: selection))
    }
    
    func fullScreenCover(timer selection: Binding<TodoCellView.Selection>) -> some View {
        modifier(HomeView.TimerViewModifier(selection: selection))
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
