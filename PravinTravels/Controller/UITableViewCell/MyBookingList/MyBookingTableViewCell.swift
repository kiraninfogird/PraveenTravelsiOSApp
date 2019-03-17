//
//  MyBookingTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class MyBookingTableViewCell: UITableViewCell {

    @IBOutlet var vehicleNameLabel: UILabel!
    @IBOutlet var crnNoLabel: UILabel!
    @IBOutlet var pickupCityLabel: UILabel!
    @IBOutlet var travelDate: UILabel!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var sideColorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
