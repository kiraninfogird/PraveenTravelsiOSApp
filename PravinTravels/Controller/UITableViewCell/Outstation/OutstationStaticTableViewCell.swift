//
//  OutstationStaticTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 08/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class OutstationStaticTableViewCell: UITableViewCell {

    @IBOutlet var mView: UIView!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
