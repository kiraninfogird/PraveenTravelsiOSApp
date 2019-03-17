//
//  MulticityTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 08/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class MulticityTableViewCell: UITableViewCell {

    @IBOutlet var destinationCityTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
