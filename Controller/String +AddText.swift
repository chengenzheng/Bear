//
//  String +AddText.swift
//  MyLocations
//
//  Created by Admin on 12.09.17.
//  Copyright © 2017 NS. All rights reserved.
//

import Foundation


extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}


