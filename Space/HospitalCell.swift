//
//  HospitalCell.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class HospitalCell: UITableViewCell {

	@IBOutlet weak var addressNameLabel: UILabel!
	@IBOutlet weak var hospitalNameLabel: UILabel!
	@IBOutlet weak var intialLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		intialLabel.layer.cornerRadius = 22
		intialLabel.clipsToBounds = true
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
