//
//  AlbumRow.swift
//  Top100Albums
//
//  Created by Iree García on 25/09/20.
//

import UIKit

class AlbumRow: UITableViewCell {
   let nameLabel = UILabel()
   let artistLabel = UILabel()
   let rankLabel = UILabel()
   let artworkImageView = UIImageView(image: #imageLiteral(resourceName: "fakeAlbum"))
   let separatorView = UIView()
      
   var model: AlbumViewModel? {
      didSet { reload() }
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      backgroundColor = .clear
      contentView.backgroundColor = .clear
      
      let tint = UIColor.red
      selectedBackgroundView = UIView()
      selectedBackgroundView?.backgroundColor = tint.withAlphaComponent(0.1)
      
      separatorView.backgroundColor = .separator
      contentView.addSubview(separatorView)
      contentView.pin(separatorView, to: .bounds, top: nil, leading: .interItemSpacing)
      
      // artwork image
      artworkImageView.contentMode = .scaleAspectFill
      artworkImageView.clipsToBounds = true
      artworkImageView.accessibilityIdentifier = "artwork"
      contentView.addSubview(artworkImageView)
      contentView.pin(artworkImageView, to: .bounds,
                      top: .interlineSpacing,
                      trailing: nil,
                      bottom: .interlineSpacing)
      
      // label
      nameLabel.textColor = .black
      nameLabel.numberOfLines = 2
      nameLabel.font = UIFontMetrics(forTextStyle: .headline)
         .scaledFont(for: .systemFont(ofSize: 24, weight: .black))
      nameLabel.textAlignment = .right
      nameLabel.adjustsFontSizeToFitWidth = true
      nameLabel.minimumScaleFactor = .minimumFontScale
      nameLabel.adjustsFontForContentSizeCategory = true
      nameLabel.setContentHuggingPriority(.required, for: .vertical)
      nameLabel.accessibilityIdentifier = "name"
      
      artistLabel.textColor = tint
      artistLabel.numberOfLines = 3
      artistLabel.font = .preferredFont(forTextStyle: .headline)
      artistLabel.textAlignment = .right
      artistLabel.adjustsFontForContentSizeCategory = true
      artistLabel.setContentHuggingPriority(.required, for: .vertical)
      artistLabel.accessibilityIdentifier = "artist"
      
      let labelsBox = UIStackView(arrangedSubviews: [nameLabel, artistLabel])
      labelsBox.axis = .vertical
      labelsBox.alignment = .trailing
      labelsBox.distribution = .fill
      labelsBox.spacing = .interlineSpacing
      labelsBox.accessibilityIdentifier = "labels-box"
      
      contentView.addSubview(labelsBox)
      contentView.pin(labelsBox, to: .layoutMargins, top: 25, bottom: 22)
      
      let rankBox = UIView()
      rankBox.backgroundColor = .black
      rankBox.layoutMargins = .init(top: 3, left: 5, bottom: 3, right: 5)
      rankBox.addSubview(rankLabel, pinTo: .layoutMargins)
      rankBox.accessibilityIdentifier = "rank-box"
      
      rankBox.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(rankBox)
      
      // other constraints
      NSLayoutConstraint.activate([
         separatorView.heightAnchor.constraint(equalToConstant: 3),
         // limit artwork width on smaller screens
         artworkImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
         // don't overlap artwork with artist
         artistLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: artworkImageView.trailingAnchor, multiplier: 1),
         // position ranking label
         rankBox.leadingAnchor.constraint(equalTo: artworkImageView.leadingAnchor,
                                          constant: .interItemSpacing),
         rankBox.bottomAnchor.constraint(equalTo: artworkImageView.bottomAnchor,
                                          constant: .interlineSpacing),
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func reload() {
      nameLabel.attributedText = NSAttributedString(
         string: model?.name ?? "",
         attributes: [
            .backgroundColor: UIColor.white.withAlphaComponent(0.9)
         ])
      artistLabel.text = model?.artistName
      rankLabel.text = model?.rank
      if model?.isTop3 == true {
         rankLabel.font = nameLabel.font
         rankLabel.textColor = .yellow
      } else {
         rankLabel.font = .preferredFont(forTextStyle: .headline)
         rankLabel.textColor = .white
      }
   }
}
