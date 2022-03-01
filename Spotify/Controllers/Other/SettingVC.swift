//
//  SettingVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

class SettingVC: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
   private let settingsTableView : UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var sections = [Section]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSections()
        view.backgroundColor = .systemBackground
        view.addSubview(settingsTableView)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableView.frame = view.bounds
    }
    private func configureSections()
    {
        sections.append(Section(title: "Profile", options: [Options(title: "View Your Profile Inforamtion", handler: {[weak self] in
            DispatchQueue.main.async{
                self?.ShowProfileVC()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Options(title: "Sign Out",handler: {[weak self] in
            DispatchQueue.main.async{
                self?.signInTapped()
            }
        })]))
    }
    
    private func ShowProfileVC() {
        let vc  = ProfileVC()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signInTapped()
    {
        
    }
    //MARK:- TableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        settingsTableView.deselectRow(at: indexPath, animated: true)
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
