//
//  SearchResultVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResults)
}

class SearchResultVC: UIViewController {
    
    var searchSectionsResults: [SearchSection] = []
    weak var delegate: SearchResultViewControllerDelegate?
    
    private let tableView : UITableView = {
        let tableVeiw = UITableView(frame: .zero, style: .grouped)
        tableVeiw.register(
            SearchResultDefaultTableViewCell.self,
            forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifer
        )
        
        tableVeiw.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifer
        )
        tableVeiw.isHidden = true
        return tableVeiw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    private func configureTableView(){
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func updateResults(with results: [SearchResults]){
        
        let artist = results.filter({
            switch $0{
            case .artist :
                return true
            default:
                return false
            }
        })
        
        let tracks = results.filter({
            switch $0{
            case .track :
                return true
            default:
                return false
            }
        })
        
        let albums = results.filter({
            switch $0{
            case .album :
                return true
            default:
                return false
            }
        })
        
        let playlists = results.filter({
            switch $0{
            case .playlist :
                return true
            default:
                return false
            }
        })
        
        self.searchSectionsResults = [
            SearchSection(title: "Artists", sectionResults: artist),
            SearchSection(title: "Songs", sectionResults: tracks),
            SearchSection(title: "Albums", sectionResults: albums),
            SearchSection(title: "Playlists", sectionResults: playlists)
        ]
        
        DispatchQueue.main.async {
            print("reloaded")
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
    }
}

extension SearchResultVC : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchSectionsResults[section].title
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchSectionsResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchSectionsResults[section].sectionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = searchSectionsResults[indexPath.section].sectionResults[indexPath.row]
        
        switch result {
        case .artist(let model):
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifer ,
                for: indexPath) as! SearchResultDefaultTableViewCell
            
            let viewModel = SearchResultDefaultViewModel(
                title: model.name,
                imageURL: model.images?.first?.url
            )
            cell.configure(viewModel: viewModel)
            cell.roundIcon()
            return cell
            
        case .album(model: let model):
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifer ,
                for: indexPath) as! SearchResultDefaultTableViewCell
            
            let viewModel = SearchResultDefaultViewModel(
                title: model.name,
                imageURL: model.images.first?.url
            )
            
            cell.configure(viewModel: viewModel)
            return cell
            
        case .playlist(model: let model):
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifer ,
                for: indexPath) as! SearchResultSubtitleTableViewCell
            
            let viewModel = SearchResultSubtitleViewModel(
                title: model.name,
                imageURL: model.images.first?.url,
                subtitle: model.owner.display_name
            )
            
            cell.configure(viewModel: viewModel)
            return cell
            
        case .track(model: let model):
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifer ,
                for: indexPath) as! SearchResultSubtitleTableViewCell
            
            let viewModel = SearchResultSubtitleViewModel(
                title: model.name,
                imageURL: model.album?.images.first?.url,
                subtitle: model.artists.first?.name
            )
            
            cell.configure(viewModel: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchSectionsResults[indexPath.section].sectionResults[indexPath.row]
        delegate?.didTapResult(result)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
