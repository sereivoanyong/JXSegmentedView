//
//  JXSegmentedItemCell.swift
//  JXSegmentedView
//
//  Created by Sereivoan Yong on 2/6/25.
//

import UIKit
import Kingfisher

open class __SegmentedImageCell: JXSegmentedBaseCell {

  public let imageView = AnimatedImageView()

  open override func commonInit() {
    super.commonInit()

    imageView.clipsToBounds = true
    imageView.contentMode = .center
    contentView.addSubview(imageView)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    imageView.center = contentView.center
  }

  open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
    super.reloadData(itemModel: itemModel, selectedType: selectedType )

    guard let itemModel = itemModel as? __SegmentedImageItemModel else { return }
    imageView.bounds = CGRect(x: 0, y: 0, width: itemModel.imageSize.width, height: itemModel.imageSize.height)
    imageView.kf.setImage(with: itemModel.imageSource, placeholder: itemModel.imagePlaceholder, options: [
      .scaleFactor(UIScreen.main.scale),
      .cacheOriginalImage,
      .processor(DownsamplingImageProcessor(size: itemModel.imageSize)),
      .transition(.fade(0.2))
    ])
    setNeedsLayout()
  }
}

open class __SegmentedTitleImageCell: JXSegmentedTitleCell {

  public let imageView = UIImageView()
  private var currentImageSource: Source?

  open override func prepareForReuse() {
    super.prepareForReuse()

    currentImageSource = nil
  }

  open override func commonInit() {
    super.commonInit()

    imageView.contentMode = .scaleAspectFit
    contentView.insertSubview(imageView, belowSubview: titleLabel)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    guard let itemModel = itemModel as? __SegmentedTitleImageItemModel else {
      return
    }

    let imageSize = itemModel.imageSize
    switch itemModel.titleImageType {
    case .topImage:
      let contentHeight = imageSize.height + itemModel.titleImageSpacing + titleLabel.bounds.size.height
      imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + imageSize.height/2)
      titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: imageView.frame.maxY + itemModel.titleImageSpacing + titleLabel.bounds.size.height/2)
    case .leftImage:
      let contentWidth = imageSize.width + itemModel.titleImageSpacing + titleLabel.bounds.size.width
      imageView.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + imageSize.width/2, y: contentView.bounds.size.height/2)
      titleLabel.center = CGPoint(x: imageView.frame.maxX + itemModel.titleImageSpacing + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
    case .bottomImage:
      let contentHeight = imageSize.height + itemModel.titleImageSpacing + titleLabel.bounds.size.height
      titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + titleLabel.bounds.size.height/2)
      imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: titleLabel.frame.maxY + itemModel.titleImageSpacing + imageSize.height/2)
    case .rightImage:
      let contentWidth = imageSize.width + itemModel.titleImageSpacing + titleLabel.bounds.size.width
      titleLabel.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
      imageView.center = CGPoint(x: titleLabel.frame.maxX + itemModel.titleImageSpacing + imageSize.width/2, y: contentView.bounds.size.height/2)
    case .onlyImage:
      imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
    case .onlyTitle:
      titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
    case .backgroundImage:
      imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
      titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
    }
    maskTitleLabel.center = titleLabel.center
  }

  open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
    super.reloadData(itemModel: itemModel, selectedType: selectedType )

    guard let itemModel = itemModel as? __SegmentedTitleImageItemModel else {
      return
    }

    titleLabel.isHidden = false
    imageView.isHidden = false

    imageView.bounds = CGRect(x: 0, y: 0, width: itemModel.imageSize.width, height: itemModel.imageSize.height)

    var imageSource = itemModel.imageSource
    if itemModel.isSelected {
      imageSource = itemModel.selectedImageSource
    }

    //因为`func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
    if imageSource != currentImageSource {
      currentImageSource = imageSource
      imageView.kf.setImage(with: imageSource, options: [.cacheOriginalImage, .scaleFactor(UIScreen.main.scale), .transition(.fade(0.2))])
    }

    setNeedsLayout()
  }
}
