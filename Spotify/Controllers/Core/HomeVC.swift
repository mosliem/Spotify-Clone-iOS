//
//  ViewController.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

enum BrowseSectionType{
    case newRealeses(viewModel : [NewRealesesViewModel])
    case featuredPlaylists(viewModel : [PlaylistViewModel])
    case recommendedTracks(viewModel : [RecommendationViewModel])
    
    var title:String{
        switch self {
        case .newRealeses:
            return "New Realeses"
        case .featuredPlaylists:
            return "Featured playlists"
        case .recommendedTracks:
            return "Recommendations"
        }
    }
}

class HomeVC: UIViewController {
    
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
                print("collection\(section)")
                return HomeVC.createSectionLayout(section: section)
            }))
    
    
    private var sections = [BrowseSectionType]()
    private var newAlbums :[Album] = []
    private var playlists : [Playlist] = []
    private var tracks : [AudioTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        fetchData()
        configureCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView(){
        print("CollectionView Configured")
        self.view.addSubview(collectionView)
        
        collectionView.register(NewRealesesCell.self,
                                forCellWithReuseIdentifier: NewRealesesCell.identifier)
        collectionView.register(PlaylistCell.self,
                                forCellWithReuseIdentifier: PlaylistCell.identifier)
        collectionView.register(RecommendedTrackCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCell.identifier)
        collectionView.register(HomeSectionTitles.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionTitles.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    private func fetchData()
    {
        var newAlbumRealeses : NewRealesesResponse?
        var recommendations : RecommendationResponse?
        var featuredPlaylist : FeaturedPlaylistResponse?
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getNewAlbumRealeses { (result) in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model) :
                newAlbumRealeses = model
                break
            case .failure(let error) :
                print(error.localizedDescription)
                break
            }
        }
        
        APICaller.shared.getRecommendations { (result) in
            
            defer {
                group.leave()
            }
            switch result {
            case.success(let model) :
                recommendations = model
                break
            case .failure(let error) :
                print(error.localizedDescription)
                break
            }
            
        }
        APICaller.shared.getFeaturesPlaylist { (result) in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model) :
                featuredPlaylist = model
                break
            case .failure(let error) :
                print(error.localizedDescription)
                break
            }
        }
        group.notify(queue: .main)
        {
            guard let albums = newAlbumRealeses?.albums.items,
                  let tracks = recommendations?.tracks,
                  let playlists = featuredPlaylist?.playlists.items
            else{
                fatalError("notify")
                self.fetchData()
            }
            
            self.configureModels(newAlbums: albums, tracks: tracks, playlists: playlists)
        }
        
        
    }
    
    
    private func configureModels(
        newAlbums: [Album] ,
        tracks : [AudioTrack] ,
        playlists : [Playlist]
    )
    {
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        sections.append(.newRealeses(viewModel: newAlbums.compactMap({
            
            return NewRealesesViewModel(name: $0.name,
                                        artWorkURL: URL(string : $0.images.first?.url ?? "")
                                        , numberOfTracks: $0.total_tracks,
                                        artistName: $0.artists.first?.name ?? " ")
        })))
        
        sections.append(.featuredPlaylists(viewModel: playlists.compactMap({
            
            return PlaylistViewModel(playlistName: $0.name, playlistImageUrl: URL(string:$0.images.first?.url ?? "") , ownerName: $0.owner.display_name )
        })))
        
        
        sections.append(.recommendedTracks(viewModel: tracks.compactMap({
            return RecommendationViewModel(albumName: $0.album?.name ?? "" , artist: $0.artists,  albumCoverUrl: URL(string: $0.album?.images.first?.url ?? " "))
        })))
        print("configure models")
        collectionView.reloadData()
    }
    
    
    
    // settings Button
    @objc func didTapSettings()
    {
        let vc = SettingVC()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Collection View Delegation
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .newRealeses(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        
        case .newRealeses(let viewModels):
            guard let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: NewRealesesCell.identifier,
                        for: indexPath
                    ) as? NewRealesesCell
            else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configureData(on: viewModel)
            cell.layer.cornerRadius = 10
            return cell
            
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: PlaylistCell.identifier,
                        for: indexPath
                    ) as? PlaylistCell
            else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 10
            let viewModel = viewModels[indexPath.row]
            cell.configure(on: viewModel)
            return cell
            
            
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: RecommendedTrackCell.identifier,
                        for: indexPath
                    ) as? RecommendedTrackCell
            else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(viewModel: viewModel)
            return cell
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        
        case .newRealeses :
            let album =  newAlbums[indexPath.row]
            let vc = AlbumVC(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .featuredPlaylists :
            let playlist = playlists[indexPath.row]
            let vc = PlaylistVC(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recommendedTracks:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionTitles.identifier, for: indexPath) as? HomeSectionTitles  , kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        header.configure(title: sections[indexPath.section].title)
        return header
    }
    // creates the collection view for (new Realeses, featured playlists and recommendation)
    private static func createSectionLayout(section : Int) -> NSCollectionLayoutSection
    {
        
        let sectionHeaders = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
        // item
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension:.absolute(120)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 3 , bottom: 4, trailing: 3)
            
            // group
            let verticalGroup = NSCollectionLayoutGroup
                .vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(240)),
                    subitem: item,
                    count: 2
                )
            
            let horizontalGroup = NSCollectionLayoutGroup
                .horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        
                        widthDimension: .fractionalWidth(0.97),
                        heightDimension: .absolute(240)),
                    subitem: verticalGroup,
                    count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = sectionHeaders
            return section
            
        // featured playlists
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.absolute(200),
                    heightDimension:.absolute(260)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // group
            let horizontalGroup = NSCollectionLayoutGroup
                .horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.98),
                        heightDimension: .absolute(260)),
                    subitem: item,
                    count: 2)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = sectionHeaders
            return section
            
            
        // recommended TRACKS
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.absolute(200),
                    heightDimension:.absolute(260)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 3, bottom: 6, trailing: 3)
            
            // group
            let horizontalGroup = NSCollectionLayoutGroup
                .horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.98),
                        heightDimension: .absolute(260)),
                    subitem: item,
                    count: 2)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = sectionHeaders
            return section
            
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.absolute(100)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitem: item, count: 3)
            //section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        }
        
    }
    
}
