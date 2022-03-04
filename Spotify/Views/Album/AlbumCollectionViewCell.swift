//
//  AlbumCollectionViewCell.swift
//  Spotify
//
//  Created by mohamedSliem on 3/3/22.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCollectionViewCell"

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
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(
            x: 20, y: 15 ,
            width: contentView.width-20,
            height: 30
        )
        artistNameLabel.frame = CGRect(
            x: 20, y: 45 ,
            width: contentView.width - 20,
            height: 30)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configureViewModel(viewModel : AlbumTrackViewModel){
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = configureArtistNames(artist: viewModel.artists)
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
