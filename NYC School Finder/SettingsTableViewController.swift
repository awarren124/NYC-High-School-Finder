//
//  SettingsTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/22/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let appURL = "itms-apps://itunes.apple.com/app/id1242567880"
            if UIApplication.shared.canOpenURL(URL(string: appURL)!){
                UIApplication.shared.open(URL(string: appURL)!, options: [:], completionHandler: nil)
            }
        }
    }
}
