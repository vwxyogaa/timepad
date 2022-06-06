//
//  HomeViewController.swift
//  TimePad
//
//  Created by yxgg on 27/05/22.
//

import UIKit
import RealmSwift

class HomeViewController: BaseViewController {
  var tasks: Results<Task>!
  var token: NotificationToken!
  
  // MARK: - Views
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    
    let realm = try! Realm()
    tasks = realm.objects(Task.self)
    token = tasks.observe { [weak self] (changes) in
      guard let `self` = self else { return }
      switch changes {
      case .initial:
        break
      case .update(_, let deletions, let insertions, let modifications):
        print("Deleted indices: ", deletions)
        print("Inserted indices: ", insertions)
        print("Modified modifications: ", modifications)
        self.tableView.reloadData()
      case .error(let error):
        fatalError("\(error)")
      }
    }
  }
  
  deinit {
    token.invalidate()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    title = "Task"
    setupTableView()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "taskCellId")
    tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "historyCellId")
  }
  
  private func unfinishedTasks() -> [Task] {
    let filteredTask = tasks.filter { task in
      return task.start == nil || task.finish == nil
    }
    return Array(filteredTask)
  }
  
  private func finishedTasks() -> [Task] {
    let filteredTask = tasks.filter { task in
      return task.start != nil && task.finish != nil
    }
    // sorted descending (agar yang terakhir finish paling atas)
      .sorted { $0.finish! > $1.finish! }
    return Array(filteredTask)
  }
  
  private func duplicateTask(_ task: Task) {
    let newTask = Task()
    newTask.title = task.title
    newTask.tag = task.tag
    newTask.category = task.category
    
    let realm = try! Realm()
    try! realm.write {
      realm.add(newTask)
    }
  }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return unfinishedTasks().count
    case 1:
      return finishedTasks().count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as? TaskTableViewCell {
        let task = unfinishedTasks()[indexPath.row]
        if let start = task.start {
          cell.timeLabel.text = Date().timeIntervalSince(start).durationString
        } else {
          cell.timeLabel.text = "00:00:00"
        }
        cell.categoryType = task.categoryType
        cell.tagType = task.tagType
        cell.nameLabel.text = task.title
        cell.delegate = self
        return cell
      } else {
        return UITableViewCell()
      }
    case 1:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as? HistoryTableViewCell {
        let task = finishedTasks()[indexPath.row]
        let category = task.categoryType
        cell.iconImageView.image = category?.icon
        cell.nameLabel.text = task.title
        if let finish = task.finish, let start = task.start {
          cell.timeLabel.text = finish.timeIntervalSince(start).durationString
        } else {
          cell.timeLabel.text = "00:00:00"
        }
        cell.categoryType = task.categoryType
        cell.tagType = task.tagType
        cell.delegate = self
        return cell
      } else {
        return UITableViewCell()
      }
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 1:
      if !finishedTasks().isEmpty {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Today"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        return view
      } else {
        return UIView()
      }
    default:
      return nil
    }
  }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let task = unfinishedTasks()[indexPath.row]
      presentTaskViewController(task: task)
    default:
      break
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? TaskTableViewCell {
      cell.startTimer()
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? TaskTableViewCell {
      cell.stopTimer()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 1:
      return 56
    default:
      return 0.0001
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.0001
  }
}

// MARK: - HistoryTableViewCellDelegate
extension HomeViewController: HistoryTableViewCellDelegate {
  func historyTableViewCellPlayButtonTapped(_ cell: HistoryTableViewCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let task = finishedTasks()[indexPath.row]
      duplicateTask(task)
    }
  }
}

// MARK: - TaskTableViewCellDelegate
extension HomeViewController: TaskTableViewCellDelegate {
  func taskTableViewCellTimeString(_ cell: TaskTableViewCell) -> String {
    if let indexPath = tableView.indexPath(for: cell) {
      let task = unfinishedTasks()[indexPath.row]
      if let start = task.start {
        return Date().timeIntervalSince(start).durationString
      }
    }
    return "00:00:00"
  }
}
