//
//  LoginViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
   
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setupConstraint()
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginViewModel.getEmailPass()
    }
    
    func setupConstraint(){
        titleTopConstraint.constant = view.bounds.height / 6
        signupBottomConstraint.constant = view.bounds.height / 8
    }

    @IBAction func signInAction(_ sender: Any) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
            
            var isAnyFieldEmpty : Bool = false
            if trimmedEmail.isEmpty {
                emailErrorLabel.text = "email field can't be empty"
                emailErrorLabel.isHidden = false
                isAnyFieldEmpty = true
            }
            if password.isEmpty {
                passwordErrorLabel.text = "password can't be empty"
                passwordErrorLabel.isHidden = false
                isAnyFieldEmpty = true
            }
            if isAnyFieldEmpty {return}
            
            if let info = loginViewModel.emailPass {
                if trimmedEmail != info.email || password != info.password {
                    openAlert(title: "Alert", message: "Email or password isn't correct!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in

                   }])
                }else {
                    gotoPeoplePage()
                }
            }else {
                openAlert(title: "Alert", message: "Please signup first", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in

               }])
            }
        }
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gotoPeoplePage(){
        let vc = PeopleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField : emailErrorLabel.isHidden = true
        case passwordTextField : passwordErrorLabel.isHidden = true
        default : break
        }
    }
}
