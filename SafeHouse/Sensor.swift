//
//  Sensor.swift
//  SafeHouse
//
//  Created by Ryan Voong on 11/15/15.
//  Copyright © 2015 Team SafeHouse. All rights reserved.
//

import Foundation

class Sensor: NSObject {
    var ID: String
    var type: String
    var status: Int
    
    init(ID: String, type: String, status: Int) {
        self.ID = ID
        self.type = type
        self.status = status
    }
}
