//
//  ViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/1/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var recordingInProgress: UILabel!
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // Add comment
        // Chenkai is an asshole
        
    }

    @IBAction func clickToRecord(sender: UIButton) {
        recordingInProgress.hidden=false
       
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden=true
    }
  
  
}
  

