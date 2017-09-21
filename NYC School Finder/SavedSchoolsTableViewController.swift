//
//  SavedSchoolsTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/19/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class SavedSchoolsTableViewController: UITableViewController {

    var savedSchools: [SchoolModel] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            savedSchools = try context.fetch(SchoolModel.fetchRequest())
            tableView!.reloadData()
        }
        catch {
            print("Fetching Failed")
            //TODO: add error popup
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedSchools.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedSchoolCell", for: indexPath)

        cell.textLabel!.text = savedSchools[indexPath.row].school_name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(savedSchools[indexPath.row])
            savedSchools.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SchoolInfoViewController{


            let cell = sender as! UITableViewCell
            let indexPath = self.tableView!.indexPath(for: cell)
            let selectedSchoolModel = savedSchools[indexPath!.row]
            print(selectedSchoolModel.entity.attributesByName)
            var dict: [String: String] = [:]
            for key in selectedSchoolModel.entity.attributesByName.keys{
                dict[key] = selectedSchoolModel.value(forKey: key) as! String
            }
            vc.currentSchool = School(json: dict)
            vc.savedSchool = true
        }
    }
 

}
