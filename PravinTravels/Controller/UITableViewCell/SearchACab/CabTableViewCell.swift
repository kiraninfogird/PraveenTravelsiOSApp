//
//  CabTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 01/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class CabTableViewCell: UITableViewCell {

    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var carDetailsLabel: UILabel!
    @IBOutlet var advanceAmtLabel: UILabel!
    @IBOutlet var perKmLabel: UILabel!
    @IBOutlet var totalAmtLabel: UILabel!
    @IBOutlet var bookCabButton: UIButton!
    @IBOutlet var fareDetailsButton: UIButton!
    //
    @IBOutlet var advanceStaticLabel: UILabel!
    @IBOutlet var perKmStaticLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
