//
//  JXSegmentedItem.swift
//  JXSegmentedView
//
//  Created by Sereivoan Yong on 2/6/25.
//

import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif

public enum JXSegmentedItem {

  case title(String)
#if canImport(Kingfisher)
  case image(Source?, Placeholder? = nil)
  case titleImage(String, Source?, Placeholder? = nil)
#else
  case image(UIImage?)
  case titleImage(String, UIImage?)
#endif
  case titleBadgeNumber(String, Int)
  case titleDot(String, Bool)
  case attributedTitle(NSAttributedString)

  public var title: String? {
    switch self {
    case .title(let title):
      return title
    case .image:
      return nil
#if canImport(Kingfisher)
    case .titleImage(let title, _, _):
      return title
#else
    case .titleImage(let title, _):
      return title
#endif
    case .titleBadgeNumber(let title, _):
      return title
    case .titleDot(let title, _):
      return title
    case .attributedTitle:
      return nil
    }
  }

#if canImport(Kingfisher)
  public var imageSource: Source? {
    switch self {
    case .title:
      return nil
    case .image(let source, _):
      return source
    case .titleImage(_, let source, _):
      return source
    case .titleBadgeNumber:
      return nil
    case .titleDot:
      return nil
    case .attributedTitle:
      return nil
    }
  }

  public var imagePlaceholder: Placeholder? {
    switch self {
    case .title:
      return nil
    case .image(_, let placeholder):
      return placeholder
    case .titleImage(_, _, let placeholder):
      return placeholder
    case .titleBadgeNumber:
      return nil
    case .titleDot:
      return nil
    case .attributedTitle:
      return nil
    }
  }
#else

  public var image: UIImage? {
    switch self {
    case .title:
      return nil
    case .image(let image):
      return image
    case .titleImage(_, let image):
      return image
    case .titleBadgeNumber:
      return nil
    case .titleDot:
      return nil
    case .attributedTitle:
      return nil
    }
  }
#endif

  public var badgeNumber: Int? {
    switch self {
    case .title:
      return nil
    case .image:
      return nil
    case .titleImage:
      return nil
    case .titleBadgeNumber(_, let badgeNumber):
      return badgeNumber
    case .titleDot:
      return nil
    case .attributedTitle:
      return nil
    }
  }

  public var showsDot: Bool? {
    switch self {
    case .title:
      return nil
    case .image:
      return nil
    case .titleImage:
      return nil
    case .titleBadgeNumber:
      return nil
    case .titleDot(_, let showsDot):
      return showsDot
    case .attributedTitle:
      return nil
    }
  }

  public var attributedTitle: NSAttributedString? {
    switch self {
    case .title:
      return nil
    case .image:
      return nil
    case .titleImage:
      return nil
    case .titleBadgeNumber:
      return nil
    case .titleDot:
      return nil
    case .attributedTitle(let attributedTitle):
      return attributedTitle
    }
  }
}
