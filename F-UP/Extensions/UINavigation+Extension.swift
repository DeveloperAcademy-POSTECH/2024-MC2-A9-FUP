//
//  View+Extension.swift
//  F-UP
//
//  Created by namdghyun on 5/24/24.
//

import SwiftUI
import UIKit

// NavigationBackButtonHidden 하더라도 스와이프로 뒤로가기 되게 하는 확장
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
