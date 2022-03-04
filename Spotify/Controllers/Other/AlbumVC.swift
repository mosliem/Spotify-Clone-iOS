//
//  AlbumVC.swift
//  Spotify
//
//  Created by mohamedSliem on 2/26/22.
//

import UIKit

class AlbumVC: UIViewController {
    
    private let album : Album
    private var albumViewModels = [AlbumTrackViewModel]()
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    private let collectionView :UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout:UICollectionViewCompositionalLayout(
            
            sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
                
                return AlbumVC.createAlbumCollectionView(section: section)
                
            }))
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        fetchData()
        configureCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetchData(){
        APICaller.shared.getAlbumDetails(id: album.id) { result in
            switch result{
            case .success(let model):
                self.configureViewModels(model : model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCollectionView(){
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            AlbumCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier
        )
        
        collectionView.register(
            AlbumCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AlbumCollectionReusableView.identifier
        )
    }
    private func configureViewModels(model : AlbumDetailsResponse){
        DispatchQueue.main.async {
            self.albumViewModels = model.tracks.items.compactMap({
                AlbumTrackViewModel(trackName: $0.name, artists: $0.artists)
            })
            self.collectionView.reloadData()
        }
    }
    
    
    private static func createAlbumCollectionView(section : Int)->NSCollectionLayoutSection{
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


extension AlbumVC : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albumViewModels.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumCollectionViewCell.identifier,
                for: indexPath) as? AlbumCollectionViewCell
        else{
            return UICollectionViewCell()
        }
        
        cell.configureViewModel(viewModel: albumViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumCollectionReusableView.identifier, for: indexPath) as? AlbumCollectionReusableView else {
            return UICollectionReusableView()
        }
        let headerViewModel = configureHeaderViewModel()
        header.ConfigureHeaderViewModel(viewModel:headerViewModel)
        header.delegate = self
        return header
    }
    func configureHeaderViewModel() -> AlbumHeaderViewModel{
        let viewModel = AlbumHeaderViewModel(
            albumName: album.name,
            playlistCoverURL: URL(string: album.images.first?.url ?? ""),
            realesedDate: String.formattedDate(dateString: album.release_date),
            artist: album.artists
        )
        return viewModel
    }
    
}


extension AlbumVC : AlbumCollectionReusableViewDelegate{
    func AlbumCollectionReusableViewDelegate(_ header: AlbumCollectionReusableView) {
        print("play")
    }
    
    
}
