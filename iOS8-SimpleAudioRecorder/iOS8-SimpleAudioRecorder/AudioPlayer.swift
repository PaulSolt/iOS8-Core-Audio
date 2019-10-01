//
//  AudioPlayer.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

class AudioPlayer: NSObject {
	
	// load (song)
	// play
	// pause
	// are we playing? isPlaying
	// Communicate status (time codes)
	// - duration
	// - time remaining
	// - current position
	
	var audioPlayer: AVAudioPlayer
	var isPlaying: Bool {
		return audioPlayer.isPlaying	// TODO: will crash if audioPlayer is nil!
	}
	
	override init() {
		self.audioPlayer = AVAudioPlayer()
		
		super.init()
		
		let song = Bundle.main.url(forResource: "piano", withExtension: "mp3")! // Crash if resource doesn't exist
		try! load(url: song) // TODO: demo purposes to get something working
	}
	
//	init(url: URL) throws {
//
//		load(url: <#T##URL#>)
//	}
	
	func load(url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
	}
	
	func play() {
		audioPlayer.play()
	}
	
	func pause() {
		audioPlayer.pause()
	}
	
	func playPause() {
		// TODO: figure out based on state, what to do...
	}
	
	
	
}
