//
//  SplashViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
//            let vc = LoginViewController()
            let vc = PeopleViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
