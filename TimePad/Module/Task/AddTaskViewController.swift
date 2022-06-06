//
//  AddTaskViewController.swift
//  TimePad
//
//  Created by yxgg on 29/05/22.
//

import UIKit
import RealmSwift

class AddTaskViewController: BaseViewController {
  var selectedCategory: Category?
  var selectedTag: Tag?
  
  // MARK: - Views
  lazy var titleTitleLabel: UILabel = {
    let titleTitleLabel = UILabel()
    titleTitleLabel.text = "Task Title"
    titleTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    return titleTitleLabel
  }()
  
  lazy var titleTextField: UITextField = {
    let titleTextField = UITextField()
    titleTextField.placeholder = "Title"
    titleTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    titleTextField.borderStyle = .none
    return titleTextField
  }()
  
  lazy var lineView: UIView = {
    let lineView = UIView()
    lineView.backgroundColor = .systemGray
    return lineView
  }()
  
  lazy var categoryTitleLabel: UILabel = {
    let categoryTitleLabel = UILabel()
    categoryTitleLabel.text = "Category"
    categoryTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    return categoryTitleLabel
  }()
  
  lazy var categoryStackView: UIStackView = {
    let categoryStackView = UIStackView()
    categoryStackView.axis = .horizontal
    categoryStackView.distribution = .fill
    categoryStackView.alignment = .fill
    categoryStackView.spacing = 12
    return categoryStackView
  }()
  
  lazy var tagTitleLabel: UILabel = {
    let tagTitleLabel = UILabel()
    tagTitleLabel.text = "Tag"
    tagTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    return tagTitleLabel
  }()
  
  lazy var tagStackView: UIStackView = {
    let tagStackView = UIStackView()
    tagStackView.axis = .horizontal
    tagStackView.distribution = .fill
    tagStackView.alignment = .fill
    tagStackView.spacing = 12
    return tagStackView
  }()
  
  lazy var saveButton: UIButton = {
    let saveButton = UIButton(type: .system)
    saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    saveButton.setTitle("Save", for: .normal)
    saveButton.layer.cornerRadius = 8
    saveButton.layer.masksToBounds = true
    let color = traitCollection.userInterfaceStyle
    saveButton.backgroundColor = color == .dark ? UIColor(rgb: 0x1B143F) : UIColor(rgb: 0xE9E9FF)
    saveButton.setTitleColor(UIColor.label, for: .normal)
    return saveButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    title = "Add New Task"
    setupTitleTitleLabel()
    setupTitleTextField()
    setupLineView()
    setupCategoryTitleLabel()
    setupCategoryStackView()
    setupTagTitleLabel()
    setupTagStackView()
    setupSaveButton()
  }
  
  private func setupTitleTitleLabel() {
    view.addSubview(titleTitleLabel)
    titleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      titleTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
    ])
  }
  
  private func setupTitleTextField() {
    view.addSubview(titleTextField)
    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      titleTextField.topAnchor.constraint(equalTo: titleTitleLabel.bottomAnchor, constant: 4),
      titleTextField.heightAnchor.constraint(equalToConstant: 36)
    ])
  }
  
  private func setupLineView() {
    view.addSubview(lineView)
    lineView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lineView.heightAnchor.constraint(equalToConstant: 1),
      lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      lineView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor)
    ])
  }
  
  private func setupCategoryTitleLabel() {
    view.addSubview(categoryTitleLabel)
    categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      categoryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      categoryTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      categoryTitleLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16)
    ])
  }
  
  private func setupCategoryStackView() {
    view.addSubview(categoryStackView)
    categoryStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      categoryStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
      categoryStackView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 8)
    ])
    let categories = Category.allCases
    for i in 0..<categories.count {
      let category = categories[i]
      let button = UIButton(type: .system)
      categoryStackView.addArrangedSubview(button)
      button.setImage(category.icon.withRenderingMode(.alwaysOriginal), for: .normal)
      button.setTitle(nil, for: .normal)
      button.layer.cornerRadius = 22
      button.layer.masksToBounds = true
      button.tag = i
      button.addTarget(self, action: #selector(self.categoryButtonTapped(_:)), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 44),
        button.heightAnchor.constraint(equalToConstant: 44)
      ])
    }
  }
  
  private func setupTagTitleLabel() {
    view.addSubview(tagTitleLabel)
    tagTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      tagTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      tagTitleLabel.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16)
    ])
  }
  
  private func setupTagStackView() {
    view.addSubview(tagStackView)
    tagStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      tagStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
      tagStackView.topAnchor.constraint(equalTo: tagTitleLabel.bottomAnchor, constant: 8)
    ])
    let tags = Tag.allCases
    for i in 0..<tags.count {
      let tag = tags[i]
      var configuration = UIButton.Configuration.filled()
      var container = AttributeContainer()
      container.font = UIFont.systemFont(ofSize: 12, weight: .regular)
      configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
      configuration.baseForegroundColor = tag.titleColor
      configuration.baseBackgroundColor = traitCollection.userInterfaceStyle == .dark ? tag.backgroundDarkColor : tag.backgroundColor
      configuration.attributedTitle = AttributedString(tag.name, attributes: container)
      let button = UIButton(configuration: configuration, primaryAction: nil)
      button.tag = i
      button.addTarget(self, action: #selector(self.tagButtonTapped(_:)), for: .touchUpInside)
      button.layer.cornerRadius = 6
      button.layer.masksToBounds = true
      tagStackView.addArrangedSubview(button)
    }
  }
  
  private func setupSaveButton() {
    view.addSubview(saveButton)
    saveButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      saveButton.heightAnchor.constraint(equalToConstant: 60),
      saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
    ])
    saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func save() {
    let presentAlert: (String) -> Void = { (message) in
      let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    
    guard let title = titleTextField.text, !title.isEmpty else {
      presentAlert("Please fill the title.")
      return
    }
    
    guard let category = selectedCategory?.name else {
      presentAlert("Please select category.")
      return
    }
    
    guard let tag = selectedTag?.name else {
      presentAlert("Please select tag.")
      return
    }
    
    let task = Task()
    task.title = title
    task.category = category
    task.tag = tag
    
    let realm = try! Realm()
    try! realm.write({
      realm.add(task)
    })
    print("Realm is located at:", realm.configuration.fileURL!)
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Actions
  @objc private func categoryButtonTapped(_ sender: UIButton) {
    let categories = Category.allCases
    let category = categories[sender.tag]
    selectedCategory = category
    categoryStackView.arrangedSubviews.forEach { view in
      let button = view as! UIButton
      button.isEnabled = button != sender
      if button.isEnabled {
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
      } else {
        let color = traitCollection.userInterfaceStyle
        button.layer.borderColor = (color == .dark ? UIColor.white : UIColor.darkGray).cgColor
        button.layer.borderWidth = 2
      }
    }
  }
  
  @objc private func tagButtonTapped(_ sender: UIButton) {
    let tags = Tag.allCases
    let tag = tags[sender.tag]
    selectedTag = tag
    tagStackView.arrangedSubviews.forEach { view in
      let button = view as! UIButton
      button.isEnabled = button != sender
      if button.isEnabled {
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
      } else {
        button.layer.borderColor = tag.titleColor.cgColor
        button.layer.borderWidth = 2
      }
    }
  }
  
  @objc private func saveButtonTapped(_ sender: UIButton) {
    save()
  }
}

// MARK: - UIViewController
extension UIViewController {
  func presentAddTaskViewController() {
    let viewController = AddTaskViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true, completion: nil)
  }
}
