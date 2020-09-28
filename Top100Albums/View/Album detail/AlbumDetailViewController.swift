//
//  AlbumDetailViewController.swift
//  Top100Albums
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class AlbumDetailViewController: UIViewController {
   let artworkImageView = UIImageView(image: .artworkPlaceholder)
   let scrollView = UIScrollView()
   /// Guides the bottom of the artwork, but it's inside the scrollable content
   let artworkGuide = UILayoutGuide()
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
      artworkImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
      artworkImageView.accessibilityIdentifier = "artwork"
      view.addSubview(artworkImageView)
      
      let contentView = UIView()
      contentView.backgroundColor = .clear
      scrollView.addSubview(contentView, pinTo: .contentLayout)
      view.addSubview(scrollView)
      loadScrollingContent(in: contentView)
      
      iTunesButton.backgroundColor = .text
      iTunesButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
      iTunesButton.setTitleColor(.white, for: .normal)
      iTunesButton.contentEdgeInsets = .init(top: .marginCompact, left: .marginCompact,
                                             bottom: .marginCompact, right: .marginCompact)
      iTunesButton.accessibilityIdentifier = "iTunes"
      view.addSubview(iTunesButton)
      
      iTunesButton.addTarget(self, action: #selector(iTunesButtonHit),
                             for: .touchUpInside)
      
      // constraints
      
      view.pin(iTunesButton, to: .safeArea, top: nil, leading: 20, trailing: 20, bottom: 20)
      
      view.pin(artworkImageView, to: .bounds, bottom: nil)
      let artworkBottom = artworkImageView.bottomAnchor.constraint(
         equalTo: artworkGuide.bottomAnchor)
      // it could become unsatisfiable if the guide goes beyond
      // the top of the screen (negative height)
      artworkBottom.priority = .defaultHigh
      
      view.pin(scrollView, to: .layoutMargins, top: nil, bottom: nil)
      let scrollTop = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
      let scrollBottom = iTunesButton.topAnchor.constraint(
         equalTo: scrollView.bottomAnchor, constant: .marginCompact)
      
      NSLayoutConstraint.activate([
         artworkBottom, scrollTop, scrollBottom
      ])
   }
   
   private func loadScrollingContent(in view: UIView) {
      artworkGuide.identifier = "artwork-guide"
      view.addLayoutGuide(artworkGuide)
      
      nameLabel.textColor = .text
      nameLabel.numberOfLines = 0
      nameLabel.font = .heavy
      nameLabel.textAlignment = .right
      nameLabel.adjustsFontSizeToFitWidth = true
      nameLabel.minimumScaleFactor = .minimumFontScale
      nameLabel.adjustsFontForContentSizeCategory = true
      nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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
      artistBox.spacing = .interlineSpacing
      artistBox.accessibilityIdentifier = "artist-date-box"
      view.addSubview(artistBox)
      
      let labelsBox = UIStackView(arrangedSubviews: [
         nameLabel, copyrightLabel, artistBox, genresLabel
      ])
      labelsBox.axis = .vertical
      labelsBox.alignment = .trailing
      labelsBox.distribution = .fill
      labelsBox.spacing = .marginMedium
      labelsBox.accessibilityIdentifier = "labels-box"
      view.addSubview(labelsBox)
      
      // constraints
      
      view.pin(artworkGuide, to: .bounds, bottom: nil)
      let artworkGuideHeight = artworkGuide.heightAnchor.constraint(
         equalTo: self.view.widthAnchor)
      artworkGuideHeight.priority = .defaultHigh
      let artworkMaxHeight = artworkGuide.heightAnchor.constraint(
         lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.5)
      
      rankBox.translatesAutoresizingMaskIntoConstraints = false
      let rankLeading = rankBox.leadingAnchor.constraint(
         equalTo: view.layoutMarginsGuide.leadingAnchor)
      let rankBottom = rankBox.bottomAnchor.constraint(
         equalTo: artworkGuide.bottomAnchor,
         constant: .interlineSpacing)
      
      view.pin(labelsBox, to: .layoutMargins, top: nil, bottom: .marginCompact)
      let labelsBoxVertical = copyrightLabel.topAnchor.constraint(
         equalTo: artworkGuide.bottomAnchor, constant: .interlineSpacing)
      labelsBoxVertical.priority = .defaultHigh
      // if the nameLabel grows too big, it should still be visible
      let labelsBoxTop = labelsBox.topAnchor.constraint(
         greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor)
      
      let nameLeading = nameLabel.leadingAnchor.constraint(
         greaterThanOrEqualToSystemSpacingAfter: rankBox.trailingAnchor, multiplier: 1)
      let copyrightLeading = copyrightLabel.leadingAnchor.constraint(
         greaterThanOrEqualToSystemSpacingAfter: rankBox.trailingAnchor, multiplier: 1)
      
      NSLayoutConstraint.activate([
         artworkGuideHeight, artworkMaxHeight,
         rankLeading, rankBottom,
         labelsBoxVertical, labelsBoxTop,
         nameLeading, copyrightLeading
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

      // load larger artwork
      RssAPI.artwork(url: model.largeArtworkUrl) { [weak self] image in
         self?.artworkImageView.image = image
      }
   }
   
   @objc func iTunesButtonHit() {
      if UIApplication.shared.canOpenURL(model.iTunesUrl) {
         UIApplication.shared.open(model.iTunesUrl)
      }
   }
}
