//
//  Item+CoreDataProperties.swift
//  TooDoo
//
//  Created by Henrik Anthony Odden Sandberg on 17.01.2018.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var title: String?

}
