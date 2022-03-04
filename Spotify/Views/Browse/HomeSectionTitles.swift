//
//  HomeSectionTitles.swift
//  Spotify
//
//  Created by mohamedSliem on 3/2/22.
//

import UIKit
class HomeSectionTitles: UICollectionReusableView {
    
    static let identifier = "HomeSectionTitlesReusableView"
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "CircularStd-Bold", size: 28)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y:15 , width: width, height: 40)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title : String){
        titleLabel.text = title
    }
}
