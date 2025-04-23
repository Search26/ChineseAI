//
//  Item.swift
//  ChineseAI
//
//  Created by Nguyễn Tiến Mai on 23/4/25.
//

import Foundation
import CoreData

@objc(Item)
final class Item: NSManagedObject, Identifiable {
    @NSManaged public var timestamp: Date?
}

extension Item {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        NSFetchRequest<Item>(entityName: "Item")
    }
}
