//
//  LoginViewController.swift
//  loginTest
//
//  Created by Алексей Усанов on 14.10.2017.
//  Copyright © 2017 Алексей Усанов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var loginViewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    let apikey = "85ba913e169805275b38fddaf88f91cd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        self.setupViewResizerOnKeyboardShown(bag: disposeBag)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: loginViewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: loginViewModel.passwordText)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid.map { $0 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.view.endEditing(true)
            _ = Alamofire.request("https://api.darksky.net/forecast/\(self.apikey)/55.4507,37.3656?lang=ru&units=si").rx.responseJSON()
                .map { value in
                    let json = value as? [String: Any] ?? [:]
                    let data = json["daily"] as? [String: Any] ?? [:]
                    return data["summary"]! as! String
                }
                .subscribe(onNext: {
                    self.alertShow(message: $0)
                })
        }).addDisposableTo(disposeBag)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func alertShow(message: String) {
        let alert = UIAlertController(title: "Погода в Москве", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Спасибо!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
