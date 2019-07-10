//
//  Data+Extensions.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import Foundation

extension Data {
    
    var hexString: String {
        return reduce("", { $0 + String(format: "%02x", $1) })
    }
    
    var decimalString: String {
        return "\(Int(hexString, radix: 16) ?? 0)"
    }
    
}
