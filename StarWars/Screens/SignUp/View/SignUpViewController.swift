//
//  SignUpViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/25/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emaileTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var parentNameTextField: UITextField!
    @IBOutlet weak var parentNameLabel: UILabel!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var parentNameErrorLabel: UILabel!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        hideAllErrorLabel()
        nameTextField.delegate = self
        emaileTextField.delegate = self
        parentNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func hideAllErrorLabel(){
        nameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        phoneNumberErrorLabel.isHidden = true
        parentNameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
    }

    @IBAction func maleAction(_ sender: UIButton) {
        maleButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        if parentNameLabel.text != "Father's Name" {
            parentNameLabel.text = "Father's Name"
            parentNameTextField.text = ""
        }
    }
    
    @IBAction func femaleAction(_ sender: UIButton) {
        maleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        
        if parentNameLabel.text != "Mother's Name" {
            parentNameLabel.text = "Mother's Name"
            parentNameTextField.text = ""
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        nameTextField.endEditing(true)
        emaileTextField.endEditing(true)
        parentNameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        confirmPasswordTextField.endEditing(true)
        
        var dataModel : SignUpModel = SignUpModel(name: "", email: "", phoneNumber: "", parentName: "Male", gender: "", password: "")
        var curPass : String = ""
        
        var isAnyErrorOccured : Bool = false
        if let name = nameTextField.text {
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            dataModel.name = trimmedName
            if trimmedName.isEmpty {
                nameErrorLabel.text = "Name can't be empty"
                nameErrorLabel.isHidden = false
                isAnyErrorOccured = true
            }
        }
        
        if let name = parentNameTextField.text {
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            dataModel.parentName = trimmedName
            if trimmedName.isEmpty {
                var parent = "Father's"
                if parentNameLabel.text != "Father's Name" {
                    parent = "Mother's"
                    dataModel.gender = "Female"
                }
                parentNameErrorLabel.text = "\(parent) name can't be empty"
                parentNameErrorLabel.isHidden = false
                isAnyErrorOccured = true
            }
        }
        
        if let email = emaileTextField.text {
            let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
            dataModel.email = trimmedEmail
            if !trimmedEmail.validateEmail() {
                emailErrorLabel.text = "Please enter valid email"
                emailErrorLabel.isHidden = false
                isAnyErrorOccured = true
            }
        }
        
        if let password = passwordTextField.text {
            curPass = password
            dataModel.password = password
            if !password.validatePassword() {
                passwordErrorLabel.text = "pass should be at least 6 character long"
                passwordErrorLabel.isHidden = false
                isAnyErrorOccured = true
            }
        }
        
        if let confirmPass = confirmPasswordTextField.text, let pass = passwordTextField.text {
            if pass != confirmPass {
                confirmPasswordErrorLabel.text = "password doesn't matched"
                confirmPasswordErrorLabel.isHidden = false
                isAnyErrorOccured = true
            }
        }
        dataModel.phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        // save info to coredata and back to login page
        if isAnyErrorOccured {return}
        let result = SignupCD.saveSignupInfo(infos: dataModel)
        switch result {
        case .success(_) : 
//            let keyChain = KeychainService()
//            keyChain.save(key: dataModel.email, value: curPass)
            let keychain = KeyChainService()
            let isSaved = keychain.saveStringToKeychain(curPass, forKey: dataModel.email)
            if isSaved {
                openAlert(title: "Success", message: "You are succesfully registered", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }])
            }else {
                // delete data from core data
                openAlert(title: "Error", message: "Sorry try again!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
                   
                }])
            }
            
        case .failure(_) : openAlert(title: "Error", message: "Sorry signup failed. try again!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
             
        }])
        }
    }
    
    @IBAction func gotoSignInpageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField : nameErrorLabel.isHidden = true
        case emaileTextField : emailErrorLabel.isHidden = true
        case parentNameTextField : parentNameErrorLabel.isHidden = true
        case passwordTextField : passwordErrorLabel.isHidden = true
        case confirmPasswordTextField : confirmPasswordErrorLabel.isHidden = true
        default : break
        }
    }
}
