//
//  TaskViewController.swift
//  TimePad
//
//  Created by yxgg on 30/05/22.
//

import UIKit
import RealmSwift
import ALProgressView

class TaskViewController: BaseViewController {
  weak var finishButton: UIButton!
  weak var deleteButton: UIButton!
  private weak var progressImageView: UIImageView!
  weak var nameLabel: UILabel!
  weak var progressView: ALProgressRing!
  weak var timeLabel: UILabel!
  
  var task: Task!
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startTimer()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    timer?.invalidate()
  }
  
  deinit {
    timer?.invalidate()
  }
  
  func setup() {
    title = task.categoryType?.name
    
    let tag = task.tagType
    var configurationTagButton = UIButton.Configuration.filled()
    var containerTagButton = AttributeContainer()
    containerTagButton.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    guard let tagName = tag?.name else { return }
    configurationTagButton.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    configurationTagButton.baseForegroundColor = tag?.titleColor
    configurationTagButton.baseBackgroundColor = traitCollection.userInterfaceStyle == .dark ? tag?.backgroundDarkColor : tag?.backgroundColor
    configurationTagButton.attributedTitle = AttributedString(tagName, attributes: containerTagButton)
    let tagButton = UIButton(configuration: configurationTagButton, primaryAction: nil)
    tagButton.isUserInteractionEnabled = false
    let barButtonItem = UIBarButtonItem(customView: tagButton)
    navigationItem.rightBarButtonItem = barButtonItem
    
    let progressImageView = UIImageView(image: UIImage(named: "iconProgress"))
    view.addSubview(progressImageView)
    self.progressImageView = progressImageView
    progressImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      progressImageView.widthAnchor.constraint(equalToConstant: 12),
      progressImageView.heightAnchor.constraint(equalToConstant: 12),
      progressImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    ])
    
    let nameLabel = UILabel(frame: .zero)
    view.addSubview(nameLabel)
    self.nameLabel = nameLabel
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 12),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      nameLabel.centerYAnchor.constraint(equalTo: progressImageView.centerYAnchor),
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
    ])
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    nameLabel.text = task.title
    
    let deleteButton = UIButton(type: .system)
    view.addSubview(deleteButton)
    self.deleteButton = deleteButton
    deleteButton.setTitle("Delete", for: .normal)
    
    deleteButton.setTitleColor(UIColor.red, for: .normal)
    deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      deleteButton.heightAnchor.constraint(equalToConstant: 60),
      deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
    ])
    
    let finishButton = UIButton(type: .system)
    view.addSubview(finishButton)
    self.finishButton = finishButton
    finishButton.setTitle(task.start == nil ? "Start" : "Finish", for: .normal)
    
    let isDark: Bool
    isDark = traitCollection.userInterfaceStyle == .dark
    
    finishButton.setTitleColor(isDark ? UIColor.white : UIColor(rgb: 0x070417), for: .normal)
    finishButton.backgroundColor = isDark ? UIColor(rgb: 0x1B143F) : UIColor(rgb: 0xE9E9FF)
    finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    finishButton.layer.cornerRadius = 8
    finishButton.layer.masksToBounds = true
    finishButton.addTarget(self, action: #selector(self.finishButtonTapped(_:)), for: .touchUpInside)
    finishButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      finishButton.heightAnchor.constraint(equalToConstant: 60),
      finishButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16)
    ])
    
    let progressView = ALProgressRing()
    view.addSubview(progressView)
    self.progressView = progressView
    progressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      progressView.widthAnchor.constraint(equalToConstant: 220),
      progressView.heightAnchor.constraint(equalToConstant: 220),
      progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    progressView.startColor = UIColor(rgb: 0xA862EF)
    progressView.endColor = UIColor(rgb: 0x7012CE)
    progressView.grooveColor = traitCollection.userInterfaceStyle == .dark ? UIColor(rgb: 0x1B143F) : UIColor(rgb: 0xE9E9FF)
    progressView.lineWidth = 20
    
    let timeLabel = UILabel(frame: .zero)
    view.addSubview(timeLabel)
    self.timeLabel = timeLabel
    timeLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
      timeLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
    ])
    timeLabel.text = "00:00"
  }
  
  // MARK: - Helpers
  
  func start() {
    guard task.start == nil else { return }
    
    let realm = try! Realm()
    try! realm.write({
      task.start = Date()
    })
    
    finishButton.setTitle("Finish", for: .normal)
    
    startTimer()
  }
  
  func finish() {
    guard task.start != nil, task.finish == nil else { return }
    
    let realm = try! Realm()
    try! realm.write({
      task.finish = Date()
    })
    
    timer?.invalidate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  func delete() {
    timer?.invalidate()
    
    let realm = try! Realm()
    try! realm.write {
      realm.delete(task)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  func startTimer() {
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
      self?.updateTimerUI()
    })
  }
  
  func updateTimerUI() {
    guard let start = task.start else { return }
    
    let maxInterval: Float = 3600
    let timeInterval = Date().timeIntervalSince(start)
    timeLabel.text = timeInterval.simpleDurationString
    
    progressView.setProgress(min(1, Float(timeInterval) / maxInterval), animated: true)
  }
  
  // MARK: - Actions
  
  @objc func finishButtonTapped(_ sender: UIButton) {
    if task.start == nil {
      start()
    }
    else {
      finish()
    }
  }
  
  @objc func deleteButtonTapped(_ sender: UIButton) {
    delete()
  }
}

// MARK: - UIViewContrller
extension UIViewController {
  func presentTaskViewController(task: Task) {
    let viewController = TaskViewController()
    viewController.task = task
    let navigationController = UINavigationController(rootViewController: viewController)
    
    present(navigationController, animated: true)
  }
}
