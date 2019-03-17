//
//  DrawerProfileTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 02/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class DrawerProfileTableViewCell: UITableViewCell {

    @IBOutlet var mProfilePhotoImageView: UIImageView!
    @IBOutlet var mUserEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
