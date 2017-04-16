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
		//bodyCarouselView.clipsToBounds = true
		
		pageControl.numberOfPages = age.count
		
		tableView.delegate = self
		tableView.dataSource = self
		
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.showTableView))
		swipeUp.direction = UISwipeGestureRecognizerDirection.up
		self.view.addGestureRecognizer(swipeUp)
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideTableView))
		swipeDown.direction = UISwipeGestureRecognizerDirection.down
		self.view.addGestureRecognizer(swipeDown)
		
//		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
//		self.view.addGestureRecognizer(panGesture)
	}
	
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return age.count
	}
	
	func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
		pageControl.currentPage = bodyCarouselView.currentItemIndex
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		
		var itemView: CustomView
		if (view == nil) {
			itemView = CustomView(frame: CGRect(x:0, y:0, width: bodyCarouselView.bounds.width, height: bodyCarouselView.bounds.height))
			itemView.backgroundImage.image = UIImage(named: age[index])
			//itemView.backgroundColor = UIColor.darkGray
			itemView.dateLabel.text = ""
			for i in vaccines[index][age[index]]! {
				itemView.dateLabel.text = itemView.dateLabel.text! + "\n\(i)"
			}
			itemView.titleLabel.text = age[index]
		} else {
			itemView = view! as! CustomView
			itemView.backgroundImage.image = UIImage(named: age[index])
			itemView.dateLabel.text = ""
			for i in vaccines[index][age[index]]! {
				itemView.dateLabel.text = itemView.dateLabel.text! + "\n\(i)"
			}
			itemView.titleLabel.text = age[index]
		}
		return itemView
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return (vaccines[bodyCarouselView.currentItemIndex][age[bodyCarouselView.currentItemIndex]]?.count)!+1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section != tableView.numberOfSections-1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell_why", for: indexPath) as! WhyCell
			cell.whyLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HospitalCell
		cell.intialLabel.text = "\(hospitals[indexPath.row].characters.first!)"
		cell.hospitalNameLabel.text = hospitals[indexPath.row]
		cell.addressNameLabel.text = address[indexPath.row]
		return cell
	}
	
	func showTableView() {
		print("show table")
		let height = bodyCarouselView.bounds.height
		let tableHeight = height - 115
		bottomConstraint.constant += tableHeight
		UIView.animate(withDuration: 0.25, animations: {Void in
			
		})
		
		UIView.animate(withDuration: 0.25, animations: {void in
			self.view.layoutIfNeeded()
		}, completion: {void in
		})
	}
	
	func hideTableView() {
		print("hide table")
		bottomConstraint.constant = 0
		UIView.animate(withDuration: 0.25, animations: {Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == tableView.numberOfSections-1 {
			return "Nearest Dispensary"
		} else {
			return "Why " + (vaccines[bodyCarouselView.currentItemIndex][age[bodyCarouselView.currentItemIndex]]?[section])! + "?"
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		if section != tableView.numberOfSections-1 {
			header.textLabel?.textColor = UIColor(red: 49.0/255.0, green: 174.0/255.0, blue: 254.0/255.0, alpha: 1.0)
			header.textLabel?.font = UIFont(name: "SF-UI-Display-Regular", size: 18)
			header.textLabel?.frame = header.frame
			header.contentView.backgroundColor = UIColor.white
			return
		}
		header.textLabel?.textColor = UIColor.white
		header.textLabel?.font = UIFont(name: "SF-UI-Display-Regular", size: 18)
		header.textLabel?.frame = header.frame
		header.contentView.backgroundColor = UIColor(red: 49.0/255.0, green: 174.0/255.0, blue: 254.0/255.0, alpha: 1.0)
	}
	
	func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
		if bottomConstraint.constant != 0 {
			return
		}
		bottomConstraint.constant = 72
		UIView.animate(withDuration: 0.175, animations: {void in
			self.view.layoutIfNeeded()
		}, completion: {void in
			self.bottomConstraint.constant = 0
			UIView.animate(withDuration: 0.175, animations: {void in
				self.view.layoutIfNeeded()
			})
		})
	}
	
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView.contentOffset.y <= -21{
			//hideTableView()
			bottomConstraint.constant = 0
			UIView.animate(withDuration: 0.3, animations: {Void in
				self.view.layoutIfNeeded()
			})
		}
	}
	
	//		var prev_location = CGFloat()
	//
	//		func panGesture(sender: UIPanGestureRecognizer){
	//			if sender.state == .began {
	//				print("began")
	//				prev_location = sender.location(in: view).y
	//				self.view.layoutIfNeeded()
	//			} else if sender.state == .ended {
	//				print("ended")
	//				prev_location = 0
	//				bottomConstraint.constant = bottomConstraint.constant + 52
	//				UIView.animate(withDuration: 0.5, animations: {void in
	//					self.view.layoutIfNeeded()
	//				})
	//			} else if sender.state == .changed {
	//				print("changed")
	//				bottomConstraint.constant = bottomConstraint.constant + 1.2*(prev_location - sender.location(in: view).y)
	//				prev_location = sender.location(in: view).y
	//				self.view.layoutIfNeeded()
	//			}
	//		}

}

