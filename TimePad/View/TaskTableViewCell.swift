//
//  TaskTableViewCell.swift
//  TimePad
//
//  Created by yxgg on 28/05/22.
//

import UIKit

protocol TaskTableViewCellDelegate: NSObjectProtocol {
  func taskTableViewCellTimeString(_ cell: TaskTableViewCell) -> String
}

class TaskTableViewCell: UITableViewCell {
  weak var delegate: TaskTableViewCellDelegate?
  
  var timer: Timer?
  
  var tagType: Tag? {
    didSet { setupCategories() }
  }
  
  var categoryType: Category? {
    didSet { setupCategories() }
  }
  
  deinit {
    stopTimer()
  }
  
  // MARK: - Views
  lazy var containerView: UIView = {
    let containerView = UIView()
    containerView.layer.cornerRadius = 12
    containerView.layer.masksToBounds = true
    return containerView
  }()
  
  lazy var timeLabel: UILabel = {
    let timeLabel = UILabel()
    timeLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
    return timeLabel
  }()
  
  lazy var categoryStackView: UIStackView = {
    let categoryStackView = UIStackView()
    categoryStackView.axis = .horizontal
    categoryStackView.distribution = .fill
    categoryStackView.alignment = .fill
    categoryStackView.spacing = 4
    return categoryStackView
  }()
  
  lazy var progressImageView: UIImageView = {
    let progressImageView = UIImageView()
    progressImageView.image = UIImage(named: "iconProgress")
    return progressImageView
  }()
  
  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return nameLabel
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupColor()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none
    setupContainerView()
    setupTimeLabel()
    setupCategoryStackView()
    setupProgressImageView()
    setupNameLabel()
    setupColor()
  }
  
  private func setupContainerView() {
    contentView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  private func setupTimeLabel() {
    containerView.addSubview(timeLabel)
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
    ])
  }
  
  private func setupCategoryStackView() {
    containerView.addSubview(categoryStackView)
    categoryStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      categoryStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      categoryStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
    ])
  }
  
  private func setupProgressImageView() {
    containerView.addSubview(progressImageView)
    progressImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      progressImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      progressImageView.widthAnchor.constraint(equalToConstant: 12),
      progressImageView.heightAnchor.constraint(equalToConstant: 12)
    ])
  }
  
  private func setupNameLabel() {
    containerView.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: progressImageView.trailingAnchor, constant: 12),
      nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      nameLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
      nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
      nameLabel.centerYAnchor.constraint(equalTo: progressImageView.centerYAnchor)
    ])
  }
  
  private func setupColor() {
    containerView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.cellBackgroundDark : UIColor.cellBackgroundLight
  }
  
  private func setupCategories() {
    categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    let color = traitCollection.userInterfaceStyle
    
    var configurationCategoryButton = UIButton.Configuration.filled()
    var containerCategoryButton = AttributeContainer()
    containerCategoryButton.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    guard let categoryName = categoryType?.name else { return }
    configurationCategoryButton.attributedTitle = AttributedString(categoryName, attributes: containerCategoryButton)
    configurationCategoryButton.baseForegroundColor = categoryType?.titleColor
    configurationCategoryButton.baseBackgroundColor = color == .dark ? categoryType?.backgroundDarkColor : categoryType?.backgroundColor
    configurationCategoryButton.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    let categoryButton = UIButton(configuration: configurationCategoryButton, primaryAction: nil)
    categoryButton.isUserInteractionEnabled = false
    categoryStackView.addArrangedSubview(categoryButton)
    
    var configurationTagButton = UIButton.Configuration.filled()
    var containerTagButton = AttributeContainer()
    containerTagButton.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    guard let tagName = tagType?.name else { return }
    configurationTagButton.attributedTitle = AttributedString(tagName, attributes: containerTagButton)
    configurationTagButton.baseForegroundColor = tagType?.titleColor
    configurationTagButton.baseBackgroundColor = color == .dark ? tagType?.backgroundDarkColor : tagType?.backgroundColor
    configurationTagButton.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    let tagButton = UIButton(configuration: configurationTagButton, primaryAction: nil)
    tagButton.isUserInteractionEnabled = false
    categoryStackView.addArrangedSubview(tagButton)
  }
  
  func startTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
      self?.updateTimerUI()
    })
  }
  
  func stopTimer() {
    timer?.invalidate()
  }
  
  func updateTimerUI() {
    timeLabel.text = delegate?.taskTableViewCellTimeString(self) ?? "00:00:00"
  }
}
