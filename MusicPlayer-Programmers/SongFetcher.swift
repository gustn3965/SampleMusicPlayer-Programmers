//
//  SongFetcher.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import Foundation




class SongFetcher {
    typealias SongResult = Result<Song, MusicFetcherError>
    var songURL: String?
    
    init(url: String = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json") {
        songURL = url 
    }

    func getSong(_ completion: @escaping ((SongResult) -> Void ))  {
        guard let str = songURL, let url = URL(string: str) else {  completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let song = try JSONDecoder().decode(Song.self, from: data)
                completion(.success(song))
            } catch {
                completion(.failure(.invalidJSON))
            }
        }
    }
}
