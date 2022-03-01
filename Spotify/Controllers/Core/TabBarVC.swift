//
//  TabBarVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

class TabBarVC: UITabBarController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //VCs
        let vc1 = HomeVC()
        let vc2 = SearchVC()
        let vc3 = LibraryVC()
        //titles
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
    
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        //Navigation Controller
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        
        
        //set tab bar items to the bar
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house") , tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass") , tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list") , tag: 1)
        
        //setting the VCs to Tab Bar
        setViewControllers([nav1,nav2,nav3], animated: false)
        
    }
}
