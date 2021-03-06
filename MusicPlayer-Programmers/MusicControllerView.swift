//
//  MusicControllerView.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit
import AVFoundation

class MusicControllerView: UIView {
    
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var helpTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    weak var player: AVAudioPlayer?
    weak var lyricsView: LyricsTableView?
    var timer: Timer?
    var isInterruptable = false 
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setInitialView()
    }
    
    // MARK: - Setting View
    func setInitialView() {
        loadView()
        addSubview(helpTimeLabel)
        setActionToButtonView()
        setTouchGestureToProgressBar()
        addObserverForSyncingLyrics()
    }

    func loadView() {
        let bundle = Bundle(for: MusicControllerView.self)
        let nib = UINib(nibName: "MusicControllerView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setActionToButtonView() {
        playButton.setImage(UIImage(systemName: "play.fill")?.middImage(), for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
    }

    func setTouchGestureToProgressBar() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchProgressBar(sender:)))
        longGesture.minimumPressDuration = 0.01
        progressBar.addGestureRecognizer(longGesture)
    }
    
    // MARK: - Action
    @objc func clickPlayButton() {
        guard let player = player else { return }
        if player.isPlaying {
            stopPlayer()
        } else {
            startPlayer()
        }
    }
    
    func stopPlayer() {
        guard let player = player else { return }
        player.stop()
        timer?.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill")?.middImage(), for: .normal)
    }
    
    func startPlayer() {
        guard let player = player else { return }
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerBehavior), userInfo: nil, repeats: true)
        playButton.setImage(UIImage(systemName: "pause.fill")?.middImage(), for: .normal)
    }
    
    /// Timer ?????? - `ProgressBar`, `Label`,  `???????????????` ????????????
    @objc func timerBehavior() {
        guard let player = player else { return }
        let percent = player.currentTime/player.duration
        if percent == 0 {
            stopPlayer()
        }
        
        if !isInterruptable {
            changeView(isFromButton: true, sender: nil)
        }
    }
    
    /// `ProgressBar`, `Label`,  `???????????????`, `Player` ???????????? ?????????
    @objc func touchProgressBar( sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isInterruptable = true
            animateProgressBar()
        case .ended:
            isInterruptable = false
            animateProgressBar()
            guard let currentTime = convertToTimeInterval(by: player, progressBar, sender) else { return }
            player?.currentTime = currentTime
            changeView(isFromButton: true, sender: sender)
            
        default:
            changeView(isFromButton: false, sender: sender)
        }
        showHelpTimeLabel(by: sender, text: convertToString(by: player, progressBar, sender))
    }
    
    /// `ProgressBar`, `Label`,  `???????????????` ????????????
    ///  1. ????????? ???????????????, 2. progressBar??? ??????????????? ?????????.
    func changeView(isFromButton: Bool, sender: UILongPressGestureRecognizer? ) {
        guard let player = player else { return }
        
        if isFromButton {
            lyricsView?.moveCell(by: player.currentTime)
            currentTimeLabel.text = convertToString(by: player.currentTime)
            progressBar.progress = convertToProgressBarPercent(by: player)
        } else {
            currentTimeLabel.text = convertToString(by: player, progressBar, sender)
            if let progress = convertToTimeInterval(by: player, progressBar, sender) {
                progressBar.progress = Float(progress / player.duration)
            }
        }
    }
    
    func animateProgressBar() {
        UIView.animate(withDuration: 0.1) {
            self.progressBar.transform = self.isInterruptable ? CGAffineTransform(scaleX: 1.0, y: 1.6) :  CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// `?????? ?????????` Notification?????? ????????????, `??????`, `progress bar`, `label` ??????
    func addObserverForSyncingLyrics() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("touchText"), object: nil, queue: .main) { notification in
            guard let nextTime = notification.userInfo?["touchText"] as? Double else { return }
            self.player?.currentTime = nextTime
            self.changeView(isFromButton: true, sender: nil)
        }
    }
}


extension MusicControllerView {
    func showHelpTimeLabel(by sender: UILongPressGestureRecognizer, text: String?) {
        var loc = sender.location(in: self)
        loc.x = max(loc.x, progressBar.frame.minX)
        loc.x = min(loc.x, progressBar.frame.maxX)
        
        helpTimeLabel.text = text
        let width = helpTimeLabel.intrinsicContentSize.width
        let height = helpTimeLabel.intrinsicContentSize.height
        
        helpTimeLabel.frame.origin = CGPoint(x: loc.x-(width/2),
                                             y: progressBar.frame.minY-20)
        helpTimeLabel.frame.size = CGSize(width: width, height: height)
        helpTimeLabel.isHidden = isInterruptable ? false : true
    }
}
