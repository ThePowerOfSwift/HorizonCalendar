// Created by Bryan Keller on 6/15/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit

// MARK: - TooltipView

final class TooltipView: UIView, CalendarItemViewRepresentable {

  // MARK: Lifecycle

  init(invariantViewProperties: InvariantViewProperties) {
    super.init(frame: .zero)

    addSubview(backgroundView)

    addSubview(label)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  func setViewModel(_ viewModel: ViewModel) {
    label.text = viewModel.text
    frameOfTooltippedItem = viewModel.frameOfTooltippedItem
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    guard let frameOfTooltippedItem = frameOfTooltippedItem else { return }

    label.sizeToFit()
    let labelSize = CGSize(
      width: min(label.bounds.size.width, bounds.width),
      height: label.bounds.size.height)

    let backgroundSize = CGSize(width: labelSize.width + 16, height: labelSize.height + 16)

    let proposedFrame = CGRect(
      x: frameOfTooltippedItem.midX - (backgroundSize.width / 2),
      y: frameOfTooltippedItem.minY - backgroundSize.height - 4,
      width: backgroundSize.width,
      height: backgroundSize.height)

    let frame: CGRect
    if proposedFrame.maxX > bounds.width {
      frame = proposedFrame.applying(.init(translationX: bounds.width - proposedFrame.maxX, y: 0))
    } else if proposedFrame.minX < 0 {
      frame = proposedFrame.applying(.init(translationX: -proposedFrame.minX, y: 0))
    } else {
      frame = proposedFrame
    }

    backgroundView.frame = frame
    label.center = backgroundView.center
  }

  // MARK: Private

  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 1
    view.layer.cornerRadius = 6
    return view
  }()

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.lineBreakMode = .byTruncatingTail
    label.textColor = .black
    return label
  }()

  private var frameOfTooltippedItem: CGRect? {
    didSet {
      guard frameOfTooltippedItem != oldValue else { return }
      setNeedsLayout()
    }
  }

}

// MARK: - InvariantViewProperties

extension TooltipView {

  struct InvariantViewProperties: Hashable { }

}

// MARK: - ViewModel

extension TooltipView {

  struct ViewModel: Equatable {
    let text: String
    let frameOfTooltippedItem: CGRect?
  }

}
