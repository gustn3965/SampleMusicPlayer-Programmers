//
//  MusicPlayer_ProgrammersTests.swift
//  MusicPlayer-ProgrammersTests
//
//  Created by hyunsu on 2021/06/03.
//

import XCTest
@testable import MusicPlayer_Programmers

class MusicPlayer_ProgrammersTests: XCTestCase {
    
    func test_url을통해_Song_json을_가져올수있다() {
        let songFetcher = SongFetcher()
        songFetcher.songURL = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        timeout(4) { exp in
            songFetcher.getSong { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            
        }
    }
    
    func test_url을통해_mp3파일을_가져올수있다() {
        let musicFetcher = MusicFetcher()
        let fileURL = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3"
        timeout(4) { exp in
            musicFetcher.getMusicPlayer(url: fileURL, { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail("No music player")
                }
            })
            
        }
    }
    
    func test_url을통해_image커버를_가져올수있다() {
        let musicFetcher = MusicFetcher()
        let imageURL = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/cover.jpg"
        timeout(4) { exp in
            musicFetcher.getMusicImage(url: imageURL, { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail("No music player")
                }
            })
            
        }
    }
    
    func test_url을통해_mp3파일_가져오는데_몇초걸리는지() {
        let musicFetcher = MusicFetcher()
        let startTime = CFAbsoluteTimeGetCurrent()
        
        timeout(4) { exp in
            musicFetcher.getMusic(audioCompletion: { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    let processTime = CFAbsoluteTimeGetCurrent() - startTime
                    print(" 🔥 걸린 시간 = \(processTime) 🔥")
                case .failure(let error):
                    XCTFail("No music player")
                }
            }, imageCompletion: nil)
        }
    }
    
    
    
}

extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        completion(exp)
        
        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
}
