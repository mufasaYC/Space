//
//  DoctorViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class DoctorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		nameLabel.text = userCred["name"]!
		tableView.delegate = self
		tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return vaccines.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (vaccines[section][age[section]]?.count)!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VaccineCell
		cell.vaccineLabel.text = vaccines[indexPath.section][age[indexPath.section]]?[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return age[section]
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		header.textLabel?.textColor = UIColor(red: 255.0/255.0, green: 26.0/255.0, blue: 70.0/255.0, alpha: 1.0)
		header.textLabel?.font = UIFont(name: "SF-UI-Display-Regular", size: 18)
		header.textLabel?.frame = header.frame
		header.contentView.backgroundColor = UIColor.white
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
	
}
