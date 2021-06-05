//
//  LyricsCell.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit

class LyricsCell: UITableViewCell {
    
    var fontSize: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var alignType: NSTextAlignment = .center
    var stackView: UIStackView = UIStackView()
    var lyricsLabel: UILabel = UILabel()
    var time: Double?
    var touchGesture: UITapGestureRecognizer?
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        addObserverNotifcation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
        addObserverNotifcation()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        lyricsLabel.textColor = selected ? .label : .systemGray3
    }

    // MARK: - Method
    private func setView() {
        selectionStyle = .none
        stackView.addArrangedSubview(lyricsLabel)
        lyricsLabel.font = fontSize
        lyricsLabel.numberOfLines = 0
        lyricsLabel.textColor = .lightGray
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
             stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
             stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
             stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)]
        )
    }
    
    func addTouchGesture() {
        touchGesture = UITapGestureRecognizer(target: self, action: #selector(touchLabel))
        lyricsLabel.addGestureRecognizer(touchGesture!)
        
    }
    
    @objc func touchLabel() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "touchText"), object: nil, userInfo: ["touchText": time]))
    }
    
    func addObserverNotifcation() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "isTouchable"), object: nil, queue: .main) { notifcation in
            guard let isTouchable = notifcation.userInfo?["isTouchable"] as? Bool else { return }
            if isTouchable {
                self.addTouchGesture()
                self.lyricsLabel.isUserInteractionEnabled = true
            } else {
                guard let gesture = self.touchGesture else { return }
                self.lyricsLabel.removeGestureRecognizer(gesture)
                self.lyricsLabel.isUserInteractionEnabled = false
            }
        }
    }
    
    func setLyricsView(with text: String,
                       time: Double,
                       alignType: NSTextAlignment,
                       font: UIFont) {
        lyricsLabel.textAlignment = alignType
        lyricsLabel.text = text
        lyricsLabel.font = font
        self.time = time
        self.fontSize = font
    }
}
