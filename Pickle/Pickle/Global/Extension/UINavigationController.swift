//
//  UINavigationController.swift
//  Pickle
//
//  Created by 박형환 on 11/17/23.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        /* SwiftUI 에서 swipe pop gesture를 사용하기 위한 delgate 할당*/
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
