//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Andrew Stepanov on 28/01/16.
//  Copyright © 2016 Andrew Stepanov. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var processingIndicator: UIActivityIndicatorView!
    

    var audioRecorder: AVAudioRecorder!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordingLabel.hidden = true
        processingIndicator.hidden = true
        stopButton.hidden = true
    
        recordButton.enabled = true
        stopButton.enabled = true
    }
    
    private func record() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "temp_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func recordButtonClick(sender: UIButton, forEvent event: UIEvent) {
        recordingLabel.hidden = false
        stopButton.hidden = false
        stopButton.enabled = true
        recordButton.enabled = false
            
        record()
    }
    
    @IBAction func stopButtonClick(sender: UIButton, forEvent event: UIEvent) {
        recordingLabel.hidden = true
        processingIndicator.hidden = false
        processingIndicator.startAnimating()
        stopButton.enabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let dest = segue.destinationViewController as! PlayViewController
            let data = sender as! RecordedAudio
            dest.recordedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        processingIndicator.stopAnimating()
        recordButton.enabled = true
        stopButton.hidden = true
        stopButton.enabled = true

        if (flag && recorder.url.lastPathComponent != nil) {
            let recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Failed to record audio", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

