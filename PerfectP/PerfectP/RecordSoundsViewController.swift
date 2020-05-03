//
//  RecordSoundsViewController.swift
//  PerfectP
//
//  Created by Mohammad Aljaralla on 01/04/2020.
//  Copyright © 2020 Mohammad Aljaralla. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isRecodrding(false)
    }

    @IBAction func recordAudio(_ sender: Any) {
        isRecodrding(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        isRecodrding(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            print("recording failed!")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordeAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordeAudioURL
        }
    }
    
    func isRecodrding(_ status: Bool){
        recordAudio.isEnabled = !status
        stopRecording.isEnabled = status
        if status{
            statusLabel.text = "Recording Now"
        }else{
            statusLabel.text = "Tab to Recorde"
        }
    }
}
