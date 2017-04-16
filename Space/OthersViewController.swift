//
//  OthersViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

class OthersViewController: UIViewController {

	@IBOutlet var pincodeLabel: [UILabel]!
	@IBOutlet var heightConstraint: [NSLayoutConstraint]!
	
	var heights = [2,2,2,2,2,2,2,2,2]
	var maximum = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		fetchData()
		for i in pincodeLabel {
			i.text = ""
		}
    }

	func fetchData() {
		FIRDatabase.database().reference().child("mapping").observe(.value, with: {snapshot in
		
			let snaps = snapshot.children.allObjects as! [FIRDataSnapshot]
			var count = 0
			for i in snaps {
				if self.maximum <= Int(i.childrenCount) {
					self.maximum = Int(i.childrenCount)
				}
				self.heights[count] = Int(i.childrenCount)
				self.pincodeLabel[count].text = i.key
				count += 1
				if count == 9 {
					self.graph()
					break
				}
				if i == snaps.last {
					self.graph()
				}
			}
		})
	}

	func graph() {
		var count = 0
		for i in heights {
			heightConstraint[count].constant = CGFloat(350*(Double(i)/Double(maximum)))
			UIView.animate(withDuration: 0.5, animations: {void in
				self.view.layoutIfNeeded()
			})
			count+=1
		}
	}
	
}
