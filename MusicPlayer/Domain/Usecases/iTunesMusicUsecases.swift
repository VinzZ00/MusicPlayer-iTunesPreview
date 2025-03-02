//
//  iTunesMusicUsecases.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation
import Combine

protocol iTunesMusicUseCaseOutput {
    func getMusicListObservable() -> CurrentValueSubject<[Music], Error>
}

protocol iTunesMusicUseCaseInput {
    func getMusicData()
    func getMusicDataWithArtist(artistName: String?) 
}

protocol iTunesMusicUseCaseProtocol: iTunesMusicUseCaseInput, iTunesMusicUseCaseOutput {}

class iTunesMusicUseCaseImpl : iTunesMusicUseCaseProtocol {
    
    private init() {}
    
    public static let shared = iTunesMusicUseCaseImpl()
    
    private let musicListObservable = CurrentValueSubject<[Music], Error>([])
    private let iTunesRepository: iTunesRepo = iTunesRepo()
    
    func getMusicData() {
        iTunesRepository.fetchMusic { result in
            switch result {
            case .success(let music):
                self.musicListObservable.send(music)
            case .failure(let err):
                self.musicListObservable.send(completion: .failure(err))
            }
        }
    }
    
    func getMusicDataWithArtist(artistName: String? = nil) {
        iTunesRepository.fetchMusic(artistName: artistName) { result in
            switch result {
            case .success(let music):
                self.musicListObservable.send(music)
            case .failure(let err):
                self.musicListObservable.send(completion: .failure(err))
            }
        }
    }
    
    func getMusicListObservable() -> CurrentValueSubject<[Music], any Error> {
        return musicListObservable
    }
}
