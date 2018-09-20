//
//  Category.swift
//  Todoey
//
//  Created by Ioan Oprea on 19/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object { 
    @objc dynamic var name =  ""
    let items = List<Item>()
}
