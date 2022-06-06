//
//  BaseViewController.swift
//  TimePad
//
//  Created by yxgg on 28/05/22.
//

import UIKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      setupColor()
    }
  }
  
  // MARK: - Helpers
  private func setup() {
    navigationController?.navigationBar.prefersLargeTitles = true
    setupColor()
  }
  
  private func setupColor() {
    view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .backgroundDark : .backgroundLight
  }
}
