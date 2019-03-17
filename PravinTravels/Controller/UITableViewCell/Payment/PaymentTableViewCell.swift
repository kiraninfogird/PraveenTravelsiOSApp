
//
//  PaymentTableViewCell.swift
//  PravinTravels
//
//  Created by IIPL 5 on 03/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var payAmountButton: UIButton!
    @IBOutlet var basicAmtLabel: UILabel!
    @IBOutlet var serviceTaxLabel: UILabel!
    @IBOutlet var totalAmtLabel: UILabel!
    @IBOutlet var advAmtLabel: UILabel!
    @IBOutlet var balAmountLabel: UILabel!
    
    @IBOutlet var couponCodeTextField: UITextField!
    @IBOutlet var applyCodeButton: UIButton!
    @IBOutlet var couponCodeSucessMsgLabel: UILabel!
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var mobileTF: UITextField!
    @IBOutlet var addressTF: UITextField!
    
    @IBOutlet var creditDebitButton: UIButton!
    @IBOutlet var walletButton: UIButton!
    
    @IBOutlet var creditCardImageView: UIImageView!
    @IBOutlet var walletImageView: UIImageView!
    
    @IBOutlet var couponView: UIView!
    @IBOutlet var couponViewLabel: UILabel!
    @IBOutlet var couponViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
