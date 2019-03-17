//
//  HomeTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var imageButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mView.layer.cornerRadius = 05
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
