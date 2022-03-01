//
//  recommededTrackCell.swift
//  Spotify
//
//  Created by mohamedSliem on 2/15/22.
//

 

import UIKit
import SDWebImage
class RecommendedTrackCell : UICollectionViewCell {
    static let identifier = "RecommendedCollectionViewCell"
    
    private let AlbumCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    

    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNamesLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Medium", size: 12)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
 
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(AlbumCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(artistNamesLabel)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        AlbumCoverImageView.sizeToFit()
        playlistNameLabel.sizeToFit()
        artistNamesLabel.sizeToFit()
        let imageSize = contentView.height - 60
        AlbumCoverImageView.frame = CGRect(x: 0, y: 5, width:imageSize , height: imageSize)
        playlistNameLabel.frame = CGRect(x: 1, y: AlbumCoverImageView.bottom+10, width: contentView.width, height: 20)
        artistNamesLabel.frame = CGRect(x: 1, y: playlistNameLabel.bottom-5, width: contentView.width, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(viewModel : RecommendationViewModel){
        AlbumCoverImageView.sd_setImage(with: viewModel.albumCoverUrl, completed: nil)
        playlistNameLabel.text = viewModel.albumName
        artistNamesLabel.text = configureArtistNames(artist: viewModel.artist)
        
    }
    
    func configureArtistNames(artist : [Artist]) -> String
    {
        var artistNames = Set<String>()
        let artistsCount = artist.count
        for i in 0 ..< artistsCount
        {
            artistNames.insert(artist[i].name)
        }
       let artistNamesString = artistNames.joined(separator: ",")
       return artistNamesString
    }

}
