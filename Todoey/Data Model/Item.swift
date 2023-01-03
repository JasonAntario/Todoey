//
//  Item.swift
//  Todoey
//
//  Created by Dmitry Sankovsky on 3.01.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct Item: Codable{
    var title: String = ""
    var done: Bool = false
}
