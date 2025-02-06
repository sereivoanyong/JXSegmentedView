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

  /// 根据index配置cell的不同属性
  weak open var configuration: JXSegmentedTitleDynamicConfiguration?

  // MARK: Title

  /// label的numberOfLines
  open var titleNumberOfLines: Int = 1
  /// title普通状态的textColor
  open var titleNormalColor: UIColor = .black
  /// title选中状态的textColor
  open var titleSelectedColor: UIColor = .red
  /// title普通状态时的字体
  open var titleNormalFont: UIFont = .systemFont(ofSize: 15)
  /// title选中时的字体。如果不赋值，就默认与titleNormalFont一样
  open var titleSelectedFont: UIFont?
  /// title的颜色是否渐变过渡
  open var isTitleColorGradientEnabled: Bool = false
  /// title是否缩放。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
  open var isTitleZoomEnabled: Bool = false
  /// isTitleZoomEnabled为true才生效。是对字号的缩放，比如titleNormalFont的pointSize为10，放大之后字号就是10*1.2=12。
  open var titleSelectedZoomScale: CGFloat = 1.2
  /// title的线宽是否允许粗细。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
  open var isTitleStrokeWidthEnabled: Bool = false
  /// 用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现），负数越小字体越粗。
  open var titleSelectedStrokeWidth: CGFloat = -2
  /// title是否使用遮罩过渡
  open var isTitleMaskEnabled: Bool = false

  // MARK: Image

  open var titleImageType: JXSegmentedTitleImageType = .rightImage
  /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片网络地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
  open var loadImageClosure: LoadImageClosure?
  /// 图片尺寸
  open var imageSize: CGSize = CGSize(width: 20, height: 20)
  /// title和image之间的间隔
  open var titleImageSpacing: CGFloat = 5
  /// 是否开启图片缩放
  open var isImageZoomEnabled: Bool = false
  /// 图片缩放选中时的scale
  open var imageSelectedZoomScale: CGFloat = 1.2

  // MARK: Number

  /// numberLabel的宽度补偿，numberLabel真实的宽度是文字内容的宽度加上补偿的宽度
  open var numberWidthIncrement: CGFloat = 10
  /// numberLabel的背景色
  open var numberBackgroundColor: UIColor = .red
  /// numberLabel的textColor
  open var numberTextColor: UIColor = .white
  /// numberLabel的font
  open var numberFont: UIFont = UIFont.systemFont(ofSize: 11)
  /// numberLabel的默认位置是center在titleLabel的右上角，可以通过numberOffset控制X、Y轴的偏移
  open var numberOffset: CGPoint = CGPoint.zero
  /// 如果业务需要处理超过999就像是999+，就可以通过这个闭包实现。默认显示不会对number进行处理
  open var numberStringFormatterClosure: ((Int) -> String)?
  /// numberLabel的高度，默认：14
  open var numberHeight: CGFloat = 14

  // MARK: Dot

  /// 红点的size
  open var dotSize = CGSize(width: 10, height: 10)
  /// 红点的圆角值，JXSegmentedViewAutomaticDimension等于dotSize.height/2
  open var dotCornerRadius: CGFloat = JXSegmentedViewAutomaticDimension
  /// 红点的颜色
  open var dotColor = UIColor.red
  /// dotView的默认位置是center在titleLabel的右上角，可以通过dotOffset控制X、Y轴的偏移
  open var dotOffset: CGPoint = CGPoint.zero

  open override func preferredItemCount() -> Int {
    return items.count
  }

  open override func preferredItemModelInstance(at index: Int) -> JXSegmentedBaseItemModel? {
    let item = items[index]
    switch item {
    case .title:
      return JXSegmentedTitleItemModel()
    case .image:
      return JXSegmentedTitleImageItemModel()
    case .titleImage:
      return JXSegmentedTitleImageItemModel()
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
      let _ = itemModel as! JXSegmentedTitleImageItemModel
      return imageSize.width + itemWidthIncrement

    case .titleImage(let title, _, _):
      let itemModel = itemModel as! JXSegmentedTitleImageItemModel
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
      itemModel.textWidth = width(for: title, height: .greatestFiniteMagnitude, font: titleSelectedFont ?? titleNormalFont)

    case .image(let imageSource, let imagePlaceholder):
      let itemModel = itemModel as! JXSegmentedTitleImageItemModel
      itemModel.title = nil
      itemModel.textWidth = 0
      itemModel.normalImageInfo = imageSource?.url?.absoluteString
      itemModel.selectedImageInfo = nil
      itemModel.imagePlaceholder = imagePlaceholder
      itemModel.titleImageType = .onlyImage
      itemModel.loadImageClosure = loadImageClosure ?? { imageView, urlString, placeholder in imageView.setImage(with: urlString, placeholder: placeholder as? any Placeholder) }
      itemModel.imageSize = imageSize
      itemModel.isImageZoomEnabled = isImageZoomEnabled
      itemModel.imageNormalZoomScale = 1
      itemModel.imageSelectedZoomScale = imageSelectedZoomScale
      itemModel.titleImageSpacing = titleImageSpacing
      if index == selectedIndex {
        itemModel.imageCurrentZoomScale = itemModel.imageSelectedZoomScale
      } else {
        itemModel.imageCurrentZoomScale = itemModel.imageNormalZoomScale
      }

    case .titleImage(let title, let imageSource, let imagePlaceholder):
      let itemModel = itemModel as! JXSegmentedTitleImageItemModel
      itemModel.title = title
      itemModel.textWidth = width(for: title, height: .greatestFiniteMagnitude, font: titleSelectedFont ?? titleNormalFont)
      itemModel.normalImageInfo = imageSource?.url?.absoluteString
      itemModel.selectedImageInfo = nil
      itemModel.imagePlaceholder = imagePlaceholder
      itemModel.titleImageType = titleImageType
      itemModel.loadImageClosure = loadImageClosure ?? { imageView, urlString, placeholder in imageView.setImage(with: urlString, placeholder: placeholder as? any Placeholder) }
      itemModel.imageSize = imageSize
      itemModel.isImageZoomEnabled = isImageZoomEnabled
      itemModel.imageNormalZoomScale = 1
      itemModel.imageSelectedZoomScale = imageSelectedZoomScale
      itemModel.titleImageSpacing = titleImageSpacing
      if index == selectedIndex {
        itemModel.imageCurrentZoomScale = itemModel.imageSelectedZoomScale
      } else {
        itemModel.imageCurrentZoomScale = itemModel.imageNormalZoomScale
      }

    case .titleBadgeNumber(let title, let badgeNumber):
      let itemModel = itemModel as! JXSegmentedNumberItemModel
      itemModel.title = title
      itemModel.textWidth = width(for: title, height: .greatestFiniteMagnitude, font: titleSelectedFont ?? titleNormalFont)
      itemModel.number = badgeNumber
      if let numberStringFormatterClosure {
        itemModel.numberString = numberStringFormatterClosure(badgeNumber)
      } else {
        itemModel.numberString = "\(badgeNumber)"
      }
      itemModel.numberTextColor = numberTextColor
      itemModel.numberBackgroundColor = numberBackgroundColor
      itemModel.numberOffset = numberOffset
      itemModel.numberWidthIncrement = numberWidthIncrement
      itemModel.numberHeight = numberHeight
      itemModel.numberFont = numberFont

    case .titleDot(let title, let showsDot):
      let itemModel = itemModel as! JXSegmentedDotItemModel
      itemModel.title = title
      itemModel.textWidth = width(for: title, height: .greatestFiniteMagnitude, font: titleSelectedFont ?? titleNormalFont)
      itemModel.dotOffset = dotOffset
      itemModel.dotState = showsDot
      itemModel.dotColor = dotColor
      itemModel.dotSize = dotSize
      if dotCornerRadius == JXSegmentedViewAutomaticDimension {
        itemModel.dotCornerRadius = dotSize.height/2
      }else {
        itemModel.dotCornerRadius = dotCornerRadius
      }

    case .attributedTitle(let attributedTitle):
      let itemModel = itemModel as! JXSegmentedTitleAttributeItemModel
      itemModel.attributedTitle = attributedTitle
      itemModel.selectedAttributedTitle = nil
      itemModel.textWidth = width(for: attributedTitle, height: .greatestFiniteMagnitude)
      itemModel.titleNumberOfLines = titleNumberOfLines
    }

    if let itemModel = itemModel as? JXSegmentedTitleItemModel {
      itemModel.titleNumberOfLines = innerTitleNumberOfLines(at: index)
      itemModel.isSelectedAnimable = isSelectedAnimable
      itemModel.titleNormalColor = innerTitleNormalColor(at: index)
      itemModel.titleSelectedColor = innerTitleSelectedColor(at: index)
      itemModel.titleNormalFont = innerTitleNormalFont(at: index)
      if let selectedFont = innerTitleSelectedFont(at: index) {
        itemModel.titleSelectedFont = selectedFont
      } else {
        itemModel.titleSelectedFont = innerTitleNormalFont(at: index)
      }
      itemModel.isTitleZoomEnabled = isTitleZoomEnabled
      itemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
      itemModel.isTitleMaskEnabled = isTitleMaskEnabled
      itemModel.titleNormalZoomScale = 1
      itemModel.titleSelectedZoomScale = titleSelectedZoomScale
      itemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
      itemModel.titleNormalStrokeWidth = 0
      if index == selectedIndex {
        itemModel.titleCurrentColor = innerTitleSelectedColor(at: index)
        itemModel.titleCurrentZoomScale = titleSelectedZoomScale
        itemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
      }else {
        itemModel.titleCurrentColor = innerTitleNormalColor(at: index)
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
    segmentedView.collectionView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "imageCell")
    segmentedView.collectionView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "titleImageCell")
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

  open override func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
    super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

    if let leftItemModel = leftItemModel as? JXSegmentedTitleItemModel, let rightItemModel = rightItemModel as? JXSegmentedTitleItemModel {
      if isTitleZoomEnabled && isItemTransitionEnabled {
        leftItemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: leftItemModel.titleSelectedZoomScale, to: leftItemModel.titleNormalZoomScale, percent: CGFloat(percent))
        rightItemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: rightItemModel.titleNormalZoomScale, to: rightItemModel.titleSelectedZoomScale, percent: CGFloat(percent))
      }

      if isTitleStrokeWidthEnabled && isItemTransitionEnabled {
        leftItemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: leftItemModel.titleSelectedStrokeWidth, to: leftItemModel.titleNormalStrokeWidth, percent: CGFloat(percent))
        rightItemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: rightItemModel.titleNormalStrokeWidth, to: rightItemModel.titleSelectedStrokeWidth, percent: CGFloat(percent))
      }

      if isTitleColorGradientEnabled && isItemTransitionEnabled {
        leftItemModel.titleCurrentColor = JXSegmentedViewTool.interpolateThemeColor(from: leftItemModel.titleSelectedColor, to: leftItemModel.titleNormalColor, percent: percent)
        rightItemModel.titleCurrentColor = JXSegmentedViewTool.interpolateThemeColor(from:rightItemModel.titleNormalColor , to:rightItemModel.titleSelectedColor, percent: percent)
      }
    }

    if let leftItemModel = leftItemModel as? JXSegmentedTitleImageItemModel, let rightItemModel = rightItemModel as? JXSegmentedTitleImageItemModel {
      if isImageZoomEnabled && isItemTransitionEnabled {
        leftItemModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: imageSelectedZoomScale, to: 1, percent: CGFloat(percent))
        rightItemModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: imageSelectedZoomScale, percent: CGFloat(percent))
      }
    }
  }

  open override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
    super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

    if let currentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleItemModel, let willSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleItemModel {
      currentSelectedItemModel.titleCurrentColor = currentSelectedItemModel.titleNormalColor
      currentSelectedItemModel.titleCurrentZoomScale = currentSelectedItemModel.titleNormalZoomScale
      currentSelectedItemModel.titleCurrentStrokeWidth = currentSelectedItemModel.titleNormalStrokeWidth
      currentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

      willSelectedItemModel.titleCurrentColor = willSelectedItemModel.titleSelectedColor
      willSelectedItemModel.titleCurrentZoomScale = willSelectedItemModel.titleSelectedZoomScale
      willSelectedItemModel.titleCurrentStrokeWidth = willSelectedItemModel.titleSelectedStrokeWidth
    }

    if let currentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleImageItemModel, let willSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleImageItemModel {
      currentSelectedItemModel.imageCurrentZoomScale = currentSelectedItemModel.imageNormalZoomScale
      willSelectedItemModel.imageCurrentZoomScale = willSelectedItemModel.imageSelectedZoomScale
    }
  }

  // MARK: - Configuration

  private func innerTitleNumberOfLines(at index: Int) -> Int {
    if let configuration {
      return configuration.titleNumberOfLines(at: index)
    } else {
      return titleNumberOfLines
    }
  }
  private func innerTitleNormalColor(at index: Int) -> UIColor {
    if let configuration {
      return configuration.titleNormalColor(at: index)
    } else {
      return titleNormalColor
    }
  }
  private func innerTitleSelectedColor(at index: Int) -> UIColor {
    if let configuration {
      return configuration.titleSelectedColor(at: index)
    } else {
      return titleSelectedColor
    }
  }
  private func innerTitleNormalFont(at index: Int) -> UIFont {
    if let configuration {
      return configuration.titleNormalFont(at: index)
    } else {
      return titleNormalFont
    }
  }
  private func innerTitleSelectedFont(at index: Int) -> UIFont? {
    if let configuration {
      return configuration.titleSelectedFont(at: index)
    } else {
      return titleSelectedFont
    }
  }
}

extension UIImageView {

  func setImage(with urlString: String, placeholder: (any Placeholder)? = nil) {
    kf.setImage(with: URL(string: urlString).map { .network($0) }, placeholder: placeholder)
  }
}
