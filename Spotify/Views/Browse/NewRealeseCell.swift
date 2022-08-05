//
//  newRealeseCell.swift
//  Spotify
//
//  Created by mohamedSliem on 2/15/22.
//

import UIKit
import SDWebImage

class NewRealesesCell : UICollectionViewCell {
    static let identifier = "NewRealesesCollectionViewCell"
    
    private let albumCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    

    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 22)
        label.numberOfLines = 0
        return label
    }()
 
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Light", size: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    override init(frame : CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.sizeToFit()
        albumNameLabel.sizeToFit()
        let imageSize : CGFloat = contentView.height - 10
        let albumNameLabelSize = albumNameLabel.sizeThatFits(
            CGSize(width: contentView.width,
                   height: contentView.height-10)
        )
        
        albumCoverImageView.frame = CGRect(
            x: 0, y: 5,
            width: imageSize,
            height: imageSize
        )

        let albumNameHeight = min(30 , albumNameLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 10,
            width: contentView.width - imageSize - 20,
            height: albumNameHeight
        )
        
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumNameLabel.height+15,
            width: contentView.width-albumCoverImageView.right-10,
            height:44
        )
        
        //number of tracks label size and coordinates.. it is located at the bottom of the cell
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.bottom - 35,
            width: contentView.width-albumCoverImageView.right-10,
            height: 30
        )
        
    }
    
     func configureData(on viewModel : NewRealesesViewModel){
        
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "tracks:\(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
