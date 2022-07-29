//
//  MLModelCell.swift
//  Backbone Runtime
//
//  Created by Anton Kovalenko on 27.07.2022.
//

import UIKit

class MLModelCell: UITableViewCell {
    
    @IBOutlet private weak var mlModelNameLabel: UILabel!
    
    func configure(mlModelName: String) {
        mlModelNameLabel.text = mlModelName
    }
}
