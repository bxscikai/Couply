//
//  AudioManager.swift
//  Couply
//
//  Created by Chenkai Liu on 3/24/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import AVFoundation
import UIKit

private let _audioManager = AudioManager()

class AudioManager : NSObject, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var recordedAudio: RecordedAudio!    
    
    class var sharedInstance : AudioManager {
        return _audioManager;
    }
    
    func startRecording() {
        
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
    
    func stopRecording() {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    // Audio recorder delegate method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag)
        {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl=recorder.url
            recordedAudio.title=recorder.url.lastPathComponent
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.audioFinishedRecording_key, object:recordedAudio)
        }
        else
        {
            println("Recording was not successful. Please try again.")
        }                
    }
    
    func playSound(soundPath : NSURL) {
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        audioPlayer.stop()
        audioPlayer.play()
    }
        
}
    
