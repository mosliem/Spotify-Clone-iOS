//
//  PlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 2/26/22.
//

import UIKit
import SDWebImage

class PlaylistItemsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "PlaylistCollectionViewCell"
    
    
    
    private let trackNameLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont(name: "CircularStd-Bold", size: 18)
        label.numberOfLines = 0
        label.paddingRight = 50
        return label
    }()
    
    private let artistNameLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont(name: "CircularStd-Medium", size: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.paddingRight = 50
        return label
    }()
    
    private let trackCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackCoverImageView)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.sizeToFit()
        trackCoverImageView.sizeToFit()
        artistNameLabel.sizeToFit()
        
        let imageSize : CGFloat = contentView.height
        
        trackCoverImageView.frame = CGRect(
            x: 0.3, y:0 ,
            width: imageSize,
            height: imageSize
        )
        
        trackNameLabel.frame = CGRect(
            x: trackCoverImageView.right + 13, y: 10 ,
            width: contentView.width - trackCoverImageView.right - 10,
            height: 30
        )
        artistNameLabel.frame = CGRect(
            x: trackCoverImageView.right + 13, y: 35 ,
            width: contentView.width - trackCoverImageView.right - 10,
            height: 30)
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
        trackNameLabel.text = nil
        trackCoverImageView.image = nil
        
    }
    
    func configure(viewModel : PlaylistTrackViewModel){
        artistNameLabel.text = configureArtistNames(artist: viewModel.artist)
        trackNameLabel.text = viewModel.trackName
        trackCoverImageView.sd_setImage(with: viewModel.trackCoverUrl, completed: nil)
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
    
}
