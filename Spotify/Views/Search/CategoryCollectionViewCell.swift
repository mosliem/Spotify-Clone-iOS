//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 3/4/22.
//

import UIKit
import SDWebImage
class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
     var color : UIColor?
    private let categoryImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.transform = imageView.transform.rotated(by: CGFloat (Double.pi/9))
        return imageView
    }()
    
    
    private let categoryNameLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "CircularStd-Bold", size: 18)
        label.numberOfLines = 0
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
        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImageView.sizeToFit()
        categoryNameLabel.sizeToFit()
            self.categoryImageView.frame = CGRect(x: self.contentView.width-60, y: self.contentView.height-80, width: 70, height: 70)
            self.categoryNameLabel.frame = CGRect(x: 5, y: 10, width:self.contentView.width-80, height: 50)
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = nil
        categoryNameLabel.text = nil
        contentView.backgroundColor = nil
    }
    
    func configureCategoryViewModel(indexPath: Int , viewModel: CategoryViewModel){
        categoryNameLabel.text = viewModel.categoryName
        categoryImageView.sd_setImage(with: viewModel.categoryCover) { (_, _, _, _) in
            self.categoryImageView.applyshadow(shadowRadius: 40, shadowOpacity: 1, shadowColor: self.color ?? .black)
        }
        contentView.backgroundColor = colors[indexPath % colors.count]
    }
}
