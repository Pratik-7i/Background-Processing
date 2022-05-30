//
//  BGAudioPlaybackVC.swift
//  BG Processing
//
//  Created by Pratik on 25/05/22.
//

import UIKit
import AVFoundation

class BGAudioPlaybackVC: UIViewController
{
    @IBOutlet var albumImageView    : UIImageView!
    @IBOutlet var songNameLabel     : UILabel!
    @IBOutlet var artistNameLabel   : UILabel!
    @IBOutlet var playbackTimeLabel : UILabel!
    @IBOutlet var totalTimeLabel    : UILabel!
    @IBOutlet var progressView      : UIProgressView!

    var timeObserverToken : Any?

    lazy var player: AVQueuePlayer = {
        let player = AVQueuePlayer(items: self.songs)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
        return player
    }()
    
    private lazy var songs: [AVPlayerItem] = {
        let songNames = ["Ranjha", "Daydreamer", "KungsCookin"]
        return songNames.map {
            let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
            return AVPlayerItem(url: url)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureAudioSesion()
        self.addPlaybackTimeObserver()
    }
    
    // MARK: - Others
    
    func configureAudioSesion()
    {
        // Set the audio session’s category, mode and options.
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetooth])
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.player.play()
        } else {
            self.player.pause()
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.player.advanceToNextItem() 
    }
    
    // MARK: - Playback Observers
    
    func addPlaybackTimeObserver()
    {
        let interval = CMTimeMake(value: 1, timescale: 100)
        
        self.timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] progress in
            guard let self = self else { return }
            let timeString = Helper.stringFromTimeInterval(progress.seconds)

            if UIApplication.shared.applicationState == .active {
                // 1. Progress label
                self.playbackTimeLabel.text = timeString
                
                // 2. Progress bar
                if let currentItem = self.player.currentItem?.asset as? AVURLAsset {
                    let progress = progress.seconds/currentItem.duration.seconds
                    self.progressView.progress = Float(progress)
                }
            } else {
                print("Background: \(timeString)")
            }
        }
    }
    
    func removePlaybackTimeObserver()
    {
        if let timeObserverToken = self.timeObserverToken {
            self.player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "currentItem",
           let player = object as? AVPlayer,
           let currentItem = player.currentItem?.asset as? AVURLAsset {
            self.showSongMetada(currentItem)
        }
    }
    
    // MARK: - Song Metadata

    func showSongMetada(_ playerItem: AVURLAsset)
    {
        let metadata = playerItem.commonMetadata
        
        // 1. Album artwork
        let artworkItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork)
        if let artworkItem = artworkItems.first, let imageData = artworkItem.dataValue {
            let image = UIImage(data: imageData)
            self.albumImageView.image = image
        } else {
            self.albumImageView.image = UIImage(named: "albumPlaceholder")
        }
        
        // 2. Song name
        let albumItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle)
        if let albumItem = albumItems.first, let albumName = albumItem.value as? String {
            self.songNameLabel.text = albumName
        } else {
            self.songNameLabel.text = "--"
        }
        
        // 3. Artist Name
        let artistItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist)
        if let artistItem = artistItems.first, let artistName = artistItem.value as? String {
            self.artistNameLabel.text = artistName
        } else {
            self.artistNameLabel.text = "--"
        }
        
        // 4. Progress
        self.progressView.progress = 0
        
        // 5. Playback duration
        self.playbackTimeLabel.text = "00:00"
        
        // 6. Total duration
        let duration: CMTime = playerItem.duration
        let seconds: Float64 = CMTimeGetSeconds(duration)
        self.totalTimeLabel.text = Helper.stringFromTimeInterval(seconds)
    }
    
    deinit {
        self.removePlaybackTimeObserver()
        print("Playback time observer removed")
    }
}
