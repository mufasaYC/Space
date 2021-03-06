//
//  XMLParser.swift
//  Sab Asha
//
//  Created by Mustafa Yusuf on 12/03/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import Foundation
import Firebase

var aadharDict = [String:String]()

class BarcodeData {
    var uid: String
    var name: String
    var gender: String
    var yob: String
    var co: String
    var house: String
    var street: String
    var lm: String
    var vtc: String
    var po: String
    var dist: String
    var subdist: String
    var state: String
    var pc: String
    var dob: String
    
    init?(dictionary: [String : String]) {
        guard let uid = dictionary["uid"],
            let name = dictionary["name"],
            let gender = dictionary["gender"],
            let yob = dictionary["yob"],
            let co = dictionary["co"],
            let house = dictionary["house"],
            let street = dictionary["street"],
            let lm = dictionary["lm"],
            let vtc = dictionary["vtc"],
            let po = dictionary["po"],
            let dist = dictionary["dist"],
            let subdist = dictionary["subdist"],
            let state = dictionary["state"],
            let pc = dictionary["pc"],
            let dob = dictionary["dob"] else {
                return nil
        }
        
        self.uid = uid
        self.name = name
        self.gender = gender
        self.yob = yob
        self.co = co
        self.house = house
        self.street = street
        self.lm = lm
        self.vtc = vtc
        self.po = po
        self.dist = dist
        self.subdist = subdist
        self.state = state
        self.pc = pc
        self.dob = dob
        
    }
}

class MyParser: NSObject {
    var parser: XMLParser
    
    var barcodes = [BarcodeData]()
    
    init(xml: String) {
        parser = XMLParser(data: xml.data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> [BarcodeData] {
        parser.parse()
        return barcodes
    }
    
}

extension MyParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let currentElement = elementName;
        print(currentElement)
        aadharDict = attributeDict
        userCred = attributeDict
		
		UserDefaults.standard.setValue(attributeDict["uid"]!, forKey: "UID")
		UserDefaults.standard.setValue(status, forKey: "status")
		
		
        FIRDatabase.database().reference().child("users").child(attributeDict["uid"]!).updateChildValues(attributeDict, withCompletionBlock: {err, res in
            print(res)
            print("\n\n\n\n")
        })
		
		FIRDatabase.database().reference().child("users").child(attributeDict["uid"]!).child("vaccine").observeSingleEvent(of: .value, with: {snapshot in
			if snapshot.exists() {
			} else {
				FIRDatabase.database().reference().child("users").child(attributeDict["uid"]!).child("vaccine").updateChildValues(status)
			}
		
		})
		
		FIRDatabase.database().reference().child("mapping").child(attributeDict["pc"]!).updateChildValues([attributeDict["uid"]!:true])
    }
}
