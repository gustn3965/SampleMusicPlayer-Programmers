//
//  ViewController.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit
import AVFoundation
class MusicViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var musicView: MusicView!
    @IBOutlet var musicController: MusicControllerView!
    @IBOutlet var lyricsView: LyricsTableView!
    var launchImageView: UIImageView = UIImageView()
    
    let animationTransition = AnimationTransition()
    var player: AVAudioPlayer?
    let musicFetcher = MusicFetcher()
    var timer: Timer?
    lazy var lyricsViewController = LyricsViewController()
    
    // MARK: - method
    override func viewDidLoad() {
        super.viewDidLoad()
        setLaunchScreen()
        getMusicInfor()
        addObserverToDismissNotification()
        
        print("viewdidload ")
    }
    
    // MARK: - Setting View
    func setMusicPlayer(musicPlayer: AVAudioPlayer) {
        DispatchQueue.main.async { [self] in
            player = musicPlayer
            connectPlayerToMusicController()
            print("success")
        }
    }

    func setMusicView(_ image: UIImage) {
        DispatchQueue.main.async { [self] in
            musicView.setMusicView(musicFetcher.song)
            setLyricsView()
            addGestureToLyricsView()
            musicView.musicImageView.image = image
        }
    }
    
    func setLaunchScreen() {
        let image = UIImage(named: "flashImage")
        view.addSubview(launchImageView)
        launchImageView.image = image
        launchImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [launchImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             launchImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             launchImageView.topAnchor.constraint(equalTo: view.topAnchor),
             launchImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.launchImageView.alpha = 0.0
                } completion: { complete in
                    self.launchImageView.removeFromSuperview()
                }
            }
        }
    }
    
    func setLyricsView() {
        guard let song = musicFetcher.song else { return }
        lyricsView.fontSize = UIFont.preferredFont(forTextStyle: .callout)
        lyricsView.lyrics = song.lyrics
        lyricsView.alignmentType = .center
        lyricsView.dataSource = self
        lyricsView.reloadData()
        
        lyricsViewController.lyricsTableView.fontSize = UIFont.preferredFont(forTextStyle: .title3)
        lyricsViewController.lyricsTableView.alignmentType = .left
        lyricsViewController.lyricsTableView.lyrics = song.lyrics
    }
    
    func addGestureToLyricsView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentLyricViewConrtoller))
        lyricsView.addGestureRecognizer(gesture)
        lyricsView.isUserInteractionEnabled = true
    }
    
    // MARK: - Action
    /// `MusicPlayer` 및 `MusicImage` 가져오기
    func getMusicInfor() {
        musicFetcher.getMusic { audioResult in
            switch audioResult {
            case .success(let player):
                self.setMusicPlayer(musicPlayer: player)
            case .failure(let error):
                print(error)
            }
            
        } imageCompletion: { imageResult in
            switch imageResult {
            case .success(let image):
                self.setMusicView(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// MusicController에게 `player`, `lyricsView` 할당하기
    func connectPlayerToMusicController() {
        musicController.player = player
        musicController.lyricsView = lyricsView
        musicController.durationTimeLabel.text = convertToString(by: player?.duration)
    }
    
    /// `LyricsViewController` (큰 가사) 띄우기
    @objc func presentLyricViewConrtoller() {
        prepareLyricsViewController()
        present(lyricsViewController, animated: true, completion: nil)
    }
    
    /// `LyricsViewController` 준비하기
    /// musicController 그대로 재사용
    func prepareLyricsViewController() {
        musicController.lyricsView = lyricsViewController.lyricsTableView
        lyricsViewController.musicController = musicController
        lyricsViewController.setConstraint()
        lyricsViewController.transitioningDelegate = self
        lyricsViewController.modalPresentationStyle = .custom
    }
    
    /// `LyricsViewController` 사라질때 감지하기
    /// musicController다시 재사용
    func addObserverToDismissNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dismissLyrics"), object: nil, queue: .main) { [self] notification in
            guard let _ = notification.userInfo?["dismissLyrics"] as? Bool else { return }
            musicController.currentTimeLabel.isHidden = false
            musicController.durationTimeLabel.isHidden = false
            stackView.addArrangedSubview(musicController)
            musicController.lyricsView = lyricsView
            NSLayoutConstraint.activate(
                [musicController.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2)])
            view.layoutIfNeeded()
        }
    }
}

// MARK: - TableView DataSource, Delegate
extension MusicViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyricsView.numberOfRows(inSection: 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return lyricsView.cellForRow(at: indexPath)
    }
}

// MARK: - Transition Delegate
extension MusicViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition.isMusicView = false
        return animationTransition
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition.isMusicView = true
        return animationTransition
    }
}
