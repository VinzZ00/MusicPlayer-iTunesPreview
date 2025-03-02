//
//  iTunesRepository.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation

class iTunesRepo {
    func fetchMusic(artistName: String? = nil, completion: @escaping (Result<[Music], Error>) -> Void) {
        var url: URL?
        if let artistName = artistName {
            url = URL(string: "https://itunes.apple.com/search?term=\(artistName)&media=music&limit=50")
        } else {
            url = URL(string: "https://itunes.apple.com/search?term=music&media=music&limit=50")
        }
        
        if let url {
            NetworkManager.shared.fetchData(url: url) { (result: Result<MusicListDTO, Error>) in
                switch result {
                case .success(let musicListDTO):
                    if let music = musicListDTO.results?.map({ musicDTO in
                        Music(from: musicDTO)
                    }) {
                        completion(.success(music))
                    }
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            return completion(.failure(NSError.invalidUrl))
        }
    }
}
