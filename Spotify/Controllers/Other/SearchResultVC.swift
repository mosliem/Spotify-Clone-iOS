//
//  SearchResultVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

class SearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchSectionsResults: [SearchSection] = []
    private let tableView : UITableView = {
        let tableVeiw = UITableView()
        tableVeiw.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchSectionsResults.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchSectionsResults[section].sectionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let result = searchSectionsResults[indexPath.section].sectionResults[indexPath.row]
//        else
//        {
//            return UITableViewCell()
//        }
        switch result {
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .album(model: let model):
            break
        case .playlist(model: let model):
            break
        case .track(model: let model):
            break
        }
        return cell
    }
    
    
    func updateResults(with results: [SearchResults]){
        let artist = results.filter({
            switch $0{
            case.artist :
                return true
            default:
                return false
            }
        })
        
        self.searchSectionsResults = [
            SearchSection(title: "Artist", sectionResults: artist)
        ]
        DispatchQueue.main.async {
            print("reloaded")
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
    }
}
