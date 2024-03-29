//
//  SearchVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit
import SafariServices

protocol SearchBarEditingDelegate : AnyObject {
    func ShowLoader(_ sender : SearchVC)
    func dismissLoader(_ sender : SearchVC)
}

class SearchVC: UIViewController {
 
//MARK:- UI Views
    private let searchController : UISearchController = {
        let searchVC = UISearchController(searchResultsController: SearchResultVC())
        searchVC.searchBar.placeholder = "Artists, Albums, Playlists"
        searchVC.searchBar.barStyle = .black
        searchVC.definesPresentationContext = true
        
        return searchVC
    }()
    
    private let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
            return SearchVC.createCategoryCollection(section: section)
        }))
        
    private var Category:[Category] = []
    private var categoryViewModel:[CategoryViewModel] = []
    
    private weak var searchEditingDelegate: SearchBarEditingDelegate?
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureCategoryCollection()
        configureSearchController()
        fetchCategoriesData()
    
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryCollectionView.frame = view.bounds
    }
    
    private func configureSearchController(){
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    //MARK:- Categories Functions
    private static func createCategoryCollection(section : Int) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 6 , leading: 6, bottom: 6, trailing: 6)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130)), subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        return section
   
    }
    
    private func fetchCategoriesData(){
        APICaller.shared.getCategories { (result) in
            switch result {
            case .success(let model):
                self.configureCategoryViewModel(model:model)
                self.Category = model.categories.items
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCategoryViewModel(model: CategoriesResponse){
      
        DispatchQueue.main.async {
            self.categoryViewModel = model.categories.items.compactMap({
                CategoryViewModel(categoryName: $0.name, categoryCover: URL(string: $0.icons.first?.url ?? ""))
            })
            self.categoryCollectionView.reloadData()
            
        }
    }
    private func configureCategoryCollection(){
        self.view.addSubview(self.categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        
        
        categoryCollectionView.backgroundColor = .systemBackground
        
    }
}



// Categories Collection View Delegates
extension SearchVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCategoryViewModel(indexPath: indexPath.row , viewModel: categoryViewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            cell?.alpha = 1
        }
        
        let vc = CategoryResultsVC(category: Category[indexPath.row])
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


//MARK:- SearchController Delegates Funcions
extension SearchVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let resultSearchController = searchController.searchResultsController as? SearchResultVC,
              let query = searchController.searchBar.text ,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultSearchController.delegate = self
        
        APICaller.shared.searchForItem(query: query) { (result) in
            switch result{
            case .success(let results):
                resultSearchController.updateResults(with : results)
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
  
}

//MARK:- Routing to results page

extension SearchVC: SearchResultViewControllerDelegate{
    func didTapResult(_ result: SearchResults) {
        switch result {
        
        case .artist(let model):
            guard let urlString = model.external_urls.first?.value else {return}
            let url = URL(string: urlString)!
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        case .album(model: let model):
           
            let vc = AlbumVC(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
    
        case .playlist(model: let model):
 
            let vc = PlaylistVC(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)

        case .track(model: let model):
            break
        }
    }
}
