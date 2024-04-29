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
       let keychain = KeychainService()
       let password = "123456" //keychain.load(key: email)
       emailPass = LoginModel(email: email, password: password)
    }
}
