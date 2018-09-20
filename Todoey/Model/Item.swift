//
//  Item.swift
//  Todoey
//
//  Created by Ioan Oprea on 19/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
