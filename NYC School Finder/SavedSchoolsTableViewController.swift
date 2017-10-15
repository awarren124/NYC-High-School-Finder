//
//  SavedSchoolsTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/19/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class SavedSchoolsTableViewController: UITableViewController {

    var savedSchools: [SchoolModel] = []
    let schoolContext = (UIApplication.shared.delegate as! AppDelegate).schoolPersistentContainer.viewContext
    let prgContext = (UIApplication.shared.delegate as! AppDelegate).programPersistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            savedSchools = try schoolContext.fetch(SchoolModel.fetchRequest())
            tableView!.reloadData()
        }
        catch {
            SVProgressHUD.showError(withStatus: "Unable to Show Saved Schools")
            SVProgressHUD.dismiss(withDelay: 2)
        }

    }

    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if !tableView.isEditing {
            sender.title = "Done"
            sender.style = .done
            tableView.setEditing(true, animated: true)
        }else{
            sender.title = "Edit"
            sender.style = .plain
            tableView.setEditing(false, animated: true)
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
            var programs = [ProgramModel]()
            do {
                //savedSchools = try schoolContext.fetch(SchoolModel.fetchRequest())
                let programFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgramModel")
                programFetchRequest.predicate = NSPredicate(format: "dbn == %@", savedSchools[indexPath.row].dbn!)
                programs = try prgContext.fetch(programFetchRequest) as! [ProgramModel]
            }
            catch {
            }
            for program in programs {
                prgContext.delete(program)
            }
            schoolContext.delete(savedSchools[indexPath.row])
            savedSchools.remove(at: indexPath.row)
           
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SchoolInfoViewController{


            let cell = sender as! UITableViewCell
            let indexPath = self.tableView!.indexPath(for: cell)
            let selectedSchoolModel = savedSchools[indexPath!.row]
            var dict: [String: String] = [:]
            for key in selectedSchoolModel.entity.attributesByName.keys{
                dict[key] = selectedSchoolModel.value(forKey: key) as? String
            }
            vc.currentSchool = School(json: dict)
            vc.savedSchool = true
            do{
                let programFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgramModel")
                programFetchRequest.predicate = NSPredicate(format: "dbn == %@", selectedSchoolModel.dbn!)

                let programModels = try prgContext.fetch(programFetchRequest) as! [ProgramModel]
                var currentPrograms = [Program]()
                for programModel in programModels {
                    var prgDict = [String : String]()
                    for prgKey in programModel.entity.attributesByName.keys{
                        prgDict[prgKey] = programModel.value(forKey: prgKey) as? String
                    }
                    currentPrograms.append(Program(vals: prgDict))
                }
                vc.currentPrograms = currentPrograms
            }
            catch{
                
            }
        }
    }
 

}
