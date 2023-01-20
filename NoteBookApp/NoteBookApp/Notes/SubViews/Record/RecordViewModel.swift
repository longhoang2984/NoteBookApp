//
//  RecordViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 20/01/2023.
//

import Foundation
import DSWaveformImage
import DSWaveformImageViews

final class RecordViewModel: NSObject, ObservableObject {
    @Published var samples: [Float] = []
    @Published var recordingTime: TimeInterval = 0
    @Published var isRecording: Bool = false {
        didSet {
            guard oldValue != isRecording else { return }
            updateRecordingState()
        }
    }
    @Published var isPlaying: Bool = false {
        didSet {
            guard oldValue != isPlaying else { return }
            updatePlayingState()
        }
    }
    @Published var recordURL: URL?
    @Published var playingProgress: CGFloat = 0
    @Published var playingTime: TimeInterval = 0
    @Published var showErrorSaveFile: Bool = false
    
    private let audioManager: AudioManager
    
    override init() {
        audioManager = AudioManager()
        
        super.init()
        
        audioManager.prepareAudioRecording()
        audioManager.recordDelegate = self
        audioManager.playingDelegate = self
    }
    
    func updateRecordingState() {
        isRecording ? try? startRecording() : stopRecording()
    }
    
    func startRecording() throws {
        samples = []
        try audioManager.startRecording()
    }
    
    func stopRecording() {
        audioManager.stopRecording()
    }
    
    func playRecord() throws {
        guard let recordingFile = audioManager.recorder?.url else { return }
        try audioManager.playAudioFileFromURL(recordingFile)
    }
    
    func stopPlay() {
        audioManager.stopPlayingRecordedAudio()
    }
    
    func updatePlayingState() {
        isPlaying ? try? playRecord() : stopPlay()
    }
    
    func saveRecord(completion: (Bool) -> Void) {
        showErrorSaveFile = false
        guard let saveURL = audioManager.recordingFileURL else { return }
        do {
            try audioManager.saveAudio(url: saveURL)
            try audioManager.deleteTempfile()
            completion(true)
        } catch {
            showErrorSaveFile = true
            completion(false)
        }
    }
    
}

extension RecordViewModel: RecordingDelegate {
    func audioManager(manager: AudioManager, didAllowRecording: Bool) {
        
    }
    
    func audioManager(manager: AudioManager, didFinishRecordingSuccess: Bool) {
        if didFinishRecordingSuccess {
            recordURL = audioManager.tempRecordingFileURL
        }
    }
    
    func audioManager(manager: AudioManager, didUpdateRecordProgress: CGFloat) {
        let linear = 1 - pow(10, manager.lastAveragePower / 20)
        
        // Here we add the same sample 3 times to speed up the animation.
        // Usually you'd just add the sample once.
        recordingTime = audioManager.currentRecordingTime
        samples += [linear, linear, linear]
    }
}

extension RecordViewModel: PlayingDelegate {
    func audioManager(manager: AudioManager, didFinishPlayingSuccess: Bool) {
        if didFinishPlayingSuccess {
            playingTime = 0
            isPlaying = false
        }
    }
    
    func audioManager(manager: AudioManager, didUpdatePlayProgress: CGFloat) {
        playingProgress = didUpdatePlayProgress
        playingTime = audioManager.player?.currentTime ?? 0
    }
}
