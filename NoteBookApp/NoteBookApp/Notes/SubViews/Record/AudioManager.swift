//
//  AudioManager.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 21/01/2023.
//

import Foundation
import AVFAudio

public protocol RecordingDelegate: NSObject {
    func audioManager(manager: AudioManager, didAllowRecording: Bool)
    func audioManager(manager: AudioManager, didFinishRecordingSuccess: Bool)
    func audioManager(manager: AudioManager, didUpdateRecordProgress: CGFloat)
}

public protocol PlayingDelegate: NSObject {
    func audioManager(manager: AudioManager, didFinishPlayingSuccess: Bool)
    func audioManager(manager: AudioManager, didUpdatePlayProgress: CGFloat)
}

public class AudioManager: NSObject {
    static let minRecordingTime = 0.3
    static let maxRecordingTime = 90.0
    static let recordingFolderName = "torepa"
    static let recordingTempFileName = "audio_temp.m4a"
    
    public var recorder: AVAudioRecorder?
    public var player: AVAudioPlayer?
    public var updateProgressIndicatorTimer: Timer?
    public var recordDelegate: RecordingDelegate?
    public var playingDelegate: PlayingDelegate?
    public private(set) var currentRecordingTime: TimeInterval = 0
    
    enum AudioManagerError: LocalizedError {
        case folderNotFound
        case fileNotFound
        case failedToSave
        case failedToGetDataFromURL(URL)
    }
    
    private let recordingsFolderURL: URL? = {
        let fm = FileManager.default
        let docURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        return docURL
    }()
    
    lazy var recordingFileURL: URL? = {
        let path = recordingsFolderURL
        let filePath = path?.appendingPathComponent("\(Date.now.timeIntervalSince1970.description).m4a")
        return filePath
    }()
    
    lazy var tempRecordingFileURL: URL? = {
        let path = recordingsFolderURL
        let filePath = path?.appendingPathComponent(Self.recordingTempFileName)
        return filePath
    }()
    
    
    public var isRecording: Bool {
        recorder?.isRecording == true
    }
    
    public func prepareAudioRecording() {
        guard let outputURL = tempRecordingFileURL else { return }
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord)
        
        let recordSetting = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        recorder = try? AVAudioRecorder(url: outputURL, settings: recordSetting)
        recorder?.delegate = self
        recorder?.isMeteringEnabled = true
        
        session.requestRecordPermission { [weak self] isGranted in
            guard let self = self else { return }
            self.recordDelegate?.audioManager(manager: self, didAllowRecording: isGranted)
            self.recorder?.prepareToRecord()
        }
    }
    
    func saveAudio(url: URL) throws {
        guard let recordingsFolderURL = recordingsFolderURL, let tempRecordingFileURL = tempRecordingFileURL else {
            throw AudioManagerError.folderNotFound
        }
        
        guard let data = try? Data(contentsOf: tempRecordingFileURL)
            else {
            throw AudioManagerError.failedToGetDataFromURL(tempRecordingFileURL)
        }
        
        do {
            try FileManager.default.createDirectory(at: recordingsFolderURL, withIntermediateDirectories: true)
        } catch {
            throw AudioManagerError.folderNotFound
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw AudioManagerError.failedToSave
        }
    }
    
    func startRecording() throws {
        
        guard let recorder = recorder, !recorder.isRecording else { return }
        
        player?.stop()
        
        let session = AVAudioSession.sharedInstance()
        try session.setActive(true)
        currentRecordingTime = 0
        recorder.record()
        
        updateProgressIndicatorTimer?.invalidate()
        updateProgressIndicatorTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(recordingStatusDidUpdate), userInfo: nil, repeats: true)
    }
    
    func deleteTempfile() throws {
        guard let tempRecordingFileURL = tempRecordingFileURL else { return }
        try? FileManager.default.removeItem(at: tempRecordingFileURL)
    }
    
    // MARK: - Audio Recording / Playback Feedback
    @objc
    func recordingStatusDidUpdate() {
        self.currentRecordingTime = self.recorder?.currentTime ?? 0
        let progress: CGFloat = max(0, min(1, currentRecordingTime / Self.maxRecordingTime))
        
        recorder?.updateMeters()
        recordDelegate?.audioManager(manager: self, didUpdateRecordProgress: progress)
        
        if progress >= 1 {
            stopRecording()
        }
    }
    
    @objc
    func playbackStatusDidUpdate() {
        guard let player = player else { return }
        let currentPlaytime = player.currentTime / player.duration
        let progress = fmax(0, min(1, currentPlaytime))
        playingDelegate?.audioManager(manager: self, didUpdatePlayProgress: progress)
    }
    
    var hasCapturedSufficientAudioLength: Bool {
        currentRecordingTime > Self.minRecordingTime
    }
    
    func stopRecording() {
        guard let recorder = recorder, recorder.isRecording else {
            return
        }
        
        recorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
        
        updateProgressIndicatorTimer?.invalidate()
    }
    
    func reset() {
        player?.stop()
        stopRecording()
        recorder?.prepareToRecord()
        self.currentRecordingTime = 0.0
    }
    
    var lastAveragePower: Float {
        recorder?.averagePower(forChannel: 0) ?? 0
    }
    
    // MARK: - Audio Playback
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }
    
    func playAudioFileFromURL(_ url: URL) throws {
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
        if recorder?.isRecording == false {
            updateProgressIndicatorTimer?.invalidate()
            updateProgressIndicatorTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(playbackStatusDidUpdate), userInfo: nil, repeats: true)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.delegate = self
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func startPlayingRecordedAudio() throws {
        guard let recordingFileURL = recordingFileURL else { return }
        try playAudioFileFromURL(recordingFileURL)
    }
    
    func stopPlayingRecordedAudio() {
        guard let player = player else { return }
        player.stop()
        updateProgressIndicatorTimer?.invalidate()
        playingDelegate?.audioManager(manager: self, didFinishPlayingSuccess: false)
    }
}

extension AudioManager: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        updateProgressIndicatorTimer?.invalidate()
        
        if hasCapturedSufficientAudioLength {
            guard let tempRecordingFileURL = tempRecordingFileURL else { return }
            try? saveAudio(url: tempRecordingFileURL)
        }
        
        recordDelegate?.audioManager(manager: self, didFinishRecordingSuccess: flag)
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateProgressIndicatorTimer?.invalidate()
        
        playingDelegate?.audioManager(manager: self, didFinishPlayingSuccess: flag)
    }
}
