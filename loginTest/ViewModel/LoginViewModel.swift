//
//  LoginViewModel.swift
//  loginTest
//
//  Created by Алексей Усанов on 14.10.2017.
//  Copyright © 2017 Алексей Усанов. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[$@$#!%?&])(?=.*[0-9])(?=.*[a-z]).{6,}$")
    
    var isValid : Observable<Bool>{
        return Observable.combineLatest(self.emailText.asObservable(), self.passwordText.asObservable())
        { (email, password) in
            return self.emailPredicate.evaluate(with: email)
                && self.passwordPredicate.evaluate(with: password)
        }
    }
}
