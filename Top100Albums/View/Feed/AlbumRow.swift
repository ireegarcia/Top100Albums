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
   let artworkImageView = UIImageView(image: .artworkPlaceholder)
   let separatorView = UIView()
   
   override var imageView: UIImageView? { artworkImageView }
      
   var model: AlbumViewModel? {
      didSet { reload() }
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      backgroundColor = .clear
      contentView.backgroundColor = .clear
      
      selectedBackgroundView = UIView()
      selectedBackgroundView?.backgroundColor = UIColor.appTint.withAlphaComponent(0.1)
      
      separatorView.backgroundColor = .separator
      contentView.addSubview(separatorView)
      contentView.pin(separatorView, to: .bounds, top: nil, leading: .itemSpacing)
      
      // artwork image
      artworkImageView.contentMode = .scaleAspectFill
      artworkImageView.clipsToBounds = true
      artworkImageView.tintColor = .separator
      artworkImageView.accessibilityIdentifier = "artwork"
      contentView.addSubview(artworkImageView)
      contentView.pin(artworkImageView, to: .bounds,
                      top: .interlineSpacing,
                      trailing: nil,
                      bottom: .interlineSpacing)
      
      // label
      nameLabel.textColor = .text
      nameLabel.numberOfLines = 2
      nameLabel.font = UIFontMetrics(forTextStyle: .headline)
         .scaledFont(for: .systemFont(ofSize: 24, weight: .black))
      nameLabel.textAlignment = .right
      nameLabel.adjustsFontSizeToFitWidth = true
      nameLabel.minimumScaleFactor = .minimumFontScale
      nameLabel.adjustsFontForContentSizeCategory = true
      nameLabel.setContentHuggingPriority(.required, for: .vertical)
      nameLabel.accessibilityIdentifier = "name"
      
      artistLabel.textColor = .appTint
      artistLabel.numberOfLines = 3
      artistLabel.font = .preferredFont(forTextStyle: .headline)
      artistLabel.textAlignment = .right
      artistLabel.adjustsFontSizeToFitWidth = true
      artistLabel.minimumScaleFactor = .minimumFontScale
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
      contentView.pin(labelsBox, to: .layoutMargins,
                      top: .marginMedium, bottom: .marginMedium)
      
      let rankBox = UIView()
      rankBox.backgroundColor = .black
      rankBox.layoutMargins = .visualTextMargins
      rankBox.accessibilityIdentifier = "rank-box"
      rankBox.addSubview(rankLabel, pinTo: .layoutMargins)
      
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
         rankBox.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
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
            .backgroundColor: UIColor.textOverlay
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
   
   override func prepareForReuse() {
      super.prepareForReuse()
      artworkImageView.image = .artworkPlaceholder
   }
}
