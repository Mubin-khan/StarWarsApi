//
//  LoginViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signupBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setupConstraint()
    }
    
    func setupConstraint(){
        titleTopConstraint.constant = view.bounds.height / 6
        signupBottomConstraint.constant = view.bounds.height / 8
    }

    @IBAction func signInAction(_ sender: Any) {
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
