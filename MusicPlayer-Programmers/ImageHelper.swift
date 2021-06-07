//
//  Image+Helper.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/05.
//

import UIKit.UIImage


extension UIImage {
    
    func middImage() -> UIImage  {
        let middleConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        return withConfiguration(middleConfig)
    }
}

