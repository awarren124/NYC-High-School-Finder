//
//  DictionaryExtension.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/4/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import Foundation

extension Dictionary {
    init(keys: [Key], values: [Value]) {
        self.init()
        
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }
}
