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
        guard let loginInfo = SignupCD.getLoginInfo() else {return}
        emailPass = loginInfo
    }
}
