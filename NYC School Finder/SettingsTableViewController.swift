//
//  SettingsTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/22/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
        
    @IBOutlet weak var filterRealoadSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let val = UserDefaults.standard.object(forKey: "Filter Reload") as? Bool {//bool(forKey: "Filter Reload"){
            filterRealoadSwitch.isOn = val
        }else{
            UserDefaults.standard.set(true, forKey: "Filter Reload")
        }
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
    
    @IBAction func filterReloadSwitchValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Filter Reload")
        UserDefaults.standard.synchronize()
    }
    
}
