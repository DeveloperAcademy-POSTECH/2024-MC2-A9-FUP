//
//  AVFoundationManager.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import SwiftUI
import AVFoundation

@Observable
final class AVFoundationManager: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recordBarTimer: Timer?
    
    // 컴포넌트의 재생 싱크를 맞추기 위한 변수
    var playingTime: TimeInterval = 0
    var recordLength: TimeInterval = 0
    
    // 녹음, 재생을 추적하기 위한 변수
    var isRecording = false
    var isPlaying = false
    
    var audioFilename: URL?
    
    // 녹음 중 실시간으로 변경되는 오디오레벨을 저장하기 위한 변수
    var audioLevel: CGFloat = 0
    
    // 녹음이 끝나고 전체 길이에서 30개의 구간별 평균 오디오레벨을 저장하기 위한 배열
    var audioLevels: [CGFloat] = Array(repeating: 0, count: 30)
    
    // 녹음 중 0.1초마다 생성되는 모든 오디오레벨을 저장하기 위한 임시 배열
    private var tempAudioLevels: [CGFloat] = []
    
    // MARK: - 초기화
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
    
    // MARK: - 권한 체크
    func requestPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioApplication.shared.recordPermission {
        case .denied:
            completion(false)
        case .granted:
            completion(true)
        case .undetermined:
            AVAudioApplication.requestRecordPermission(completionHandler: completion)
        @unknown default:
            break
        }
    }
    
    // MARK: - 녹음
    func startRecording(fileName: String) {
        tempAudioLevels.removeAll()
        playingTime = 0
        
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
            // audioLevel을 Update하기 위해 필요
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            self.audioFilename = audioFilename
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
        
        // 오디오 레벨 추적 시작
        startUpdatingAudioLevels()
    }
    
    func stopRecording() {
        // 녹음한 총 길이
        recordLength = audioRecorder?.currentTime ?? 0
        
        audioRecorder?.stop()
        isRecording = false
        
        stopUpdatingAudioLevels()
        calculateAudioLevels()
        
    }
    
    // MARK: - 재생
    func playRecording() {
        guard let audioFilename = audioFilename else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            // 재생 시 볼륨 설정
            audioPlayer?.volume = 70
            isPlaying = true
            
            // 0.1초마다 현재 재생 위치 업데이트, 업데이트되면서 애니메이션
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.bouncy) {
                    self.playingTime = self.audioPlayer?.currentTime ?? 0
                }
            }
            
        } catch {
            print("Could not play audio: \(error.localizedDescription)")
        }
    }
    
    func playRecorded(audioFilename: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            let asset = AVAsset(url: audioFilename)
            
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            audioPlayer?.volume = 70
            isPlaying = true
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.bouncy) {
                    self.playingTime = self.audioPlayer?.currentTime ?? 0
                }
            }
        } catch {
            print("Could not play audio: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    // MARK: - 오디오 레벨
    func startUpdatingAudioLevels() {
        recordBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateAudioLevels()
        }
    }
    
    func updateAudioLevels() {
        audioRecorder?.updateMeters()
        
        // 데시벨로 된 오디오 레벨을 정규화
        let averagePower = audioRecorder?.averagePower(forChannel: 0) ?? 0
        let normalizedAveragePower = pow(10, (0.05 * averagePower))
        
        // RecordingView에서 원이 작아졌다 커졌다 하는 애니메이션
        withAnimation {
            self.audioLevel = CGFloat(normalizedAveragePower)
        }
        
        // 오디오 레벨을 시각화하기 위해 임시 배열에 오디오 레벨을 전부 저장
        tempAudioLevels.append(CGFloat(normalizedAveragePower))
    }
    
    func stopUpdatingAudioLevels() {
        recordBarTimer?.invalidate()
        self.audioLevel = 0
    }
    
    /// tempAudioLevels에 있는 모든 오디오 레벨을 재생 막대의 개수인 30개의 구간으로 나눠서 audioLevels에 저장하는 메소드
    func calculateAudioLevels() {
        let intervalLength = recordLength / 30
        for i in 0..<30 {
            let startTime = TimeInterval(i) * intervalLength
            let endTime = startTime + intervalLength
            
            let intervalLevels = tempAudioLevels.enumerated()
                .filter { $0.offset >= Int(startTime * 10) && $0.offset < Int(endTime * 10) }
                .map { $0.element }
            
            let averageLevel = intervalLevels.reduce(0, +) / CGFloat(intervalLevels.count)
            audioLevels[i] = averageLevel
            if audioLevels[i].isNaN {
                audioLevels[i] = 0
            }
        }
        
        tempAudioLevels.removeAll()
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
