//
//  Keyboard.swift
//  loginTest
//
//  Created by Алексей Усанов on 15.10.2017.
//  Copyright © 2017 Алексей Усанов. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    func setupViewResizerOnKeyboardShown(bag:DisposeBag) {
        
        NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardWillShow)
            .bind { [weak self] (notification) in
                
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                    let v = self?.view,
                    let window = v.window?.frame {
                    v.frame = CGRect(x: v.frame.origin.x,
                                     y: v.frame.origin.y,
                                     width: v.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height + 22)
                }
                
            }.addDisposableTo(bag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name.UIKeyboardWillHide)
            .bind { [weak self] (notification) in
                
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                    let v = self?.view {
                    let viewHeight = v.frame.height
                    v.frame = CGRect(x: v.frame.origin.x,
                                     y: v.frame.origin.y,
                                     width: v.frame.width,
                                     height: viewHeight + keyboardSize.height)
                }
            }.addDisposableTo(bag)
    }
}
