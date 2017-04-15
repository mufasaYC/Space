//
//  ViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 15/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iCarouselDelegate, iCarouselDataSource, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var bodyCarouselView: iCarousel!
	
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
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
		
		tableView.delegate = self
		tableView.dataSource = self
		
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.showTableView))
		swipeUp.direction = UISwipeGestureRecognizerDirection.up
		self.view.addGestureRecognizer(swipeUp)
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideTableView))
		swipeDown.direction = UISwipeGestureRecognizerDirection.down
		self.view.addGestureRecognizer(swipeDown)
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
		self.view.addGestureRecognizer(panGesture)
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

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = "HELLO WORLD"
		return cell
	}
//
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		
//		if scrollView.contentOffset.y <= 0{
//			//hideTableView()
//			bottomConstraint.constant = 0
//			UIView.animate(withDuration: 0.3, animations: {Void in
//				self.view.layoutIfNeeded()
//			})
//		}
//	}
	
		var prev_location = CGFloat()
	
		func panGesture(sender: UIPanGestureRecognizer){
			if sender.state == .began {
				print("began")
				prev_location = sender.location(in: view).y
				self.view.layoutIfNeeded()
			} else if sender.state == .ended {
				print("ended")
				prev_location = 0
				bottomConstraint.constant = bottomConstraint.constant + 52
				UIView.animate(withDuration: 0.5, animations: {void in
					self.view.layoutIfNeeded()
				})
			} else if sender.state == .changed {
				print("changed")
				bottomConstraint.constant = bottomConstraint.constant + 1.2*(prev_location - sender.location(in: view).y)
				prev_location = sender.location(in: view).y
				self.view.layoutIfNeeded()
			}
		}

	
	func showTableView() {
		print("show table")
		let height = bodyCarouselView.bounds.height
		let tableHeight = height - 115
		bottomConstraint.constant += tableHeight
		UIView.animate(withDuration: 0.25, animations: {Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func hideTableView() {
		print("hide table")
		bottomConstraint.constant = 0
		UIView.animate(withDuration: 0.25, animations: {Void in
			self.view.layoutIfNeeded()
		})
	}

}

