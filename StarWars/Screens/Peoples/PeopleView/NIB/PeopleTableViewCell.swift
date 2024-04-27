//
//  PeopleTableViewCell.swift
//  StarWars
//
//  Created by Mubin Khan on 4/27/24.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(data : PeopleResult?) {
        guard let data = data else {return}
        nameLabel.text = data.name.capitalized
        birthYearLabel.text = data.birthYear.capitalized
        genderLabel.text = data.gender.capitalized
    }
    
}
