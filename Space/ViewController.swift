//
//  ViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 15/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

	@IBOutlet weak var bodyCarouselView: iCarousel!
	@IBOutlet weak var headerCarouselView: iCarousel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		bodyCarouselView.delegate = self
		bodyCarouselView.dataSource = self
		bodyCarouselView.type = .linear
		bodyCarouselView.reloadData()
		bodyCarouselView.bounces = false
		bodyCarouselView.scrollSpeed = 0.7
		
		headerCarouselView.delegate = self
		headerCarouselView.dataSource = self
		headerCarouselView.type = .linear
		headerCarouselView.reloadData()
		headerCarouselView.bounces = false
		
	}

	func numberOfItems(in carousel: iCarousel) -> Int {
		return 10
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
		if carousel == headerCarouselView {
			var itemView: UITextView
			if (view == nil) {
				itemView = UITextView(frame: CGRect(x:0, y:0, width: headerCarouselView.bounds.width, height: headerCarouselView.bounds.height))
				itemView.text = "Cardio"
			} else {
				itemView = view! as! UITextView
				itemView.text = "Cardio"
			}
			itemView.font = UIFont(name: "SF-UI-Display-Regular", size: 21)
			itemView.isEditable = false
			itemView.isSelectable = false
			return itemView
		}
		
		
		var itemView: CustomView
		if (view == nil) {
			itemView = CustomView(frame: CGRect(x:0, y:0, width: bodyCarouselView.bounds.width, height: bodyCarouselView.bounds.height))
			itemView.backgroundImage.image = UIImage(named: "Runner")
			//itemView.backgroundColor = UIColor.darkGray
			itemView.titleLabel.text = "Pop & Jump"
			itemView.dateLabel.text = "13 mins"
		} else {
			itemView = view! as! CustomView
			itemView.backgroundImage.image = UIImage(named: "Runner")
			itemView.titleLabel.text = "Pop & Jump"
			itemView.dateLabel.text = "13 mins"
		}
		return itemView

	}


}

