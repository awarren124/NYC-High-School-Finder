//
//  SchoolInfoViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/2/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit
import MapKit

class SchoolInfoViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var currentSchool: School!
    var tableView: UITableView!
    var savedSchool: Bool!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (currentSchool.values["school_name"] as! String)
        // Do any additional setup after loading the view.
        if savedSchool {
            saveButton.title = "Saved"
            saveButton.isEnabled = false
        }else{
            saveButton.title = "Save"
            saveButton.isEnabled = true

        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SchoolInfoTableViewController{
            vc.currentSchool = currentSchool
        }
    }
    
    
    @IBAction func mapsButtonPressed(_ sender: UIButton) {
        
        School.coordinates(fromSchoolCode: currentSchool.values["dbn"] as! String, completion: {(coords, error, statusCode) in
            if(!error){
                let latitude: CLLocationDegrees = coords["latitude"]!
                let longitude: CLLocationDegrees = coords["longitude"]!
                
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = self.currentSchool.values["school_name"] as? String
                mapItem.openInMaps(launchOptions: options)
            }else{
                //TODO: this
            }
        })
        
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let schoolModel = SchoolModel(context: context)
        for key in School.keys{
            if(key != "ASC" && key != "DESC"){
                schoolModel.setValue(currentSchool.values[key] as! String, forKey: key)
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        saveButton.title = "Saved"
        saveButton.isEnabled = false
    }
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


