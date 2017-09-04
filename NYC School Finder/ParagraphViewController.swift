//
//  PragraphViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/3/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class ParagraphViewController: UIViewController {

    var paragraph: String = ""
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text! = paragraph
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
