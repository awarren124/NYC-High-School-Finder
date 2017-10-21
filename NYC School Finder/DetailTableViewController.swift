//
//  DetailTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/3/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var detailType: DetailType!
    var unformattedText = ""
    var formattedList = [String]()
    var unformattedSports = [String]()
    var formattedSports = [[String]]()
    var programs = [Program]()
    var formattedPrograms = [[[String]]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        switch detailType!{
        case .Sports:
            for sports in unformattedSports {
                formattedSports.append(sports.components(separatedBy: ", "))
            }
            break
        case .Subway:
            self.formattedList = unformattedText.components(separatedBy: "; ")
            break
        case .Program:
            for program in programs{
                var temp = [[String]]()
                for key in Program.programKeys{
                    if let val = program.values[key] {
                        temp.append([key, val])
                    }
                }
                formattedPrograms.append(temp)
            }
        default:
            self.formattedList = unformattedText.components(separatedBy: ", ")
            break
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch detailType!{
        case .Sports:
            return 4
        case .Program:
            return programs.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch detailType!{
        case .Sports:
            return formattedSports[section].count
        case .Program:
            return formattedPrograms[section].count
        default:
            return formattedList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if detailType == .Program {
            let text: NSString = NSString(string: formattedPrograms[indexPath.section][indexPath.row][1])
            if text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)]).width > UIScreen.main.bounds.width {
                cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell Subtitle with Disclosure", for: indexPath)

            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell Subtitle", for: indexPath)

            }
            

        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell Basic", for: indexPath)

        }

        switch detailType! {
        case .Sports:
            cell.textLabel!.text = formattedSports[indexPath.section][indexPath.row]
        case .Program:
            cell.textLabel!.text = formattedPrograms[indexPath.section][indexPath.row][1]
            cell.detailTextLabel!.text = Program.keyMap[formattedPrograms[indexPath.section][indexPath.row][0]]
        default:
            cell.textLabel!.text = formattedList[indexPath.row]
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch detailType! {
        case .Sports:
            switch section {
            case 0:
                return "PSAL Boys"
            case 1:
                return "PSAL Girls"
            case 2:
                return "PSAL Coed"
            case 3:
                return "School Sports"
            default:
                return ""
            }
        case .Program:
            return programs[section].values["program"]//Program.programKeys[section]
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        let cell = sender as! UITableViewCell
        if cell.accessoryType == UITableViewCellAccessoryType.disclosureIndicator {
            if let vc = segue.destination as? ParagraphViewController {
                vc.paragraph = (cell.textLabel?.text)!
                vc.title = (cell.detailTextLabel?.text)
            }
        }
    }
 

}

enum DetailType {
    case Sports
    case Subway
    case Program
    case Default
}
