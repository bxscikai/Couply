//
//  ViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/1/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func makeRequestPressed(sender: AnyObject) {
        Server.getUser("Chenkai")
    }
    
    @IBOutlet weak var recordingInProgress: UILabel!
   

    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // Add comment
    
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
    }

    @IBAction func clickToRecord(sender: UIButton) {
        recordingInProgress.hidden=false
        stopButton.hidden=false
        recordButton.enabled=false
        stopButton.enabled=true
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden=true
        recordButton.enabled=true
        stopButton.enabled=false
    }
  
  
}