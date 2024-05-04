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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
