//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 28/02/25.
//

import UIKit
import MediaPlayer

class MusicListViewController: UIViewController {
    
    let searchTextField: CustomTextField = CustomTextField()
    let headerView: UIView = UIView()
    
    let songList: UITableView = UITableView()
    let musicPanel: MusicPanelView = MusicPanelView()
    
    let body: UIStackView = UIStackView()
    
    static func createModule() -> UIViewController {
        return MusicListViewController(viewModel: ViewModel())
    }
    
    init(viewModel: DefaultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: DefaultViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewConfig()
        setupHierarchy()
        setupConstraint()
        setupStyle()
        setupObservable()
    }
    
    private func setupHierarchy() {
        self.view.autoLayoutSubViews {
            headerView.autoLayoutSubViews {
                searchTextField
            }
            body.addArrangedSubViewDSL {
                songList
            }
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate {
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
            searchTextField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
            searchTextField.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
            searchTextField.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24)
            searchTextField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -24)
            
            body.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            body.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            body.topAnchor.constraint(equalTo: headerView.bottomAnchor)
            body.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
    }
    
    private func setupObservable() {
        viewModel.setupMusicObservable { [weak self] locErr in
            self?.showSnackbar(message: locErr)
        } receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.viewModel.setSelectedIndex(index: nil)
                self?.songList.reloadData()
            }
        }
        
        viewModel.setupProgressObservable { [weak self] progress, duration in
            guard let self else { return }
            if duration != 0 {
                self.musicPanel.setSliderValue(value: Float(progress / duration))
                if progress == duration {
                    let prevIndex = self.viewModel.getSelectedIndex() ?? IndexPath(row: 0, section: 0)
                    self.viewModel.setSelectedIndex(index: nil)
                    self.musicPanel.removeFromSuperview()
                    self.songList.reloadRows(at: [prevIndex], with: .automatic)
                }
            } else {
                self.musicPanel.setSliderValue(value: 0)
            }
        }
        
    }
    
    private func setupStyle() {
        headerView.backgroundColor = .headerBackground
        
        searchTextField.placeholder = "Search For Artist"
        searchTextField.textAlignment = .center
        searchTextField.backgroundColor = .searchBarBackground
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.returnKeyType = .done
        
        body.axis = .vertical
        body.distribution = .fill
        body.spacing = 0
    }
    
    private func viewConfig() {
        searchTextField.delegate = self
        songList.delegate = self
        songList.dataSource = self
        songList.register(MusicCell.self, forCellReuseIdentifier: MusicCell.identifier)
        songList.allowsMultipleSelection = false
        musicPanel.setDelegate(delegate: self)
        (viewModel as? ViewModel)?.fetchMusicData()
    }
}

// MARK: UITextField setup
extension MusicListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.fetchMusicData(artisName: textField.text ?? "")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func selectSong(at index: IndexPath) {
        musicPanel.setThumbnailImage(imageUrl: viewModel.getMusicList()[index.row].artWorkUrl ?? "")
        musicPanel.setPlayOrPauseImage(isPlaying: false)
        viewModel.startPlaySong()
    }
}

//MARK: UITableView setup
extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getMusicList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as! MusicCell
        cell.setupData(song: viewModel.getMusicList()[indexPath.row])
        cell.setPlayingState(isPlaying: indexPath == viewModel.getSelectedIndex())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let prevIndex = viewModel.getSelectedIndex() {
            viewModel.setSelectedIndex(index: indexPath)
            tableView.reloadRows(at: [prevIndex, indexPath], with: .automatic)
        } else {
            viewModel.setSelectedIndex(index: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        selectSong(at: indexPath)
        body.addArrangedSubview(musicPanel)
    }
}

extension MusicListViewController: MusicPanelDelegate {
    func onTapPlayPause() {
        musicPanel.setPlayOrPauseImage(isPlaying: AudioManager.shared.isPlaying())
        viewModel.playOrPause()
    }
    
    func onTapNext() {
        if let index = viewModel.getSelectedIndex(),
           index.row < viewModel.getMusicList().count - 1
        {
            let nextIndex = IndexPath(row: index.row + 1, section: index.section)
            if nextIndex.row < viewModel.getMusicList().count {
                viewModel.setSelectedIndex(index: nextIndex)
                songList.reloadRows(at: [index, nextIndex], with: .automatic)
                viewModel.setSelectedIndex(index: nextIndex)
                selectSong(at: nextIndex)
            }
        } else {
            let index = viewModel.getSelectedIndex() ?? IndexPath(row: 0, section: 0)
            viewModel.setSelectedIndex(index: index)
            selectSong(at: index)
        }
    }
    
    func onTapRewind() {
        if let index = viewModel.getSelectedIndex(),
           index.row > 0 {
            let prevIndex = IndexPath(row: index.row - 1, section: index.section)
            viewModel.setSelectedIndex(index: prevIndex)
            songList.reloadRows(at: [index, prevIndex], with: .automatic)
            viewModel.setSelectedIndex(index: prevIndex)
            selectSong(at: prevIndex)
        } else {
            let index = viewModel.getSelectedIndex() ?? IndexPath(row: 0, section: 0)
            viewModel.setSelectedIndex(index: index)
            selectSong(at: index)
        }
    }
}
