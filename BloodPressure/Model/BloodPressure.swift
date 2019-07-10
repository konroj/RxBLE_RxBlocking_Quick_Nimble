//
//  BloodPressure.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import Foundation

struct BloodPressure {
    
    let value: Data
    let date: Date
    
}

extension BloodPressure {
    
    init(model: BloodPressureEntity) {
        value = model.value! // non-optional value in xcdatamodeld
        date = model.date! // non-optional value in xcdatamodeld
    }
    
}
