//
//  AudioPlayer.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer)
}

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
	var delegate: AudioPlayerDelegate?
	
	var isPlaying: Bool {
		return audioPlayer.isPlaying	// TODO: will crash if audioPlayer is nil!
	}
	
	override init() {
		self.audioPlayer = AVAudioPlayer()
		
		super.init()
		
		let song = Bundle.main.url(forResource: "piano", withExtension: "mp3")! // FIXME: Crash if resource doesn't exist
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
		notifyDelegate()
	}
	
	func pause() {
		audioPlayer.pause()
		notifyDelegate()
	}
	
	func notifyDelegate() {
		delegate?.playerDidChangeState(self)
	}
	
	func playPause() {
		if isPlaying {
			pause()
		} else {
			play()
		}
	}
}

extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		if let error = error {
			print("Error playing audio file: \(error)")
		}
		
		// TODO: should we propogate this error back
		notifyDelegate()
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		// TODO: should we add a delegate protocol method?
		notifyDelegate()
	}
}
