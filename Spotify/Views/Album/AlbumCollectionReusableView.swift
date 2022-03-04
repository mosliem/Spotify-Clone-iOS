//
//  AlbumCollectionReusableCell.swift
//  Spotify
//
//  Created by mohamedSliem on 3/3/22.
//

import UIKit
import SDWebImage

protocol AlbumCollectionReusableViewDelegate :AnyObject {
    func AlbumCollectionReusableViewDelegate(_ header : AlbumCollectionReusableView)
}

class AlbumCollectionReusableView : UICollectionReusableView {
    static let identifier = "AlbumCollectionReusableView"
    weak var delegate : AlbumCollectionReusableViewDelegate?
    
    //MARK:- Header View
    private let AlbumCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let AlbumNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 22)
        return label
    }()
    
    private let dateRealesedLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Medium", size: 17)
        return label
    }()
    
    private let artistNamesLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Medium", size: 17)
        return label
    }()
    
    private let playAllButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playAllButton.addTarget(self, action: #selector(didTapPlayAllTracks), for: .touchUpInside)
        
        let blur = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(blurView)
        
        blurView.contentView.addSubview(AlbumCoverImageView)
        blurView.contentView.addSubview(dateRealesedLabel)
        blurView.contentView.addSubview(AlbumNameLabel)
        blurView.contentView.addSubview(artistNamesLabel)
        blurView.contentView.addSubview(playAllButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override  func layoutSubviews() {
        super.layoutSubviews()
        AlbumCoverImageView.sizeToFit()
        AlbumNameLabel.sizeToFit()
        dateRealesedLabel.sizeToFit()
        artistNamesLabel.sizeToFit()
        let imageSize = height/1.5
        AlbumCoverImageView.frame = CGRect(
            x: (width - imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize
        )

        AlbumNameLabel.frame = CGRect(
            x: 20,
            y:AlbumCoverImageView.bottom+15 ,
            width: width,
            height: 30
        )
        dateRealesedLabel.frame = CGRect(
            x: 20,
            y: AlbumNameLabel.bottom ,
            width: width-30,
            height: 60
        )
        artistNamesLabel.frame = CGRect(
            x: 20,
            y: dateRealesedLabel.bottom,
            width:width-10,
            height: 20
        )
        playAllButton.frame = CGRect(
            x: width-65,
            y: height-65,
            width: 50,
            height: 50
        )
        
    }
    private func configureArtistNames(artist : [Artist]) -> String {
        var artistNames = Set<String>()
        let artistsCount = artist.count
        for i in 0 ..< artistsCount
        {
            artistNames.insert(artist[i].name)
        }
       let artistNamesString = artistNames.joined(separator: ",")
       return artistNamesString
    }
    
    @objc private func didTapPlayAllTracks(){
        delegate?.AlbumCollectionReusableViewDelegate(self)
    }
    
    
    
    //MARK:- Public
    func ConfigureHeaderViewModel(viewModel : AlbumHeaderViewModel){
        AlbumCoverImageView.sd_setImage(with: viewModel.playlistCoverURL) { (image, _, _, _) in
            guard let image = image else{
                return
            }
            self.backgroundColor = UIColor(patternImage: image)
            self.AlbumCoverImageView.applyshadow(shadowRadius: 10, shadowOpacity: 1, shadowColor: .black)
        }
        AlbumNameLabel.text = viewModel.albumName
        dateRealesedLabel.text = "Realese Date: \(viewModel.realesedDate)"
        artistNamesLabel.text = configureArtistNames(artist: viewModel.artist)
    }
    

}
