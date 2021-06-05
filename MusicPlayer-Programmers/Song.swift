//
//  Song.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import Foundation

struct Song: Codable {
    var singer: String
    var album: String
    var title: String
    var duration: Int
    var image: String
    var file: String
    private var lyricsStr: String
    
    enum CodingKeys: String, CodingKey {
        case singer, album, title, duration, image, file
        case lyricsStr = "lyrics"
    }
    
    var lyrics: [(String, Double)]  {
        let arr = lyricsStr.split(separator: "\n")
        let result: [(String, Double)] = arr.map{
            var middle = $0.split(separator: "]")
            let text = middle[1]
            var middleTime = middle[0]
            middleTime.removeFirst()
            let timeList = middleTime.split(separator: ":").map{Int(String($0))!}
            var time = Double(timeList[0]*60 + timeList[1])
            time += (Double(timeList[2])/1000)
            return (String(text), time)
        }
        return result
    }
}

























