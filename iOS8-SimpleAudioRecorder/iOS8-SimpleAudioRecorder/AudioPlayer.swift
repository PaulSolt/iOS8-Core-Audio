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
	
	var audioPlayer: AVAudioPlayer
	var delegate: AudioPlayerDelegate?
	var timer: Timer?
	
	var isPlaying: Bool {
		return audioPlayer.isPlaying	// TODO: will crash if audioPlayer is nil!
	}
	
	var elapsedTime: TimeInterval {
		return audioPlayer.currentTime
	}
	
	// Swift 5.1 can omit the `return`
	var timeRemaining: TimeInterval {
		return duration - elapsedTime
	}
	
	var duration: TimeInterval {
		return audioPlayer.duration
	}
	
	override init() {
		self.audioPlayer = AVAudioPlayer()
		
		super.init()
		
		let song = Bundle.main.url(forResource: "piano", withExtension: "mp3")! // FIXME: Crash if resource doesn't exist
		try! load(url: song) // TODO: demo purposes to get something working
	}
	
	func load(url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
		audioPlayer.delegate = self
	}
	
	func play() {
		audioPlayer.play()
		startTimer()
		notifyDelegate()
	}
	
	func pause() {
		audioPlayer.pause()
		stopTimer()
		notifyDelegate()
	}
	
	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (_) in
			self.notifyDelegate()
		})
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	private func notifyDelegate() {
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
		
		// TODO: should we propogate this error back, new method in delegate protocol
		notifyDelegate()
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		// TODO: should we add a delegate protocol method?
		notifyDelegate()
	}
}
