//
//  LyricsViewController.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit

class LyricsViewController: UIViewController {

    var lyricsTableView: LyricsTableView = LyricsTableView()
    var musicController: MusicControllerView?
    var syncButton: UIButton = UIButton()
    var closeButton: UIButton = UIButton()
    var buttonStack: UIStackView = UIStackView()
    var dismissGesture: UITapGestureRecognizer?
    
    // MARK: - method
    override func viewDidLoad() {
        super.viewDidLoad()
        lyricsTableView.dataSource = self
        lyricsTableView.isScrollEnabled = true 
        addButton()
        addDismissGestureToView()
    }
    
    func setConstraint() {
        guard let musicController = musicController else { return }
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lyricsTableView)
        stackView.addArrangedSubview(musicController)
        stackView.axis = .vertical
        musicController.currentTimeLabel.isHidden = true
        musicController.durationTimeLabel.isHidden = true
        musicController.isHidden = false

        stackView.alignment = .fill
        stackView.distribution = .fill
        NSLayoutConstraint.activate(
            [stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             stackView.topAnchor.constraint(equalTo: view.topAnchor)])
        view.bringSubviewToFront(buttonStack)
        
    }
    
    func addButton() {
        buttonStack = UIStackView(arrangedSubviews: [createCloseButton(), createSyncButton()])
        view.addSubview(buttonStack)
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
             buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)])
    }
    
    func createCloseButton() -> UIButton {
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill")?.middImage(), for: .normal)
        return closeButton
    }

    func createSyncButton() -> UIButton  {
        syncButton.tintColor = .gray
        syncButton.addTarget(self, action: #selector(clickSyncButton), for: .touchUpInside)
        syncButton.setImage(UIImage(systemName: "chart.bar.doc.horizontal.fill")?.middImage(), for: .normal)
        return syncButton
    }
    
    func addDismissGestureToView() {
        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(dismissGesture!)
    }
    
    @objc func dismissViewController() {
        musicController?.removeFromSuperview()
        syncButton.tintColor = .gray
        lyricsTableView.isAvailableForTouchCell = false
        NotificationCenter.default.post(name: NSNotification.Name("dismissLyrics"), object: nil, userInfo: ["dismissLyrics": true])
        if let gesture = dismissGesture, let gestures = view.gestureRecognizers, !gestures.contains(gesture) {
            view.addGestureRecognizer(gesture)
        }   
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 가사터치 이동가능한 `토글버튼` 클릭시
    @objc func clickSyncButton() {
        lyricsTableView.isAvailableForTouchCell = !lyricsTableView.isAvailableForTouchCell
        syncButton.tintColor = lyricsTableView.isAvailableForTouchCell ? #colorLiteral(red: 0.278427422, green: 0.2785167396, blue: 1, alpha: 1)
            : .gray

        if lyricsTableView.isAvailableForTouchCell {
            guard let gesture = dismissGesture else { return }
            view.removeGestureRecognizer(gesture)
        } else {
            addDismissGestureToView()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}

// MARK: -  Table View DataSource 
extension LyricsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyricsTableView.numberOfRows(inSection: 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return lyricsTableView.cellForRow(at: indexPath)
    }
}
