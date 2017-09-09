//
//  SchoolSearchViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 8/30/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class SchoolSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SchoolSearchViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    var items = [School]()
    
    var selectedSchool: School!
    
    var currentSearchByFilter = "School Name"
    var currentSortByFilter = "Relevance"
    var currentSortByDirection = "Ascending"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        School.initializeMapDictionary()
        self.tableView.addSubview(self.refreshControl)

        print("HERREE")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        search(withText: searchBar.text!)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        search(withText: text!)
    }
    
    func search(withText text: String){
        print("searchBarSearchButtonClicked")
        var filters = [
            School.keyMap[currentSearchByFilter],
            School.keyMap[currentSortByFilter],
            School.keyMap[currentSortByDirection]
        ]
        if currentSortByFilter == "Relevance" {
            filters[1] = ""
            filters[2] = ""
        }
        print(filters)
        print(School.keyMap)
        School.schools(withNameMatching: text, filterOptions: filters as! [String], completion: { (schools, error) in
            if(!error){
                self.items = schools
                print(schools)
                OperationQueue.main.addOperation {
                    self.searchBar.endEditing(true)
                    self.tableView.reloadData()
                    print("huh")
                }
            
                print("realoding data...")
            }else{
                let alertController = UIAlertController(title: "Error", message: "An Error Occured", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("numberOfRowsInSection: \(items.count)")
        return items.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "School Name", for: indexPath)
        cell.textLabel!.text = items[indexPath.row].values["school_name"] as? String
        //cell.detailTextLabel!.text = items[indexPath.row].values["boro"] as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        if let controller = segue.destination as? SchoolInfoViewController{
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView!.indexPath(for: cell)
            controller.currentSchool = items[(indexPath?.row)!]
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
