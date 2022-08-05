//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 8/5/22.
//

import UIKit

class SearchResultSubtitleTableViewCell: UITableViewCell {
    
    static let identifer = "SearchResultSubtitleTableViewCell"
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font =  UIFont(name: "CircularStd-Bold", size: 20)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font =  UIFont(name: "CircularStd-Bold", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        subtitleLabel.text = nil
        titleLabel.text = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: contentView.height - 10,
            height: contentView.height - 10
        )
        
        titleLabel.frame = CGRect (
            x: iconImageView.right + 10,
            y: 10,
            width: contentView.width - iconImageView.width - 30,
            height: 20
        )
        
        subtitleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: titleLabel.bottom - 5 ,
            width: contentView.width - iconImageView.width - 20 ,
            height: contentView.height - titleLabel.height
        )
        
    }
    
    func configure(viewModel: SearchResultSubtitleViewModel){
        
        titleLabel.text = viewModel.title
        
        guard let urlString = viewModel.imageURL else {return}
        let url = URL(string: urlString)
        
        iconImageView.sd_setImage(with: url , completed: nil)
        subtitleLabel.text = viewModel.subtitle
    }
    
  
}
