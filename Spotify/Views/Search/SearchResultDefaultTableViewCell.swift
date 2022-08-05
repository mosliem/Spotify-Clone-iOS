//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 8/4/22.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {

    static let identifer = "SearchResultDefaultTableViewCell"
  
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: contentView.height - 10,
            height: contentView.height - 10
        )
        
        titleLabel.frame = CGRect (
            x: iconImageView.right + 10,
            y: 5, width: contentView.width - iconImageView.width - 20,
            height: 35
        )
        
    }

    func configure(viewModel: SearchResultDefaultViewModel){
        
        titleLabel.text = viewModel.title
        
        guard let urlString = viewModel.imageURL else {return}
        let url = URL(string: urlString)
        
        iconImageView.sd_setImage(with: url , completed: nil)
    }
    
    func roundIcon(){
        iconImageView.layer.cornerRadius = 30
    }
}
