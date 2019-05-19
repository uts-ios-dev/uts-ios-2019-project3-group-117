//
//  File.swift
//  what-to-do
//
//  Created by 孟繁星 on 19/5/19.
//  Copyright © 2019 YiGu. All rights reserved.
//

import Foundation


class WishToDoItem: NSObject {
    var id: String
    var title: String
    var date: Date
    init(id: String, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
}
