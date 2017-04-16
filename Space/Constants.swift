//
//  Constants.swift
//  Space
//
//  Created by Mustafa Yusuf on 16/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import Foundation

let vaccines = [["Birth" : ["BCG","Oral Polio","Hepatitis B"]],["4 Weeks" : ["Oral Polio - 2","Hepatitis B - 2"]], ["8 Weeks" : ["Oral Polio - 3", "DPT - 1","HIB - 1"]],["12 Weeks" : ["Oral Polio - 4","DPT - 2","HIB - 2"]], ["16 Weeks" : ["Oral Polio - 5","DPT - 3","HIB - 3"]],["6 Months" : ["Hepatitis B - 3"]],["8-9 Months" : ["Measles Vaccine"]], ["1 Year" : ["Chicken Pox"]], ["1 year 3 months" : ["MMR"]],["1 year 6 months": ["Oral Polio - 1 Booster","DPT - 1 Booster","HIB - Booster","Hepatitis A - 1"]],["2 years" : ["Hepatitis A - 2","Typhoid Vaccine"]], ["4 years" : ["Oral Polio - 2 Booster","DPT - 2  Booster"]],["5 years" : ["Hepatitis B - 1 Booster","Typhoid vaccine"]], ["8 years" : ["Typhoid vaccine","Tetanus"]], ["10 years" : ["Hepatitis B - 2 Booster","Rubella vaccine(girls)"]],["11 years":["Typhoid vaccine","Tetanus Booster"]], ["14 years": ["Typhoid vaccine","Tetanus"]],["17 years" : ["Typhoid vaccine"]]]

let age = ["Birth","4 Weeks","8 Weeks","12 Weeks","16 Weeks","6 Months","8-9 Months","1 Year","1 year 3 months","1 year 6 months","2 years","4 years","5 years","8 years","10 years","11 years","14 years", "17 years"]

let hospitals = ["CMC - Christian Medical College"]
let address = ["IDA Scudder Rd, Vellore, Tamil Nadu 632004"]

let doctors = ["Display your doctor license!","Welcome Dr., Scan patient's Aadhaar.","Okay!","Patient is -NAME-"]
let users = ["I am a user!","Scan your Aadhaar.","Okay!","Welcome -NAME- to Health Square."]
let ngo = ["Kindly provide us with the QRCode sent to you'll and we shall verify you.","Displaying data to help you analyse and take appropriate measures."]

var vaccine = NSDictionary()
var dob = String()
var childName = String()
var userCred = [String:String]()
