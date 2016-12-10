//
//  CollectionViewMessengerLayout.swift
//  CollectionViewMessengerLayout
//
//  Created by muukii on 2016/12/10.
//  Copyright © 2016 muukii. All rights reserved.
//

import UIKit

enum MessageGrouping {
  case none
  case top
  case middle
  case bottom
}

enum MessageLayout {

  case right(CGSize, MessageGrouping)
  case left(CGSize, MessageGrouping)
}

protocol CollectionViewMessengerLayoutDelegate: UICollectionViewDelegate {

  func size(indexPath: IndexPath) -> MessageLayout
}

final class CollectionViewMessengerLayout: UICollectionViewLayout {

  var attributesArray: [[UICollectionViewLayoutAttributes]] = [[]]

  var delegate: CollectionViewMessengerLayoutDelegate? {
    return collectionView?.delegate as? CollectionViewMessengerLayoutDelegate
  }

  override func prepare() {

    let sectionCount
      = collectionView!.numberOfSections

    var lastAttributes: UICollectionViewLayoutAttributes?

    for section in stride(from: 0, to: sectionCount, by: 1) {

      let itemCount = collectionView!.numberOfItems(inSection: section)

      var _attributesArray: [UICollectionViewLayoutAttributes] = []

      for item in stride(from: 0, to: itemCount, by: 1) {

        let indexPath = IndexPath(item: item, section: section)

        let messageSize = delegate!.size(indexPath: indexPath)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let collectionViewWidth = collectionView!.bounds.width

        let topMargin: (MessageGrouping) -> CGFloat = {
          switch $0 {
          case .none:
            return 8
          case .top:
            return 8
          case .middle:
            return 0
          case .bottom:
            return 0
          }
        }

        switch messageSize {
        case let .right(size, grouping):

          attributes.size = size
          attributes.frame.origin.x = collectionViewWidth - size.width
          attributes.frame.origin.y = (lastAttributes?.frame.maxY ?? 0) + topMargin(grouping)

        case let .left(size, grouping):
          attributes.size = size
          attributes.frame.origin.x = 0
          attributes.frame.origin.y = (lastAttributes?.frame.maxY ?? 0) + topMargin(grouping)
        }

        _attributesArray.append(attributes)

        lastAttributes = attributes
      }

      attributesArray.append(_attributesArray)
    }

    print("prepare")
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    print("layoutAttributesForElements", rect)
    return attributesArray.flatMap { $0 }
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    print("layoutAttributesForItem", indexPath)

    return nil
  }

  override var collectionViewContentSize: CGSize {
    guard let lastAttributes = attributesArray.flatMap({ $0 }).last else {
      return CGSize(width: collectionView!.bounds.width, height: 0)
    }
    return CGSize(width: collectionView!.bounds.width, height: lastAttributes.frame.maxY)
  }
}
