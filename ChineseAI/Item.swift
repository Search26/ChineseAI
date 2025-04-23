//
//  Item.swift
//  ChineseAI
//
//  Created by Nguyễn Tiến Mai on 23/4/25.
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
