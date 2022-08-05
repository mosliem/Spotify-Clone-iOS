//
//  CategoryResultsVC.swift
//  Spotify
//
//  Created by mohamedSliem on 3/6/22.
//

import UIKit

class CategoryResultsVC : UIViewController {
    
    private let resultCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
        return CategoryResultsVC.createResultCollectionView(section : section)
    }))
    
    private var category: Category
    private var playlist : [Playlist] = []
    private var playlistViewModel = [PlaylistViewModel]()
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        configureCollectionView()
        fetchCategoryData()
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        resultCollectionView.frame = view.bounds
    }

    
   //MARK:- Private Functions
    
    private func configureCollectionView(){
        self.view.addSubview(resultCollectionView)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.identifier)
        
    }
    private static func createResultCollectionView(section :Int)->NSCollectionLayoutSection {
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
        return section
    }
    
    
    private func fetchCategoryData(){
        APICaller.shared.getCategoryDetails(CategoryId: category.id) { (result) in
            switch result {
            case.success(let model):
                self.playlist = model.playlists.items
                self.configureCategoryViewModel(model : model)
            case .failure(let erorr):
                print(erorr)
            }
        }
    }
    
    private func configureCategoryViewModel(model : CategoriesPlaylistResponse){
        DispatchQueue.main.async {
            self.playlistViewModel = model.playlists.items.compactMap({
                PlaylistViewModel(playlistName: $0.name, playlistImageUrl: URL(string: $0.images.first?.url ?? ""), ownerName: $0.owner.display_name)
            })
            self.resultCollectionView.reloadData()
        }
    }
}


//MARK:- CollectionView Delegate

extension CategoryResultsVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else{
            return UICollectionViewCell()
        }
        cell.configure(on: playlistViewModel[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            cell?.alpha = 1
        }
        let vc = PlaylistVC(playlist: playlist[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
}




    

