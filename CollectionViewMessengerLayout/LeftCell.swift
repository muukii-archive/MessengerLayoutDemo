//
//  LeftCell.swift
//  CollectionViewMessengerLayout
//
//  Created by muukii on 2016/12/10.
//  Copyright © 2016 muukii. All rights reserved.
//

import UIKit

import Reusable

class LeftCell: UICollectionViewCell, NibReusable {

  @IBOutlet weak var label: UILabel!

  var grouping: MessageGrouping = .none
  let shapeLayer = CAShapeLayer()

  override func awakeFromNib() {
    super.awakeFromNib()
    layer.insertSublayer(shapeLayer, at: 0)
  }

  func set(message: Message, grouping: MessageGrouping) {
    label.text = message.body
    self.grouping = grouping
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)

    shapeLayer.fillColor = UIColor(white: 0.8, alpha: 1).cgColor

    let radius: CGFloat = 8

    let path: UIBezierPath
    switch grouping {
    case .none:
      path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
    case .top:
      path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .topRight, cornerRadii: CGSize(width: radius, height: radius))
    case .middle:
      path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [], cornerRadii: CGSize(width: radius, height: radius))
    case .bottom:
      path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: radius, height: radius))
    }

    shapeLayer.path = path.cgPath
  }
}
