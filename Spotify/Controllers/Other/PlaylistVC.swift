//
//  PlaylistVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

class PlaylistVC: UIViewController {
    private let playlist : Playlist
    private var PlaylistViewModels = [PlaylistTrackViewModel]()
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
        return PlaylistVC.createCollectionSectionLayout(section : section)
    }))
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        self.view.backgroundColor = .systemBackground
        fetchPlaylistData()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(PlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.register(PlaylistCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistCollectionReusableView.identifier)
        //delegation
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchPlaylistData(){
        APICaller.shared.getPlaylistDetails(id: playlist.id) {[weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.PlaylistViewModels = model.tracks.items.compactMap({
                        PlaylistTrackViewModel(trackName: $0.track?.name ?? "", artist: $0.track!.artists, trackCoverUrl: URL(string: $0.track?.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
  
    
    private static func createCollectionSectionLayout(section: Int) -> NSCollectionLayoutSection
    {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension:.absolute(100)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
        // group
        let verticalGroup = NSCollectionLayoutGroup
            .vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)),
                subitem: item,
                count: 1
            )
        //section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500)), elementKind: UICollectionView.elementKindSectionHeader
            , alignment: .top
        )]
        return section
    }

}


extension PlaylistVC : UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaylistViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaylistCollectionViewCell.identifier,
            for: indexPath
        ) as? PlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(viewModel: PlaylistViewModels[indexPath.row])
        return cell
    }
    
    // header of the collection View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:PlaylistCollectionReusableView.identifier , for: indexPath) as? PlaylistCollectionReusableView,  kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        let headerViewModel = configureHeaderViewModel()
        header.configure(viewModel: headerViewModel)
        header.delegate = self
        return header
    
    }
    
    
    func configureHeaderViewModel() -> PlaylistHeaderViewModel {
        let viewModel = PlaylistHeaderViewModel(
            name: playlist.name ,
            description: playlist.description,
            playlistCoverURL: URL(string: playlist.images.first?.url ?? ""),
            ownerName: playlist.owner.display_name
        )
        
        return viewModel
    }
    
}

extension PlaylistVC: PlaylistCollectionReusableViewDelegate {

    
    func PlaylistCollectionReusableViewPlayAllTracks(_ header: PlaylistCollectionReusableView) {
        print("Playing all")
    }
    
    
}
