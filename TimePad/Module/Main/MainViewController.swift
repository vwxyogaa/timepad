//
//  MainViewController.swift
//  TimePad
//
//  Created by yxgg on 27/05/22.
//

import UIKit

class MainViewController: BaseViewController {
  lazy var homeViewController: UIViewController = {
    let navigationController = UINavigationController(rootViewController: HomeViewController())
    return navigationController
  }()
  
  lazy var chartViewController: UIViewController = {
    let navigationController = UINavigationController(rootViewController: ChartViewController())
    return navigationController
  }()
  
  // MARK: - Views
  private lazy var tabBarView: TabBarView = {
    let tabBarView = TabBarView(cornerRadius: 30, color: UIColor.tabBarLight, darkColor: UIColor.tabBarDark)
    return tabBarView
  }()
  
  private lazy var homeButton: TabBarButton = {
    let homeButton = TabBarButton(image: UIImage(named: "tabTime"), disabledImage: UIImage(named: "tabTimeActive"), darkDisabledImage: UIImage(named: "tabTimeActiveDark"))
    return homeButton
  }()
  
  private lazy var addTaskButton: TabBarButton = {
    let addTaskButton = TabBarButton(image: UIImage(named: "tabAdd"), disabledImage: nil)
    return addTaskButton
  }()
  
  private lazy var chartButton: TabBarButton = {
    let chartButton = TabBarButton(image: UIImage(named: "tabChart"), disabledImage: UIImage(named: "tabChartActive"), darkDisabledImage: UIImage(named: "tabChartActiveDark"))
    return chartButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    tabBarView.selectedIndex = 0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    homeViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarView.frame.height + 24, right: 0)
    chartViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarView.frame.height + 24, right: 0)
  }
  
  // MARK: - Helper
  private func setupView() {
    setupTabBar()
  }
  
  private func setupTabBar() {
    view.addSubview(tabBarView)
    tabBarView.delegate = self
    tabBarView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
      tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tabBarView.items = [homeButton, addTaskButton, chartButton]
  }
  
  private func showHome() {
    chartViewController.remove()
    add(homeViewController)
    view.bringSubviewToFront(tabBarView)
  }
  
  private func showChart() {
    homeViewController.remove()
    add(chartViewController)
    view.bringSubviewToFront(tabBarView)
  }
  
  private func addTask() {
    presentAddTaskViewController()
  }
}

// MARK: - TabBarViewDelegate
extension MainViewController: TabBarViewDelegate {
  func tabBarView(_ view: TabBarView, didSelectItemAt index: Int) {
    switch index {
    case 0:
      showHome()
    case 1:
      addTask()
    case 2:
      showChart()
    default:
      break
    }
  }
  
  func tabBarView(_ view: TabBarView, shouldSelectItemAt index: Int) -> Bool {
    return index != 1
  }
}
