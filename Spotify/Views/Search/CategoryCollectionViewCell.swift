//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 3/4/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
     var color : UIColor?
    private let categoryImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.transform = imageView.transform.rotated(by: CGFloat (Double.pi/4))

        return imageView
    }()
    
    
    private let categoryNameLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
     var colors:[UIColor] = [
        .systemGreen,
        .systemTeal,
        .systemRed,
        .systemBlue,
        .systemPink,
        .systemOrange,
        .systemPurple,
        .systemIndigo,
        .systemGray,
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryNameLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryNameLabel.sizeToFit()
        categoryImageView.sizeToFit()
        categoryImageView.frame = CGRect(x: contentView.width-80, y: contentView.center.y - 35, width: 80, height: 70)
        categoryNameLabel.frame = CGRect(x: 20, y: contentView.height - 50, width:contentView.width-20, height: 40)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = nil
        categoryNameLabel.text = nil
        contentView.backgroundColor = nil
    }
    
    func configureCategoryViewModel(indexPath : Int){
        categoryNameLabel.text = "Rock"
        categoryImageView.image = UIImage(systemName: "music.quarternote.3")
        contentView.backgroundColor = colors[indexPath % colors.count]
    }
}
