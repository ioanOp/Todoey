//
//  File.swift
//  Todoey
//
//  Created by Ioan Oprea on 08/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import Foundation

class ToDoItem: Codable {
    var title = ""
    var done = false
    
    init(title: String, done: Bool = false){
        self.title = title
        self.done = done
    }
    
    
}
