//
//  Item.swift
//  F-UP
//
//  Created by 박현수 on 5/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
