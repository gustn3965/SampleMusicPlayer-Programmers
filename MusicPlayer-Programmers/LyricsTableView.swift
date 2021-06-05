//
//  LyricsTableView.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit

class LyricsTableView: UITableView {
    
    typealias Lyrics = (text: String, time: Double)
    
    let cellIdentifier: String =  "lyricsCell"
    var lyrics: [Lyrics] = []
    var alignmentType: NSTextAlignment = .center
    var fontSize: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var isAvailableForTouchCell = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isTouchable"), object: nil, userInfo: ["isTouchable": isAvailableForTouchCell])
        }
    }
    
    // MARK: - init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerCell()
    }
    
    // MARK: - method
    func registerCell() {
        register(LyricsCell.self, forCellReuseIdentifier: cellIdentifier)
        rowHeight = UITableView.automaticDimension
        separatorStyle = .none
        isScrollEnabled = false 
    }
    
    func moveCell(by curTime: Double) {
        for i in 1..<lyrics.count {
            let time = lyrics[i].time
            if time >= curTime {
                let indexPath = IndexPath(row: time<=curTime ? i : i-1, section: 0)
                selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                break
            }
            if i == lyrics.count - 1 {
                selectRow(at: IndexPath(row: lyrics.count-1, section: 0), animated: true, scrollPosition: .middle)
            }
        }
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier) as? LyricsCell else { return UITableViewCell() }
        cell.setLyricsView(with: lyrics[indexPath.row].text,
                           time: lyrics[indexPath.row].time,
                           alignType: alignmentType,
                           font: fontSize)
        return cell
        
    }
    override func numberOfRows(inSection section: Int) -> Int {
        return lyrics.count
    }
}
