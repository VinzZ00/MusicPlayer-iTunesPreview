//
//  iTunesMusicUsecases.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation
import Combine

protocol iTunesMusicUseCaseOutput {
    func getMusicListObservable() -> CurrentValueSubject<Result<[Music], Error>?, Never>
}

protocol iTunesMusicUseCaseInput {
    func getMusicData()
    func getMusicDataWithArtist(artistName: String?)
}

protocol iTunesMusicUseCaseProtocol: iTunesMusicUseCaseInput, iTunesMusicUseCaseOutput {}

class iTunesMusicUseCaseImpl : iTunesMusicUseCaseProtocol {
    
    private init() {}
    
    public static let shared = iTunesMusicUseCaseImpl()
    
    private var musicListObservable: CurrentValueSubject<Result<[Music], Error>?, Never> = CurrentValueSubject<Result<[Music], Error>?, Never>(nil)
    private let iTunesRepository: iTunesRepo = iTunesRepo()
    
    func getMusicData() {
        iTunesRepository.fetchMusic { result in
            switch result {
            case .success(let music):
                self.musicListObservable.send(.success(music))
            case .failure(let err):
                self.musicListObservable.send(.failure(err))
            }
        }
    }
    
    func getMusicDataWithArtist(artistName: String? = nil) {
        iTunesRepository.fetchMusic(artistName: artistName) { result in
            switch result {
            case .success(let music):
                self.musicListObservable.send(.success(music))
            case .failure(let err):
                self.musicListObservable.send(.failure(err))
            }
        }
    }
    
    func getMusicListObservable() -> CurrentValueSubject<Result<[Music], Error>?, Never> {
        return musicListObservable
    }
}
