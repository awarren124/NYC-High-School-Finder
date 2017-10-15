//
//  Program.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 10/8/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import Foundation

struct Program {
    var values: [String: String]
    
    
    static let programKeys = [
        "program",
        "prgdesc",
        "method",
        "offer_rate",
        "academicopportunities",
        "auditioninformation",
        "interest"
    ]
    
    static let readableKeys = [
        "Program Name",
        "Program Description",
        "Method of Acceptance",
        "Offer Rate",
        "Academic Opportunities",
        "Audition Information",
        "Interest"
    ]

    static var keyMap = [String: String]()
    
    init() {
        values = [:]
    }
    
    init(vals: [String: String]) {
        values = vals
    }
    
    static func initializeMapDictionary(){
        Program.keyMap = Dictionary(keys: programKeys, values: readableKeys)
        
    }
    
}
