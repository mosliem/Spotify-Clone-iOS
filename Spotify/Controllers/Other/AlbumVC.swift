//
//  AlbumVC.swift
//  Spotify
//
//  Created by mohamedSliem on 2/26/22.
//

import UIKit

class AlbumVC: UIViewController {
   
    private let album : Album
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        APICaller.shared.getAlbumDetails(id: album.id) { (_) in
            
        }
    }
    

}
