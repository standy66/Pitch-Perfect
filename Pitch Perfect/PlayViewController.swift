//
//  PlayViewController.swift
//  Pitch Perfect
//
//  Created by Andrew Stepanov on 29/01/16.
//  Copyright © 2016 Andrew Stepanov. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var player: AVAudioPlayer!
    var engine: AVAudioEngine!
    var recordedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioBuffer: AVAudioPCMBuffer!
    
    private func stopAudioIfPlaying() {
        engine.stop()
        engine.reset()
        if (player != nil && player.playing) {
            player.stop()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
        //audioBuffer = AVAudioPCMBuffer(PCMFormat: audioFile.fileFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
        //try! audioFile.readIntoBuffer(audioBuffer)
        
        stopButton.enabled = false
        player = try! AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        engine = AVAudioEngine()
        player.delegate = self
        player.enableRate = true
    }
    
    func playAt(rate rate: Float) {
        stopAudioIfPlaying()
        player.rate = rate
        player.play()
        stopButton.enabled = true
    }
    
    func playWith(pitch pitch: Float) {
        stopAudioIfPlaying()
        
        let playerNode = AVAudioPlayerNode()
        let unitTimePitch = AVAudioUnitTimePitch()
        unitTimePitch.pitch = pitch
        
        engine.attachNode(playerNode)
        engine.attachNode(unitTimePitch)
        
        engine.connect(playerNode, to: unitTimePitch, format: nil)
        engine.connect(unitTimePitch, to: engine.outputNode, format: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! engine.start()
        playerNode.play()
        stopButton.enabled = true
        
    }
    
    @IBAction func slowButtonClick(sender: UIButton, forEvent event: UIEvent) {
        playAt(rate: 0.5)
    }
    
    @IBAction func fastButtonClick(sender: UIButton, forEvent event: UIEvent) {
        playAt(rate: 2)
    }
    
    @IBAction func chipmunkButtonClick(sender: UIButton, forEvent event: UIEvent) {
        playWith(pitch: 600)
    }
    
    @IBAction func darthVaderButtonClick(sender: UIButton, forEvent event: UIEvent) {
        playWith(pitch: -600)
    }
    
    @IBAction func stopButtonClick(sender: AnyObject) {
        stopAudioIfPlaying()
        stopButton.enabled = false
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopButton.enabled = false
    }
    
    
    
}
