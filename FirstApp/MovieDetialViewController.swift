//
//  MovieDetialViewController.swift
//  FirstApp
//
//  Created by 葉家宏 on 2021/3/12.
//

import UIKit
import Foundation
import AVFoundation
import AVKit

class MovieDetialViewController: UIViewController {
    
    var audioPlayer:AVPlayer?
    var playerItem:AVPlayerItem?

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var songProgressSlider: UISlider!
    @IBOutlet weak var songLengthLabel: UILabel!
    @IBOutlet weak var movie_preview: UIView!
    
    let controller = AVPlayerViewController()
    
    let mewTwo = "https://video-ssl.itunes.apple.com/apple-assets-us-std-000001/Video128/v4/ac/7c/62/ac7c6274-60ea-5b7c-4c99-f08d78bfe574/mzvf_484000410198456586.640x352.h264lc.U.p.m4v"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: mewTwo)
        let player = AVPlayer(url: url!)
        
        
        controller.view.frame = CGRect(x: 0, y: 0, width: movie_preview.bounds.width, height: movie_preview.bounds.height)
        controller.player = player
        movie_preview.addSubview(controller.view)
        
        
        let music_op = URL(string: "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview118/v4/69/0e/98/690e98db-440d-cb0c-2bff-91b00a05bdda/mzaf_1674062311671795807.plus.aac.p.m4a")
        playerItem = AVPlayerItem(url: music_op!)
        audioPlayer = AVPlayer(playerItem: playerItem!)
        
        
        audioPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
        if self.audioPlayer!.currentItem?.status == .readyToPlay {
        let currentTime = CMTimeGetSeconds(self.audioPlayer!.currentTime())
        self.songProgressSlider.value = Float(currentTime)
        self.currentTimeLabel.text = self.formatConversion(time: currentTime)
         }
        })
        
        updatePlayerUI()
       
       

            
    }
    @IBAction func play_movie(_ sender: Any) {
        
        self.present(controller, animated: true) {
            self.controller.player!.play()
        }
    }
    
    
    @IBAction func play_op(_ sender: UIButton) {
       
        if audioPlayer?.rate == 0 {
            playButton.setImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal)
           audioPlayer?.play()
          } else {
            playButton.setImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal)
           audioPlayer?.pause()
          }
        

    }
    
    
    
    func updatePlayerUI() {
    // 抓取 playItem 的 duration
    let duration = playerItem!.asset.duration
    // 把 duration 轉為我們歌曲的總時間（秒數）。
    let seconds = CMTimeGetSeconds(duration)
    // 把我們的歌曲總時長顯示到我們的 Label 上。
    songLengthLabel.text = formatConversion(time: seconds)
    songProgressSlider!.minimumValue = 0
    // 更新 Slider 的 maximumValue。
    songProgressSlider!.maximumValue = Float(seconds)
    // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
    songProgressSlider!.isContinuous = true
    }
    
    
    func formatConversion(time:Float64) -> String {
    let songLength = Int(time)
    let minutes = Int(songLength / 60) // 求 songLength 的商，為分鐘數
    let seconds = Int(songLength % 60) // 求 songLength 的餘數，為秒數
    var time = ""
    if minutes < 10 {
      time = "0\(minutes):"
    } else {
      time = "\(minutes)"
    }
    if seconds < 10 {
      time += "0\(seconds)"
    } else {
      time += "\(seconds)"
    }
      return time
    }
    
    
    @IBAction func changeCurrentTime(_ sender: UISlider) {
      let seconds = Int64(songProgressSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
      // 將當前設置時間設為播放時間
      audioPlayer?.seek(to: targetTime)
    }
}
