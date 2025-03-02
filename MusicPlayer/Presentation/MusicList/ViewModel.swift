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
    func rewindSong()
    func nextSong()
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
    
    
    func setupMusicObservable(onError: @escaping (String) -> Void, receiveValue: @escaping ([Music]) -> Void) {
        iTunesMusicUseCase.getMusicListObservable().sink { completion in
            switch completion{
            case .finished:
                break
            case .failure(let err):
                onError(err.localizedDescription)
            }
        } receiveValue: { music in
            receiveValue(music)
        }.store(in: &cancellables)
    }
    
    func setupProgressObservable(onChange: @escaping (Double, Double) -> Void) {
        audioManager.getProgressPublisher().sink { (progress, duration) in
            onChange(progress, duration)
        }.store(in: &cancellables)
    }
    
    func fetchMusicData(artisName: String? = nil) {
        iTunesMusicUseCase.getMusicDataWithArtist(artistName: artisName)
    }
    
    func getMusicList() -> [Music] {
        return iTunesMusicUseCase.getMusicListObservable().value
    }
    
    func setSelectedIndex(index: IndexPath?) {
        selectedIndex = index
    }
    
    func getSelectedIndex() -> IndexPath? {
        return selectedIndex
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() } // Cancel all the subscriptions
    }
    
    func startPlaySong() {
        audioManager.play(from: getMusicList()[selectedIndex!.row].previewUrl ?? "")
    }
    
    func playOrPause() {
        audioManager.playPause()
    }
    
    func rewindSong() {
        
    }
    
    func nextSong() {
        
    }
}

