//
//  Array+Ext.swift
//  Backbone Runtime
//
//  Created by Anton Kovalenko on 28.07.2022.
//

import Foundation

extension Array where Element: BinaryFloatingPoint {
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }
}
