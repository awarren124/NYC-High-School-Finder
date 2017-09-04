//
//  FilterViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/4/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var searchByPicker: UIPickerView!
    
    let searchByKeys = [
        "School Name",
        "School Code",
        "Language Classes",
        "Extracurricular Activities",
        "Sports",
        "Borough"
    ]
    var currentSearchByFilter = "School Name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchByPicker.delegate = self
        searchByPicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case searchByPicker:
            return searchByKeys.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case searchByPicker:
            return searchByKeys[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case searchByPicker:
            currentSearchByFilter = searchByKeys[row]
            break
        default:
            break
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let vc = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as? SchoolSearchViewController {
            vc.currentSearchByFilter = self.currentSearchByFilter
            print("here9")
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    
}
