//
//  JXSegmentedItemModel.swift
//  JXSegmentedView
//
//  Created by Sereivoan Yong on 2/6/25.
//

import Foundation
import Kingfisher

open class __SegmentedTitleImageItemModel: JXSegmentedTitleItemModel {

  open var imageSource: Source?

  open var selectedImageSource: Source?

  open var titleImageType: JXSegmentedTitleImageType = .leftImage

  open var imageSize: CGSize = .zero

  open var titleImageSpacing: CGFloat = 0
}

open class __SegmentedImageItemModel: JXSegmentedBaseItemModel {

  open var imageSource: Source?

  open var imagePlaceholder: Placeholder?

  open var imageSize: CGSize = .zero
}
