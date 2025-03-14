//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation
import Combine

protocol ViewModelInput {
    func setupMusicObservable(onError: @escaping (String) -> Void, receiveValue: @escaping ([Music]) -> Void)
    func setupProgressObservable(onChange: @escaping (Double, Double) -> Void)
    func fetchMusicData(artisName: String?)
    func setSelectedIndex(index: IndexPath?)
    func startPlaySong()
    func playOrPause()
}

protocol ViewModelOutput{
    func getMusicList() -> [Music]
    func getSelectedIndex() -> IndexPath?
}

protocol DefaultViewModel: ViewModelInput, ViewModelOutput {
    var cancellables: Set<AnyCancellable> { get }
}

public class ViewModel: DefaultViewModel {
    private var selectedIndex: IndexPath?
    private var audioManager = AudioManager.shared
    
    var cancellables: Set<AnyCancellable> = []
    var iTunesMusicUseCase: iTunesMusicUseCaseProtocol = iTunesMusicUseCaseImpl.shared
    
    public init() {}
    
    func setupMusicObservable(onError: @escaping (String) -> Void, receiveValue: @escaping ([Music]) -> Void) {
        iTunesMusicUseCase.getMusicListObservable()
        .sink { result in
            switch result {
            case .success(let music):
                receiveValue(music)
            case .failure(let err):
                onError(err.localizedDescription)
            case .none:
                break
            }
        }.store(in: &cancellables)
    }
    
    func setupProgressObservable(onChange: @escaping (Double, Double) -> Void) {
        audioManager.getProgressPublisher().sink { (progress, duration) in
            onChange(progress, duration)
        }.store(in: &cancellables)
    }
    
    public func fetchMusicData(artisName: String? = nil) {
        iTunesMusicUseCase.getMusicDataWithArtist(artistName: artisName)
    }
    
    public func getMusicList() -> [Music] {
        switch iTunesMusicUseCase.getMusicListObservable().value {
        case .success(let music):
            return music
        case .failure(let err):
            print("error in getting music list: \(err.localizedDescription)")
            return []
        case .none:
            return []
        }
    }
    
    func setSelectedIndex(index: IndexPath?) {
        selectedIndex = index
    }
    
    func getSelectedIndex() -> IndexPath? {
        return selectedIndex
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
    
    func startPlaySong() {
        audioManager.play(from: getMusicList()[selectedIndex!.row].previewUrl ?? "")
    }
    
    func playOrPause() {
        audioManager.playPause()
    }
}

