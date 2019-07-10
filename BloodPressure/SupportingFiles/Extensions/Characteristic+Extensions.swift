//
//  Characteristic+Extensions.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import Foundation
import RxBluetoothKit
import CoreBluetooth

extension Characteristic {
    
    func determineWriteType() -> CBCharacteristicWriteType? {
        let writeType = self.properties.contains(.write) ? CBCharacteristicWriteType.withResponse :
            self.properties.contains(.writeWithoutResponse) ? CBCharacteristicWriteType.withoutResponse : nil
        
        return writeType
    }
    
}

