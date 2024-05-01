//
//  SinglePeopleViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/29/24.
//

import UIKit

class SinglePeopleViewController: UIViewController, SinglePeopleViewModelProtocol {
    
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
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
    
    let info : PeopleResult
    let viewModel = SinglePeopleViewModel()
    
    init(info : PeopleResult){
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loaderIndicator.startAnimating()
        viewModel.delegate = self
        if NetWorkManager.shared.isNetworkReachable() {
            viewModel.fetchPeopleInfo(with: info)
        }else {
            loaderIndicator.stopAnimating()
            openAlert(title: "Error", message: "Check your network connection and try again!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
                
            }])
        }
    }
    
    func writeDatas() {
        loaderIndicator.stopAnimating()
        
        nameLabel.text = "Name : \(viewModel.peopleInfo?.name.capitalized ?? "")"
        genderLabel.text = "Gender : \(viewModel.peopleInfo?.gender.capitalized ?? "")"
        dobLabel.text = "D.O.B : \(viewModel.peopleInfo?.dob.capitalized ?? "")"
        massLabel.text = "Mass : \(viewModel.peopleInfo?.mass.capitalized ?? "")"
        heightLabel.text = "Height : \(viewModel.peopleInfo?.height.capitalized ?? "")"
        skinColorLabel.text = "Skin Color : \(viewModel.peopleInfo?.skinColor.capitalized ?? "")"
        planetName.text = "Name : \(viewModel.peopleInfo?.panetInfo?.name.capitalized ?? "")"
        diameter.text = "Diameter : \(viewModel.peopleInfo?.panetInfo?.diameter.capitalized ?? "")"
        climate.text = "Climate : \(viewModel.peopleInfo?.panetInfo?.climate.capitalized ?? "")"
        speciesCountLabel.text = "Number of Species : \(viewModel.peopleInfo?.speciesInfo.count ?? 0)"
        
        if let firstSpecies = viewModel.peopleInfo?.speciesInfo.first {
            speciesName.text = "Name : \(firstSpecies.name.capitalized)"
            classification.text = "Classification : \(firstSpecies.classification.capitalized)"
            designation.text = "Designation : \(firstSpecies.designation.capitalized)"
        }
    }
    
    func showError(err: DataError) {
        switch err {
        case .invalidResponse :  openAlert(title: "Error", message: "Server Error plese try again later!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
            
        }])
        case .invalidUrl : openAlert(title: "Error", message: "Server Error plese try again later!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
            
        }])
        default : openAlert(title: "Error", message: "Server Error plese try again later!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
            
        }])
        }
    }
    
    @IBAction func crossAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
