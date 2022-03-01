//
//  FeaturedPlaylistCell.swift
//  Spotify
//
//  Created by mohamedSliem on 2/15/22.
//


import UIKit
import SDWebImage
class FeaturedPlaylistCell : UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    

    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 16)
        label.numberOfLines = 0
        return label
    }()
 
    private let ownerNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Light", size: 10)
        label.textColor = .darkGray        
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(ownerNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistCoverImageView.image = nil
        playlistNameLabel.text = nil
        ownerNameLabel.text = nil
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistCoverImageView.sizeToFit()
        playlistNameLabel.sizeToFit()
        ownerNameLabel.sizeToFit()
        let imageSize = contentView.height-60
        playlistCoverImageView.frame = CGRect(x: 0, y: 0, width:imageSize, height:imageSize)
        playlistNameLabel.frame = CGRect(x: 0, y: playlistCoverImageView.bottom+5, width: contentView.width, height: 20)
        ownerNameLabel.frame = CGRect(x: 0, y: playlistNameLabel.bottom+5, width: contentView.width, height: 20)
    }
    
    func configure (on viewModel : FeaturedPlaylistViewModel){
        playlistCoverImageView.sd_setImage(with: viewModel.playlistImageUrl, completed: nil)
        playlistNameLabel.text = viewModel.playlistName
        ownerNameLabel.text = viewModel.ownerName
    }
}

