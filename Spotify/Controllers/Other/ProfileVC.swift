//
//  ProfileVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit
import SDWebImage
class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let TableView : UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        TableView.dataSource = self
        TableView.delegate = self
        fetchingProfile()
        
        
        
        view.addSubview(TableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TableView.frame = view.bounds
    }
    private func fetchingProfile()
    {
        APICaller.shared.getCurrentUserPorfile { [weak self](results) in
            DispatchQueue.main.async{
                switch results
                {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToFetchData()
                    
                }
            }
        }
    }
    
    private func updateUI(with model : UserProfile)
    {
        TableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        TableView.reloadData()
    }
    
    private func failedToFetchData()
    {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load data"
        label.textColor = .secondaryLabel
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label)
    }
    
    private func createTableHeader(with Url : String?){
        guard let UrlString = Url else{
            return
        }
        let imageUrl = URL(string: UrlString)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width , height: view.width/1.5))
        let imageSize = headerView.height-50
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        imageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            guard let profilePic = image ,  error == nil else
            {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async{
                imageView.image = profilePic
            }
            
        }
        imageView.center = headerView.center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        headerView.addSubview(imageView)
        TableView.tableHeaderView = headerView
    }
    
    //MARK:- TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .systemBackground
        return cell
    }
    
}
