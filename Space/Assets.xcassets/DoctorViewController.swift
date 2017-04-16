//
//  DoctorViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

class DoctorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		nameLabel.text = userCred["name"]!
		tableView.delegate = self
		tableView.dataSource = self
		
		fetchData()
    }

	func fetchData() {
	FIRDatabase.database().reference().child("users").child(userCred["uid"]!).child("vaccine").observeSingleEvent(of: .value, with: {snapshot in
		
			let x = snapshot.children.allObjects as! [FIRDataSnapshot]
			for i in x {
				status[i.key] = i.value as! Bool
				if i == x.last {
					self.tableView.reloadData()
				}
			}
		})
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
		for i in status {
			if i.key == cell.vaccineLabel.text! {
				cell.isUserInteractionEnabled = !i.value
				if i.value == true {
					cell.accessoryType = .checkmark
				} else {
					cell.accessoryType = .none
				}
			}
		}
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! VaccineCell
		displayAlert(title: cell.vaccineLabel.text!, message: "Confirmation Alert!", indexPath: indexPath)
	}
	
	func displayAlert(title : String, message : String, indexPath: IndexPath) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: {void in
			let cell = self.tableView.cellForRow(at: indexPath) as! VaccineCell
			cell.accessoryType = .checkmark
			FIRDatabase.database().reference().child("users").child(userCred["uid"]!).child("vaccine").updateChildValues([cell.vaccineLabel.text!:true])
			cell.isUserInteractionEnabled = false
			status[cell.vaccineLabel.text!] = true
		})
	}
	
}
