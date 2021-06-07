//
//  MusicFetcher.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/03.
//

import Foundation
import AVFoundation
import UIKit.UIImage

enum MusicFetcherError: Error {
    case invalidURL
    case invalidPlayer
    case invalidImage
    case invalidJSON
}

// URL을 통하여 음악플레이어 및 이미지를 가져오는 객체
class MusicFetcher {
    typealias SongResult = Result<Song, MusicFetcherError>
    typealias AudioResult = Result<AVAudioPlayer, MusicFetcherError>
    typealias ImageResult = Result<UIImage, MusicFetcherError>
    
    var songFetcher = SongFetcher()
    var song: Song?
    
    func getSongData(_ completion: @escaping (SongResult) -> Void ) {
        songFetcher.getSong { songResult in
            switch songResult {
            case .success(let song):
                self.song = song
                completion(.success(song))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
    
    func getMusic( audioCompletion: @escaping ((AudioResult) -> Void),
                   imageCompletion: ((ImageResult) -> Void)?)  {
        
        getSongData { songResult in    
            switch songResult {
            case .success(let song): print()
                self.getMusicPlayer(url: song.file) { audioResult in
                    switch audioResult {
                    case .success(let player):
                        audioCompletion(.success(player))
                    case .failure(let error):
                        audioCompletion(.failure(error))
                    }
                }
                self.getMusicImage(url: song.image) { imageResult in
                    switch imageResult {
                    case .success(let image):
                        imageCompletion?(.success(image))
                    case .failure(let error):
                        imageCompletion?(.failure(error))
                    }
                }
                
            case .failure(let error):
                audioCompletion(.failure(error))
            }
        }
    }
    
    func getMusicPlayer(url: String, _ completion: @escaping ((AudioResult) -> Void )) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let player = try AVAudioPlayer(data: data)
                completion(.success(player))
            } catch {
                completion(.failure(.invalidPlayer))
            }
        }
    }
    
    func getMusicImage(url: String, _ completion: ((ImageResult) -> Void )?) {
        guard let url = URL(string: url) else {
            completion?(.failure(.invalidURL))
            return 
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let imagenil = UIImage(data: data)
                guard let image = imagenil else {
                    completion?(.failure(.invalidImage))
                    return 
                }
                completion?(.success(image))
            } catch {
                completion?(.failure(.invalidImage))
            }
        }
    }
}
