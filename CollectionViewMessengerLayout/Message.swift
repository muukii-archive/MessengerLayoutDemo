//
//  Message.swift
//  CollectionViewMessengerLayout
//
//  Created by muukii on 2016/12/10.
//  Copyright © 2016 muukii. All rights reserved.
//

import Foundation

class Message {
  let body: String
  let fromMe: Bool

  init(body: String, fromMe: Bool) {
    self.body = body
    self.fromMe = fromMe
  }
}
