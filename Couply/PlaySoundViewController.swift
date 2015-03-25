//
//  PlaySoundViewController.swift
//  Couply
//
//  Created by Minette Yu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    
    override func viewWillAppear(animated: Bool) {
        stopALLAudio.hidden=true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if var filePath = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3"){
            audioPlayer = AVAudioPlayer(contentsOfURL: filePath, error: nil)
            audioPlayer.enableRate=true
            
        }else{
            println("This file path is empty")
        }
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func playSlow(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.play()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime=0.0
        stopALLAudio.hidden=false
        
        
    }

    @IBAction func playFast(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.play()
        audioPlayer.rate=2.0
        audioPlayer.currentTime=0.0
        stopALLAudio.hidden=false
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBOutlet weak var stopALLAudio: UIButton!
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
