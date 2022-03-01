//
//  PlaylistCollectionReusableView.swift
//  Spotify
//
//  Created by mohamedSliem on 2/28/22.
//

import UIKit
import SDWebImage

protocol PlaylistCollectionReusableViewDelegate :AnyObject {
    func PlaylistCollectionReusableViewPlayAllTracks(_ header : PlaylistCollectionReusableView)
}

class PlaylistCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistCollectionReusableView"
    weak var delegate : PlaylistCollectionReusableViewDelegate?
    private let PlaylistCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
 
        return imageView
    }()

    private let ownerNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Light", size:15)
        return label
    }()
    
    private let PlaylistNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 22)
        return label
    }()
    private let descriptionLabel : PaddingLabel = {
        let label = PaddingLabel()
        label.font =  UIFont(name: "CircularStd-Medium", size: 18)
        label.numberOfLines = 0
        label.paddingRight = 30
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
        
        
        blurView.contentView.addSubview(PlaylistCoverImageView)
        blurView.contentView.addSubview(PlaylistNameLabel)
        blurView.contentView.addSubview(ownerNameLabel)
        blurView.contentView.addSubview(descriptionLabel)
        blurView.contentView.addSubview(playAllButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        PlaylistCoverImageView.sizeToFit()
        descriptionLabel.sizeToFit()
        ownerNameLabel.sizeToFit()
        
        let imageSize = height/1.5
        PlaylistCoverImageView.frame = CGRect(
            x: (width - imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize
        )

        PlaylistNameLabel.frame = CGRect(
            x: 20,
            y:PlaylistCoverImageView.bottom+15 ,
            width: width,
            height: 30
        )
        descriptionLabel.frame = CGRect(
            x: 20,
            y: PlaylistNameLabel.bottom ,
            width: width-30,
            height: 60
        )
        ownerNameLabel.frame = CGRect(
            x: 20,
            y: descriptionLabel.bottom,
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
    
    required init?(coder: NSCoder) {
        fatalError()
    }
  
    @objc private func didTapPlayAllTracks()
    {
        delegate?.PlaylistCollectionReusableViewPlayAllTracks(self)
    }
    func configure(viewModel : PlaylistHeaderViewModel){
        PlaylistCoverImageView.sd_setImage(with: viewModel.playlistCoverURL) { (image, error, _,_) in
            guard let image = image ,error == nil else{
                print(error?.localizedDescription)
                return
            }
            self.backgroundColor = UIColor(patternImage: image)
            self.PlaylistCoverImageView.applyshadow(shadowRadius: 15, shadowOpacity: 1 , shadowColor : .black)
            
        }
        PlaylistNameLabel.text = viewModel.name
        ownerNameLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        
    }
}
