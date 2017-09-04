//
//  ViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 8/27/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let data: Data = {"asda": 123}
        School.schools(withNameMatching: "Bronx High School of Science") { schools in
            print(schools)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

