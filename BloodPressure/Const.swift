//
//  Const.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Const {
    
    struct CBUUIDs {
        static let service = CBUUID(string: "1810")
        static let characteristic = CBUUID(string: "2A49")
    }
    
}
