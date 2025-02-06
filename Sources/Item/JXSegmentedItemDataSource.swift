//
//  JXSegmentedItemDataSource.swift
//  JXSegmentedView
//
//  Created by Sereivoan Yong on 2/6/25.
//

import UIKit
import Kingfisher

open class JXSegmentedItemDataSource: JXSegmentedBaseDataSource {

  open var items: [JXSegmentedItem] = []

  open var titleFont: UIFont = .systemFont(ofSize: 14)

  open var titleColor: UIColor = .black

  open var titleSelectedColor: UIColor = .red

  open var titleSelectedFont: UIFont?

  open var imageSize: CGSize = CGSize(width: 30, height: 30)

  open var imagePadding: CGFloat = 5

  open override func preferredItemCount() -> Int {
    return items.count
  }

  open override func preferredItemModelInstance(at index: Int) -> JXSegmentedBaseItemModel? {
    let item = items[index]
    switch item {
    case .title:
      return JXSegmentedTitleItemModel()
    case .image:
      return __SegmentedImageItemModel()
    case .titleImage:
      return __SegmentedTitleImageItemModel()
    case .titleBadgeNumber:
      return JXSegmentedNumberItemModel()
    case .titleDot:
      return JXSegmentedDotItemModel()
    case .attributedTitle:
      return JXSegmentedTitleAttributeItemModel()
    }
  }

  open override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
    let itemModel = dataSource[index]
    let item = items[index]
    switch item {
    case .title(let title):
      let itemModel = itemModel as! JXSegmentedTitleItemModel
      let titleWidth = width(for: title, height: segmentedView.frame.height, font: itemModel.titleNormalFont)
      return titleWidth + itemWidthIncrement

    case .image:
      let _ = itemModel as! __SegmentedImageItemModel
      return imageSize.width + itemWidthIncrement

    case .titleImage(let title, _, _):
      let itemModel = itemModel as! __SegmentedTitleImageItemModel
      let titleWidth = width(for: title, height: segmentedView.frame.height, font: itemModel.titleNormalFont)
      return titleWidth + itemModel.titleImageSpacing + imageSize.width + itemWidthIncrement

    case .titleBadgeNumber(let title, _):
      let itemModel = itemModel as! JXSegmentedNumberItemModel
      let titleWidth = width(for: title, height: segmentedView.frame.height, font: itemModel.titleNormalFont)
      return titleWidth + itemWidthIncrement

    case .titleDot(let title, _):
      let itemModel = itemModel as! JXSegmentedDotItemModel
      let titleWidth = width(for: title, height: segmentedView.frame.height, font: itemModel.titleNormalFont)
      return titleWidth + itemWidthIncrement

    case .attributedTitle(let attributedTitle):
      let _ = itemModel as! JXSegmentedTitleAttributeItemModel
      let titleWidth = width(for: attributedTitle, height: segmentedView.frame.height)
      return titleWidth + itemWidthIncrement
    }
  }

  open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
    super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
    let item = items[index]
    switch item {
    case .title(let title):
      let itemModel = itemModel as! JXSegmentedTitleItemModel
      itemModel.title = title
      itemModel.titleNormalColor = titleColor
      itemModel.titleNormalFont = titleFont
      itemModel.titleSelectedColor = titleSelectedColor
      itemModel.titleSelectedFont = titleSelectedFont ?? titleFont

    case .image(let source, let placeholder):
      let itemModel = itemModel as! __SegmentedImageItemModel
      itemModel.imageSource = source
      itemModel.imagePlaceholder = placeholder
      itemModel.imageSize = imageSize

    case .titleImage(let title, let imageSource, _):
      let itemModel = itemModel as! __SegmentedTitleImageItemModel
      itemModel.title = title
      itemModel.titleNormalColor = titleColor
      itemModel.titleNormalFont = titleFont
      itemModel.titleSelectedColor = titleSelectedColor
      itemModel.titleSelectedFont = titleSelectedFont ?? titleFont
      itemModel.imageSource = imageSource
      itemModel.imageSize = imageSize
      itemModel.titleImageSpacing = imagePadding

    case .titleBadgeNumber(let title, let badgeNumber):
      let itemModel = itemModel as! JXSegmentedNumberItemModel
      itemModel.title = title
      itemModel.titleNormalColor = titleColor
      itemModel.titleNormalFont = titleFont
      itemModel.titleSelectedColor = titleSelectedColor
      itemModel.titleSelectedFont = titleSelectedFont ?? titleFont
      itemModel.number = badgeNumber
      itemModel.numberString = "\(badgeNumber)"

    case .titleDot(let title, let showsDot):
      let itemModel = itemModel as! JXSegmentedDotItemModel
      itemModel.title = title
      itemModel.titleNormalColor = titleColor
      itemModel.titleNormalFont = titleFont
      itemModel.titleSelectedColor = titleSelectedColor
      itemModel.titleSelectedFont = titleSelectedFont ?? titleFont
      itemModel.dotState = showsDot

    case .attributedTitle(let attributedTitle):
      let itemModel = itemModel as! JXSegmentedTitleAttributeItemModel
      itemModel.attributedTitle = attributedTitle
    }

    if let itemModel = itemModel as? JXSegmentedTitleItemModel {
      if index == selectedIndex {
        itemModel.titleCurrentColor = itemModel.titleSelectedColor
        itemModel.titleCurrentZoomScale = itemModel.titleSelectedZoomScale
        itemModel.titleCurrentStrokeWidth = itemModel.titleSelectedStrokeWidth
      } else {
        itemModel.titleCurrentColor = itemModel.titleNormalColor
        itemModel.titleCurrentZoomScale = 1
        itemModel.titleCurrentStrokeWidth = 0
      }
    }
  }

  // MARK: Helper

  private func width(for title: String, height: CGFloat, font: UIFont) -> CGFloat {
    let size = (title as NSString).boundingRect(
      with: CGSize(width: .greatestFiniteMagnitude, height: height),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: [.font: font],
      context: nil
    ).size
    return ceil(size.width)
  }

  private func width(for attributedTitle: NSAttributedString, height: CGFloat) -> CGFloat {
    let size = attributedTitle.boundingRect(
      with: CGSize(width: .greatestFiniteMagnitude, height: height),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil
    ).size
    return ceil(size.width)
  }

  //MARK: JXSegmentedViewDataSource

  open override func registerCellClass(in segmentedView: JXSegmentedView) {
    segmentedView.collectionView.register(JXSegmentedTitleCell.self, forCellWithReuseIdentifier: "titleCell")
    segmentedView.collectionView.register(__SegmentedImageCell.self, forCellWithReuseIdentifier: "imageCell")
    segmentedView.collectionView.register(__SegmentedTitleImageCell.self, forCellWithReuseIdentifier: "titleImageCell")
    segmentedView.collectionView.register(JXSegmentedNumberCell.self, forCellWithReuseIdentifier: "numberCell")
    segmentedView.collectionView.register(JXSegmentedDotCell.self, forCellWithReuseIdentifier: "dotCell")
    segmentedView.collectionView.register(JXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "titleAttributeCell")
  }

  open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
    let cell: JXSegmentedBaseCell
    let item = items[index]
    switch item {
    case .title:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleCell", at: index)
    case .image:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "imageCell", at: index)
    case .titleImage:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleImageCell", at: index)
    case .titleBadgeNumber:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "numberCell", at: index)
    case .titleDot:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dotCell", at: index)
    case .attributedTitle:
      cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleAttributeCell", at: index)
    }
    return cell
  }
}
