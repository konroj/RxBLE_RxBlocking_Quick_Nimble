//
//  BloodPressureListTableViewCell.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import UIKit

class BloodPressureListTableViewCell: UITableViewCell {
    static let identifier = NSStringFromClass(BloodPressureListTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: BloodPressure) {
        textLabel?.text = "Value: \(model.value.decimalString) (\(model.value.hexString))"
        detailTextLabel?.text = model.date.fullDate
    }
    
}
