//
//  TabBarButton.swift
//  TimePad
//
//  Created by yxgg on 28/05/22.
//

import UIKit

class TabBarButton: UIButton {
  var image: UIImage?
  var darkImage: UIImage?
  var disabledImage: UIImage?
  var darkDisabledImage: UIImage?
  
  convenience init(image: UIImage?, darkImage: UIImage? = nil, disabledImage: UIImage?, darkDisabledImage: UIImage? = nil) {
    self.init(type: .system)
    self.image = image
    self.darkImage = darkImage ?? image
    self.disabledImage = disabledImage
    self.darkDisabledImage = darkDisabledImage ?? disabledImage
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      setupColor()
    }
  }
  
  private func setup() {
    setupColor()
    setTitle(nil, for: .normal)
  }
  
  fileprivate func setupColor() {
    let image: UIImage?
    let disabledImage: UIImage?
    image = traitCollection.userInterfaceStyle == .dark ? darkImage : self.image
    disabledImage = traitCollection.userInterfaceStyle == .dark ? darkDisabledImage : self.disabledImage
    setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    setImage(disabledImage?.withRenderingMode(.alwaysOriginal), for: .disabled)
  }
}
