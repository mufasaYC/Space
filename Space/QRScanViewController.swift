//
//  QRScanViewController.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class QRScanViewController: UIViewController, XMLParserDelegate, QRCodeReaderViewControllerDelegate {
	
	
	
	
	var flagLeftOpen = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scanAction(self)
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
		$0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
		$0.showTorchButton = true
	})
	
	@IBAction func scanAction(_ sender: AnyObject) {
		do {
			if try QRCodeReader.supportsMetadataObjectTypes() {
				reader.modalPresentationStyle = .formSheet
				reader.delegate               = self
				
				reader.completionBlock = { (result: QRCodeReaderResult?) in
					
					if let result = result {
						print("Completion with result: \(result.value) of type \(result.metadataType)")
						
						let parser = MyParser(xml: result.value)
						_ = parser.parseXML()
						self.fetchData()
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
	
	// MARK: - QRCodeReader Delegate Methods
	
	func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
		
		reader.stopScanning()
		dismiss(animated: true, completion: nil)
		
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
	
	
	func fetchData() {
		
		FIRDatabase.database().reference().child("aadhars").child(userCred["uid"]!).child("child").observe(.value, with: {snapshot in
			
			let x = snapshot.children.allObjects as! [FIRDataSnapshot]
			
			for i in x {
				if i.key == "Vaccines" {
					print(i.value as! NSDictionary)
					vaccine = i.value as! NSDictionary
				} else if i.key == "dob" {
					dob = i.value as! String
				} else if i.key == "name" {
					childName = i.value as! String
				}
			}
			
		})
		
	}
	


}
