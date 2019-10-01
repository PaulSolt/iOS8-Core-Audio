//
//  Recorder.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

class Recoder: NSObject {

	private var audioRecorder: AVAudioRecorder
	
	var isRecording: Bool {
		return audioRecorder.isRecording
	}
	
	override init() {
		audioRecorder = AVAudioRecorder()
		
		super.init()
	}
	
	func record() {
//		audioRecorder.prepareToRecord()
		
		let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
		print("Filename: \(name)")
		
		// .caf extension
		let file = documentDirectory.appendingPathComponent(name).appendingPathExtension("caf")
		
		// 44.1 KHz
		// 128 / 256 KHz
		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // TODO: Fix force unwrap
		
		audioRecorder = try! AVAudioRecorder(url: file, format: format)
		
		// start the recoring!
		audioRecorder.record()
	}
	
	func stop() {
		audioRecorder.stop() // save to disk
	}
}
