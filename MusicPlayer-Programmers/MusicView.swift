//
//  MusicView.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import UIKit
import AVFoundation

class MusicView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var musicImageView: UIImageView!

    var song: Song?
    
    // MARK: - method
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        
    }
    
    func loadView() {
        let bundle = Bundle(for: MusicView.self)
        let nib = UINib(nibName: "MusicView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setMusicView(_ song: Song? ) {
        guard let song = song else { return }
        self.song = song 
        titleLabel.text = song.title
        albumLabel.text = song.album
        singerLabel.text = song.singer
        musicImageView.layer.cornerRadius = 30.0
        musicImageView.layer.masksToBounds = true
        musicImageView.clipsToBounds = true
    }
}
