//
//  LoginViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QRCodeReaderViewControllerDelegate, XMLParserDelegate {

	@IBOutlet weak var usersBtn: UIButton!
	@IBOutlet weak var othersBtn: UIButton!
	@IBOutlet weak var doctorBtn: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	var count = 1
	var chatArray = ["Hello World. Who are you?"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row%2 == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "bot", for: indexPath) as! ChatCell
			cell.chatBubble.text = chatArray[indexPath.row]
			if (cell.chatBubble.text?.contains("-NAME-"))! {
				cell.chatBubble.text = cell.chatBubble.text?.replacingOccurrences(of: "-NAME-", with: userCred["name"]!)
			}
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! ChatCell
		cell.chatBubble.text = chatArray[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let frame = cell.frame
		cell.frame = CGRect(x: 0, y: self.tableView.frame.height, width: frame.width, height: frame.height)
		UIView.animate(withDuration: 0.7, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
			cell.frame = frame
		}, completion: nil)
	}
	
	@IBAction func doctor(_ sender: Any) {
		usersBtn.isHidden = true
		othersBtn.isHidden = true
		if count == 3 {
			let btn = sender as! UIButton
			btn.setTitle("Scan Aadhaar", for: .selected)
			btn.setTitle("Scan Aadhaar", for: .normal)
		}
		if count == 4 {
			scanAdhaar()
		}
		if count == 1 {
			chatArray.append(contentsOf: doctors)
		}
		tableView.beginUpdates()
		let indexPath:IndexPath = IndexPath(row:(self.count), section:0)
		count+=1
		tableView.insertRows(at: [indexPath], with: .left)
		tableView.endUpdates()
		tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		
	}
	@IBAction func user(_ sender: Any) {
		
		doctorBtn.isHidden = true
		othersBtn.isHidden = true
		
		chatArray.append(contentsOf: users)
		if count == 1 {
			chatArray.append("I am a user")
			tableView.beginUpdates()
			let indexPath:IndexPath = IndexPath(row:(self.count), section:0)
			count+=1
			tableView.insertRows(at: [indexPath], with: .left)
			tableView.endUpdates()
			tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
				let indexPath:IndexPath = IndexPath(row:(self.count), section:0)
				self.count+=1
				self.tableView.insertRows(at: [indexPath], with: .left)
				self.tableView.endUpdates()
				self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
			})
			let btn = sender as! UIButton
			btn.setTitle("Scan Aadhaar", for: .selected)
			btn.setTitle("Scan Aadhaar", for: .normal)
			return
		}
		if count != 4 {
			tableView.beginUpdates()
			let indexPath:IndexPath = IndexPath(row:(self.count), section:0)
			count+=1
			tableView.insertRows(at: [indexPath], with: .left)
			tableView.endUpdates()
			tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
			let btn = sender as! UIButton
			btn.setTitle("", for: .selected)
			btn.setTitle("", for: .normal)
			btn.isHidden = true
		}
		if count == 4 {
			
			scanAdhaar()
		}

	}
	@IBAction func ngo(_ sender: Any) {
		
	}
	
	lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
		$0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
		$0.showTorchButton = true
	})
	
	// MARK: - QRCodeReader Delegate Methods
	
	func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
		
		reader.stopScanning()
		dismiss(animated: true, completion: nil)
		tableView.beginUpdates()
		let indexPath:IndexPath = IndexPath(row:(self.count), section:0)
		count+=1
		tableView.insertRows(at: [indexPath], with: .left)
		tableView.endUpdates()
		tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
			print("PERFORM SEGUE")
			self.performSegue(withIdentifier: "show", sender: self)
			//self.scanAdhaar()
		})
	}
	
	func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
		if let cameraName = newCaptureDevice.device.localizedName {
			print("Switching capturing to: \(cameraName)")
		}
	}
	
	func readerDidCancel(_ reader: QRCodeReaderViewController) {
		reader.stopScanning()
		dismiss(animated: true, completion: nil)
	}
	
	func scanAdhaar() {
		do {
			if try QRCodeReader.supportsMetadataObjectTypes() {
				reader.modalPresentationStyle = .formSheet
				reader.delegate               = self
				
				reader.completionBlock = { (result: QRCodeReaderResult?) in
					
					if let result = result {
						print("Completion with result: \(result.value) of type \(result.metadataType)")
						
						let parser = MyParser(xml: result.value)
						_ = parser.parseXML()
						//self.createMenuView()
						
					}
				}
				
				present(reader, animated: true, completion: nil)
			}
		} catch let error as NSError {
			switch error.code {
			case -11852:
				let alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
					DispatchQueue.main.async {
						if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
							UIApplication.shared.openURL(settingsURL)
						}
					}
				}))
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				present(alert, animated: true, completion: nil)
				
				
				
			case -11814:
				let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				
				present(alert, animated: true, completion: nil)
			default:()
			}
		}
	}
	
}
