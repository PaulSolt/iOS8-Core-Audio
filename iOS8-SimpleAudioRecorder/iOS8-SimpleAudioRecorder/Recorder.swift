//
//  Recorder.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

// AnyObject for weak?
protocol RecorderDelegate {
    func recorderDidChangeState(_ recorder: Recorder)
	func recorderDidFinishSavingFile(_ recorder: Recorder) // TODO: what do we know? URL
}

class Recorder: NSObject {

	// NOTE: Don't create an AVAudioRecorder() it will crash when
	// we try to ask it if it's recording
	private var audioRecorder: AVAudioRecorder?
	var delegate: RecorderDelegate?
	
	var isRecording: Bool {
		return audioRecorder?.isRecording ?? false
	}
	
	override init() {
		super.init()
	}
	
	func record() {
		let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
		
		
		// .caf extension
		let file = documentDirectory.appendingPathComponent(name).appendingPathExtension("caf")
		print("Filename: \(file.path)")
		
		// 44.1 KHz
		// 128 / 256 KHz
		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // TODO: Fix force unwrap
		
		audioRecorder = try! AVAudioRecorder(url: file, format: format) // TODO: handle the failure
		
		// start the recoring!
		audioRecorder?.record()
		notifyDelegate()
	}
	
	func stop() {
		audioRecorder?.stop() // save to disk
		notifyDelegate()
	}
	
	func toggleRecording() {
		if isRecording {
			stop()
		} else {
			record()
		}
	}
	
	func notifyDelegate() {
		delegate?.recorderDidChangeState(self)
	}
}
