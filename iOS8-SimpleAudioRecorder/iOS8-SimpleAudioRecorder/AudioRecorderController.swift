//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class AudioRecorderController: UIViewController {
    
	lazy private var player = AudioPlayer()
	lazy private var recorder = Recorder()
	
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
	
	private lazy var timeFormatter: DateComponentsFormatter = {
		let formatting = DateComponentsFormatter()
		formatting.unitsStyle = .positional // 00:00  mm:ss
		// NOTE: minutes/hours/seconds (DateComponentsFormatter not good for milliseconds, use DateFormatter instead)
		formatting.zeroFormattingBehavior = .pad
		formatting.allowedUnits = [.minute, .second]
		return formatting
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()


        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
		
		// TODO: Cleanup for production
		let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		print("Document dir: \(documentDirectory.path)")
		
		player.delegate = self
		recorder.delegate = self
		
		updateSlider()
		// TODO: test for when file isn't loaded properly, don't want a 0 duration
	}


    @IBAction func playButtonPressed(_ sender: Any) {
		player.playPause()
		updateSlider()
	}
		
	private func updateSlider() {
		timeSlider.minimumValue = 0
		timeSlider.maximumValue = Float(player.duration)
		timeSlider.value = Float(player.elapsedTime)
	}
    
    @IBAction func recordButtonPressed(_ sender: Any) {
		recorder.toggleRecording()
    }
	
	func updateViews() {
		let playButtonTitle = player.isPlaying ? "Pause" : "Play"
		playButton.setTitle(playButtonTitle, for: .normal)

		let recordButtonTitle = recorder.isRecording ? "Stop Recording" : "Record"
		recordButton.setTitle(recordButtonTitle, for: .normal)
		
		timeLabel.text = timeFormatter.string(from: player.elapsedTime)
		timeRemainingLabel.text = timeFormatter.string(from: player.timeRemaining)
		
		updateSlider()
	}
}

extension AudioRecorderController: AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer) {
		updateViews()
	}
}

extension AudioRecorderController: RecorderDelegate {
	func recorderDidChangeState(_ recorder: Recorder) {
		updateViews()
	}
	
	func recorderDidFinishSavingFile(_ recorder: Recorder) {
		
	}
}
