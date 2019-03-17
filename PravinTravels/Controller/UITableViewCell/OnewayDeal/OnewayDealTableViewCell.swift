//
//  OnewayDealTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 03/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class OnewayDealTableViewCell: UITableViewCell {

    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var carDetailsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bookDealButton: UIButton!
    @IBOutlet var cutAmountLabel: UILabel!
    @IBOutlet var totalAmountButton: UIButton!
    @IBOutlet var disPercentLabel: UILabel!
    @IBOutlet var dashLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
