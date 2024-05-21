//
//  AVFoundationManager.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import Foundation
import AVFoundation

@Observable
final class AVFoundationManager: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    var isRecording = false
    var isPlaying = false
    var audioFilename: URL?
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        do {
            // 오디오 세션의 카테고리를 재생 및 녹음 모드로 설정
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            // 오디오 세션 활성화
            try recordingSession.setActive(true)
        } catch {
            print("Failed to setup recording session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 녹음
    func startRecording(fileName: String) {
        if audioFilename != nil {
            deleteRecording()
        }
        // 녹음 파일 경로 설정
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(fileName).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            self.audioFilename = audioFilename
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    // MARK: - 재생
    func playRecording() {
        guard let audioFilename = audioFilename else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
        } catch {
            print("Could not play audio: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    // MARK: - 삭제
    func deleteRecording() {
        guard let audioFilename = audioFilename else { return }
        
        do {
            try FileManager.default.removeItem(at: audioFilename)
            self.audioFilename = nil
            print("Recording deleted successfully.")
        } catch {
            print("Could not delete recording: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 경로
    func getCurrentRecordingPath() -> URL? {
        return audioFilename
    }
    
    func setCurrentRecordingPath(_ path: URL) {
        self.audioFilename = path
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 델리게이트
extension AVFoundationManager: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // 녹음이 완료되면 호출. 성공적으로 완료되지 않은 경우 stopRecording 메서드 호출
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording()
        }
    }
    // 재생이 완료되면 호출. 재생 상태를 false로 설정
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
