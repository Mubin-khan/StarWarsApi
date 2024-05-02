//
//  LoginViewModel.swift
//  StarWars
//
//  Created by DSDEVMAC2 on 4/29/24.
//

import Foundation

class LoginViewModel {
    var emailPass : LoginModel?
    
    init() {
        getEmailPass()
    }
    
    func getEmailPass() {
       let email = SignupCD.getLoginMail()
       if email.isEmpty {return}
       let keychain = KeyChainService()
        if let password = keychain.getStringFromKeychain(forKey: email) {
            emailPass = LoginModel(email: email, password: password)
        }
    }
}
