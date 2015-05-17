//
//  RecordSoundViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/1/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//
import AVFoundation
import UIKit


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
   

    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
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
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        audioRecorder.delegate = self
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden=true
        recordButton.enabled=true
        stopButton.enabled=false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    // Audio recorder delegate method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag){
            recordedAudio=RecordedAudio()
            recordedAudio.filePathUrl=recorder.url
            recordedAudio.title=recorder.url.lastPathComponent
            playSound()
//            self.performSegueWithIdentifier("stopRecording", sender:recordedAudio)
        }else{
            
            println("Recording was not successful. Please try again.")
            recordButton.enabled=true
            stopButton.hidden=true
        }
        
        
        
    }
    
    func playSound() {

        var audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        audioPlayer.delegate = self;
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundViewController=segue.destinationViewController as!PlaySoundViewController
            let data=sender as! RecordedAudio
            playSoundsVC.receivedAudio=data
        }
    }
}