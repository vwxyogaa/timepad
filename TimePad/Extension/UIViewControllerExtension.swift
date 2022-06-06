//
//  UIViewControllerExtension.swift
//  TimePad
//
//  Created by yxgg on 27/05/22.
//

import UIKit

// MARK: - Containment
extension UIViewController {
  // add child to parent
  func add(_ child: UIViewController, view: UIView? = nil) {
    let containerView: UIView! = view ?? self.view
    addChild(child)
    containerView.addSubview(child.view)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    // untuk me-trigger fungsi fungsi di view controller yang dipanggil, example: viewwillappear, dll
    child.didMove(toParent: self)
  }
  
  // remove child from parent
  func remove() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    view.removeFromSuperview()
    // agar tidak ada yang nyangkut mungkin
    removeFromParent()
  }
}

// MARK: - Back & Close
extension UIViewController {
  func addCloseButton() {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(named: "btnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
    backButton.addTarget(self, action: #selector(self.closeButtonTapped(_:)), for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = barButtonItem
  }
  
  func addBackButton() {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(named: "btnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
    backButton.addTarget(self, action: #selector(self.backButtonTapped(_:)), for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = barButtonItem
  }
  
  @objc private func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func backButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}
