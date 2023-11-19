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
    
    func showPizzaPurchaseAlert(_ pizzaSelection: Binding<HomeView.PizzaSelection>,
                                _ description: Binding<String>,
                                _ purchaseAction: @escaping () -> Void,
                                _ navAction: (() -> Void)? = nil) -> some View {
        let pizza = pizzaSelection.wrappedValue.seletedPizza
        return modifier(PizzaAlertModifier(isPresented: pizzaSelection.isPizzaPuchasePresent,
                                           title: "\(pizza.name)",
                                           price: "",
                                           description: description,
                                           image: "\(pizza.image)",
                                           lock: pizza.lock,
                                           puchaseButtonTitle: "잠금해제 하기",
                                           primaryButtonTitle: "피자 완성하러 가기",
                                           primaryAction: purchaseAction,
                                           pizzaMakeNavAction: navAction))
    }
}
