//
//  HistoryTableViewCell.swift
//  TimePad
//
//  Created by yxgg on 28/05/22.
//

import UIKit

protocol HistoryTableViewCellDelegate: NSObjectProtocol {
  func historyTableViewCellPlayButtonTapped(_ cell: HistoryTableViewCell)
}

class HistoryTableViewCell: UITableViewCell {
  weak var delegate: HistoryTableViewCellDelegate?
  
  var tagType: Tag? {
    didSet { setupCategories() }
  }
  
  var categoryType: Category? {
    didSet { setupCategories() }
  }
  
  // MARK: - Views
  lazy var containerView: UIView = {
    let containerView = UIView()
    containerView.layer.cornerRadius = 12
    containerView.layer.masksToBounds = true
    return containerView
  }()
  
  lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    return iconImageView
  }()
  
  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    return nameLabel
  }()
  
  lazy var timeLabel: UILabel = {
    let timeLabel = UILabel()
    timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    return timeLabel
  }()
  
  lazy var categoryStackView: UIStackView = {
    let categoryStackView = UIStackView()
    categoryStackView.axis = .horizontal
    categoryStackView.distribution = .fill
    categoryStackView.alignment = .fill
    categoryStackView.spacing = 8
    return categoryStackView
  }()
  
  lazy var playButton: UIButton = {
    let playButton = UIButton(type: .system)
    playButton.setImage(UIImage(named: "btnPlay")?.withRenderingMode(.alwaysOriginal), for: .normal)
    playButton.setTitle(nil, for: .normal)
    return playButton
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
    setupIconImageView()
    setupNameLabel()
    setupTimeLabel()
    setupCategoryStackView()
    setupPlayButton()
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
  
  private func setupIconImageView() {
    containerView.addSubview(iconImageView)
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconImageView.widthAnchor.constraint(equalToConstant: 44),
      iconImageView.heightAnchor.constraint(equalToConstant: 44),
      iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
    ])
  }
  
  private func setupNameLabel() {
    containerView.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
    ])
  }
  
  private func setupTimeLabel() {
    containerView.addSubview(timeLabel)
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
      timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
    ])
  }
  
  private func setupCategoryStackView() {
    containerView.addSubview(categoryStackView)
    categoryStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      categoryStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
      categoryStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      categoryStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
    ])
  }
  
  private func setupPlayButton() {
    containerView.addSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      playButton.widthAnchor.constraint(equalToConstant: 24),
      playButton.heightAnchor.constraint(equalToConstant: 24),
      playButton.leadingAnchor.constraint(greaterThanOrEqualTo: categoryStackView.trailingAnchor, constant: 16),
      playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      playButton.centerYAnchor.constraint(equalTo: categoryStackView.centerYAnchor)
    ])
    playButton.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupColor() {
    let isDark = traitCollection.userInterfaceStyle == .dark
    containerView.backgroundColor = isDark ? UIColor.cellBackgroundDark : UIColor.cellBackgroundLight
    timeLabel.textColor = isDark ? UIColor.textGrayDark : UIColor.textGrayLight
  }
  
  private func setupCategories() {
    categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    let color = traitCollection.userInterfaceStyle
    
    var configurationCategoryButton = UIButton.Configuration.filled()
    var containerCategoryButton = AttributeContainer()
    containerCategoryButton.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    guard let categoryName = categoryType?.name else { return }
    configurationCategoryButton.attributedTitle = AttributedString(categoryName, attributes: containerCategoryButton)
    configurationCategoryButton.baseBackgroundColor = color == .dark ? categoryType?.backgroundDarkColor : categoryType?.backgroundColor
    configurationCategoryButton.baseForegroundColor = categoryType?.titleColor
    configurationCategoryButton.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    let categoryButton = UIButton(configuration: configurationCategoryButton, primaryAction: nil)
    categoryButton.isUserInteractionEnabled = false
    categoryStackView.addArrangedSubview(categoryButton)
    
    var configurationTagButton = UIButton.Configuration.filled()
    var containerTagButton = AttributeContainer()
    containerTagButton.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    guard let tagName = tagType?.name else { return }
    configurationTagButton.attributedTitle = AttributedString(tagName, attributes: containerTagButton)
    configurationTagButton.baseBackgroundColor = color == .dark ? tagType?.backgroundDarkColor : tagType?.backgroundColor
    configurationTagButton.baseForegroundColor = tagType?.titleColor
    configurationTagButton.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    let tagButton = UIButton(configuration: configurationTagButton, primaryAction: nil)
    tagButton.isUserInteractionEnabled = false
    categoryStackView.addArrangedSubview(tagButton)
  }
  
  // MARK: - Actions
  @objc private func playButtonTapped(_ sender: Any) {
    delegate?.historyTableViewCellPlayButtonTapped(self)
  }
}
