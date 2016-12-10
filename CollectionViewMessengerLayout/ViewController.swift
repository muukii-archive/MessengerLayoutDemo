//
//  ViewController.swift
//  CollectionViewMessengerLayout
//
//  Created by muukii on 2016/12/10.
//  Copyright © 2016 muukii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  let messages: [Message] = [
    Message(body: "1", fromMe: true),
    Message(body: "2", fromMe: true),
    Message(body: "3", fromMe: false),
    Message(body: "4", fromMe: true),
    Message(body: "5", fromMe: false),
    Message(body: "6", fromMe: false),
    Message(body: "7", fromMe: false),
    Message(body: "8", fromMe: true),
    Message(body: "9", fromMe: true),
    Message(body: "10", fromMe: true),

    Message(body: "11", fromMe: true),
    Message(body: "12", fromMe: false),
    Message(body: "13", fromMe: true),
    Message(body: "14", fromMe: false),
    Message(body: "15", fromMe: true),
    Message(body: "16", fromMe: false),
    Message(body: "17", fromMe: true),
    Message(body: "18", fromMe: false),
    Message(body: "19", fromMe: true),
    Message(body: "20", fromMe: true),
  ]

  func getMessage(indexPath: IndexPath) -> (Message, MessageGrouping) {
    let message = messages[indexPath.item]

    let previousMessage = messages[safe: indexPath.item - 1]
    let nextMessage = messages[safe: indexPath.item + 1]

    let grouping: MessageGrouping

    if message.fromMe == previousMessage?.fromMe && message.fromMe == nextMessage?.fromMe {
      grouping = .middle
    } else if message.fromMe == previousMessage?.fromMe {
      grouping = .bottom
    } else if message.fromMe == nextMessage?.fromMe {
      grouping = .top
    } else {
      grouping = .none
    }

    return (message, grouping)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(cellType: RightCell.self)
    collectionView.register(cellType: LeftCell.self)

    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let (message, grouping) = getMessage(indexPath: indexPath)

    if message.fromMe {
      let cell = collectionView.dequeueReusableCell(for: indexPath) as RightCell
      cell.set(message: message, grouping: grouping)
      return cell

    } else {
      let cell = collectionView.dequeueReusableCell(for: indexPath) as LeftCell
      cell.set(message: message, grouping: grouping)

      return cell
    }
  }
}

extension ViewController: CollectionViewMessengerLayoutDelegate {

  func size(indexPath: IndexPath) -> MessageLayout {

    let (message, grouping) = getMessage(indexPath: indexPath)

    if message.fromMe {
      let size = CGSize(width: 100, height: 40)
      return .right(size, grouping)
    } else {
      let size = CGSize(width: 100, height: 40)
      return .left(size, grouping)
    }
  }
}

extension Array {
  subscript (safe index: Int) -> Element? {
    guard index >= 0 else {
      return nil
    }
    return index < count ? self[index] : nil
  }
}
