//
//  AlbumDetailViewController.swift
//  Top100Albums
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class AlbumDetailViewController: UIViewController {
   let artworkImageView = UIImageView(image: .artworkPlaceholder)
   let nameLabel = UILabel()
   let artistLabel = UILabel()
   let rankLabel = UILabel()
   let releasedDateLabel = UILabel()
   let genresLabel = UILabel()
   let copyrightLabel = UILabel()
   
   let iTunesButton = UIButton(type: .custom)
   
   let model: AlbumViewModel
   
   init(model: AlbumViewModel) {
      self.model = model
      super.init(nibName: nil, bundle: nil)
   }
   
   // no IB instantiation
   @available(*, unavailable) required init?(coder: NSCoder) {
      nil
   }
   
   override func loadView() {
      view = UIView()
      view.backgroundColor = .appBackground
      view.insetsLayoutMarginsFromSafeArea = true
      
      artworkImageView.contentMode = .scaleAspectFill
      artworkImageView.clipsToBounds = true
      artworkImageView.tintColor = .separator
      artworkImageView.accessibilityIdentifier = "artwork"
      view.addSubview(artworkImageView)
      
      nameLabel.textColor = .text
      nameLabel.numberOfLines = 0
      nameLabel.font = .heavy
      nameLabel.textAlignment = .right
      nameLabel.adjustsFontSizeToFitWidth = true
      nameLabel.minimumScaleFactor = .minimumFontScale
      nameLabel.adjustsFontForContentSizeCategory = true
      nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      nameLabel.accessibilityIdentifier = "name"
      
      rankLabel.adjustsFontForContentSizeCategory = true
      rankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
      
      artistLabel.textColor = .appTint
      artistLabel.numberOfLines = 0
      artistLabel.font = .preferredFont(forTextStyle: .headline)
      artistLabel.textAlignment = .right
      artistLabel.adjustsFontForContentSizeCategory = true
      artistLabel.accessibilityIdentifier = "artist"
      
      releasedDateLabel.textColor = .secondaryText
      releasedDateLabel.font = .preferredFont(forTextStyle: .headline)
      releasedDateLabel.adjustsFontForContentSizeCategory = true
      releasedDateLabel.accessibilityIdentifier = "date"
      
      genresLabel.textColor = .text
      genresLabel.numberOfLines = 0
      genresLabel.font = .preferredFont(forTextStyle: .body)
      genresLabel.textAlignment = .right
      genresLabel.adjustsFontForContentSizeCategory = true
      genresLabel.accessibilityIdentifier = "genres"
      
      copyrightLabel.textColor = .secondaryText
      copyrightLabel.numberOfLines = 0
      copyrightLabel.font = .preferredFont(forTextStyle: .footnote)
      copyrightLabel.textAlignment = .right
      copyrightLabel.adjustsFontForContentSizeCategory = true
      copyrightLabel.accessibilityIdentifier = "copyright"
      
      iTunesButton.backgroundColor = .text
      iTunesButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
      iTunesButton.setTitleColor(.white, for: .normal)
      iTunesButton.contentEdgeInsets = .init(top: .marginCompact, left: .marginCompact,
                                             bottom: .marginCompact, right: .marginCompact)
      iTunesButton.accessibilityIdentifier = "iTunes"
      view.addSubview(iTunesButton)
      
      // grouping

      let rankBox = UIView()
      rankBox.backgroundColor = .black
      rankBox.layoutMargins = .visualTextMargins
      rankBox.addSubview(rankLabel, pinTo: .layoutMargins)
      rankBox.accessibilityIdentifier = "rank-box"
      view.addSubview(rankBox)
      
      let artistBox = UIStackView(arrangedSubviews: [artistLabel, releasedDateLabel])
      artistBox.axis = .vertical
      artistBox.alignment = .trailing
      artistBox.distribution = .fill
      artistBox.spacing = .itemSpacing
      artistBox.accessibilityIdentifier = "artist-date-box"
      view.addSubview(artistBox)
      
      let contentBox = UIStackView(arrangedSubviews: [nameLabel, copyrightLabel, artistBox, genresLabel])
      contentBox.axis = .vertical
      contentBox.alignment = .trailing
      contentBox.distribution = .fill
      contentBox.spacing = .marginMedium
      contentBox.accessibilityIdentifier = "name-copyright-box"
      view.addSubview(contentBox)
      
      // constraints
      
      view.pin(artworkImageView, to: .bounds, bottom: nil)

      let artworkRatio = artworkImageView.heightAnchor.constraint(
         equalTo: artworkImageView.widthAnchor)
      artworkRatio.priority = .defaultHigh
      let artworkMaxHeight = artworkImageView.heightAnchor.constraint(
         lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5)
      
      rankBox.translatesAutoresizingMaskIntoConstraints = false
      let rankLeading = rankBox.leadingAnchor.constraint(
         equalTo: view.layoutMarginsGuide.leadingAnchor)
      let rankBottom = rankBox.bottomAnchor.constraint(
         equalTo: artworkImageView.bottomAnchor,
         constant: .interlineSpacing)
      
      contentBox.translatesAutoresizingMaskIntoConstraints = false
      let nameLeading = contentBox.leadingAnchor.constraint(
         equalToSystemSpacingAfter: rankBox.trailingAnchor, multiplier: 1)
      let nameTrailing = contentBox.trailingAnchor.constraint(
         equalTo: view.layoutMarginsGuide.trailingAnchor)
      let nameBoxVertical = copyrightLabel.topAnchor.constraint(
         equalTo: artworkImageView.bottomAnchor, constant: .interlineSpacing)
      
      view.pin(iTunesButton, to: .safeArea, top: nil, leading: 20, trailing: 20, bottom: 20)
      
      NSLayoutConstraint.activate([
         artworkRatio, artworkMaxHeight,
         rankLeading, rankBottom,
         nameLeading, nameTrailing, nameBoxVertical,
      ])
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      reload()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.navigationBar.barStyle = .black
   }
   
   func reload() {
      nameLabel.attributedText = NSAttributedString(
         string: model.name,
         attributes: [
            .backgroundColor: UIColor.textOverlay
         ])
      artistLabel.text = model.artistName
      rankLabel.text = model.rank
      if model.isTop3 == true {
         rankLabel.font = nameLabel.font
         rankLabel.textColor = .yellow
      } else {
         rankLabel.font = .preferredFont(forTextStyle: .headline)
         rankLabel.textColor = .white
      }
      releasedDateLabel.text = model.releasedDateText
      releasedDateLabel.isHidden = model.releasedDateText == nil
      genresLabel.text = model.compactGenresText
      copyrightLabel.text = model.copyright
      iTunesButton.setTitle(model.iTunesButtonTitle, for: .normal)

      RssAPI.artwork(url: model.artworkUrl) { [weak self] image in
         self?.artworkImageView.image = image
      }
   }
   
   @objc func iTunesButtonHit() {
      if UIApplication.shared.canOpenURL(model.iTunesUrl) {
         UIApplication.shared.open(model.iTunesUrl)
      }
   }
}
