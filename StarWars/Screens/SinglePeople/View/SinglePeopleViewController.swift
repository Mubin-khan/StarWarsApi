//
//  SinglePeopleViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/29/24.
//

import UIKit

class SinglePeopleViewController: UIViewController {
    
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var classification: UILabel!
    @IBOutlet weak var speciesName: UILabel!
    @IBOutlet weak var speciesCountLabel: UILabel!
    @IBOutlet weak var climate: UILabel!
    @IBOutlet weak var diameter: UILabel!
    @IBOutlet weak var planetName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var skinColorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func crossAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
