//
//  ViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 15/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

	@IBOutlet weak var pageControl: UIPageControl!
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
		bodyCarouselView.isPagingEnabled = true
		pageControl.numberOfPages = 10
		
	}

	func numberOfItems(in carousel: iCarousel) -> Int {
		return 10
	}
	
	func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
		pageControl.currentPage = bodyCarouselView.currentItemIndex
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
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

