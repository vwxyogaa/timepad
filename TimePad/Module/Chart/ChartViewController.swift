//
//  ChartViewController.swift
//  TimePad
//
//  Created by yxgg on 27/05/22.
//

import UIKit
import RealmSwift
import Charts

class ChartViewController: BaseViewController {
  var tasks: Results<Task>!
  
  // MARK: - Views
  lazy var containerView: UIView = {
    let containerView = UIView()
    containerView.layer.cornerRadius = 12
    containerView.layer.masksToBounds = true
    return containerView
  }()
  
  lazy var amountTaskCompleteLabel: UILabel = {
    let amountTaskCompleteLabel = UILabel()
    amountTaskCompleteLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    return amountTaskCompleteLabel
  }()
  
  lazy var taskCompleteLabel: UILabel = {
    let taskCompleteLabel = UILabel()
    taskCompleteLabel.text = "Task Completed"
    taskCompleteLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    return taskCompleteLabel
  }()
  
  lazy var chartView: LineChartView = {
    let chartView = LineChartView()
    chartView.chartDescription.enabled = false
    chartView.dragEnabled = true
    chartView.setScaleEnabled(true)
    chartView.pinchZoomEnabled = true
    return chartView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupColor()
  }
  
  // MARK: - Helpers
  private func finishedTasks() -> [Task] {
    guard let filterTask = tasks else { return [] }
    let filteredTask = filterTask.filter { task in
      return task.start != nil && task.finish != nil
    }
    return Array(filteredTask)
  }
  
  private func setupViews() {
    title = "My Productivity"
    setupContainerView()
    setupAmountTaskCompleteLabel()
    setupTaskCompleteLabel()
    setupChartView()
    setupColor()
  }
  
  private func setupContainerView() {
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
    ])
  }
  
  private func setupAmountTaskCompleteLabel() {
    containerView.addSubview(amountTaskCompleteLabel)
    amountTaskCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      amountTaskCompleteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      amountTaskCompleteLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      amountTaskCompleteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
    ])
    amountTaskCompleteLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    amountTaskCompleteLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    amountTaskCompleteLabel.text = "\(finishedTasks().count)"
  }
  
  private func setupTaskCompleteLabel() {
    containerView.addSubview(taskCompleteLabel)
    taskCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taskCompleteLabel.leadingAnchor.constraint(equalTo: amountTaskCompleteLabel.trailingAnchor, constant: 16),
      taskCompleteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      taskCompleteLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      taskCompleteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
    ])
  }
  
  private func setupChartView() {
    view.addSubview(chartView)
    chartView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      chartView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
      chartView.widthAnchor.constraint(equalTo: chartView.heightAnchor, multiplier: 1)
    ])
    
    let yAxis = chartView.leftAxis
    yAxis.axisMinimum = 0
    yAxis.axisMaximum = 180
    yAxis.labelFont = .systemFont(ofSize: 12, weight: .bold)
    yAxis.setLabelCount(6, force: false)
    yAxis.labelTextColor = .label
    yAxis.axisLineColor = .label
    yAxis.labelPosition = .outsideChart
    
    let xAxis = chartView.xAxis
    xAxis.axisMinimum = 0
    xAxis.axisMaximum = 9
    xAxis.labelPosition = .bottom
    xAxis.labelFont = .systemFont(ofSize: 12, weight: .bold)
    xAxis.setLabelCount(6, force: false)
    xAxis.labelTextColor = .label
    xAxis.axisLineColor = .label
    
    chartView.rightAxis.enabled = false
    chartView.animate(xAxisDuration: 1.5)
    
    setData()
  }
  
  private func setData() {
    let realm = try! Realm()
    let tasks = Array(realm.objects(Task.self))
    
    let tasksMin3 = tasks.filter { task in
      if let date = Date().addDays(-3), let finish = task.finish {
        return finish.isSameday(date)
      }
      return false
    }
    let tasksMin2 = tasks.filter { task in
      if let date = Date().addDays(-2), let finish = task.finish {
        return finish.isSameday(date)
      }
      return false
    }
    let tasksMin1 = tasks.filter { task in
      if let date = Date().addDays(-1), let finish = task.finish {
        return finish.isSameday(date)
      }
      return false
    }
    let tasksToday = tasks.filter { task in
      if let finish = task.finish {
        return finish.isSameday(Date())
      }
      return false
    }
    
    var values: [ChartDataEntry] = []
    let groupedTasks = [tasksMin3, tasksMin2, tasksMin1, tasksToday]
    for i in 0..<groupedTasks.count {
      let tasks = groupedTasks[i]
      let minutes: [Double] = tasks
        .compactMap { task in
          if let finish = task.finish, let start = task.start {
            return finish.timeIntervalSince(start) / 60.0
          }
          return 0.0
        }

      let minute: Double = minutes.reduce(0, +)
      let dataEntry = ChartDataEntry(x: Double(i + 1), y: minute)
      values.append(dataEntry)
    }
    
//    for i in 0..<tasks.count {
//      let task = tasks[i]
//      if let finish = task.finish, let start = task.start {
//        let minute = finish.timeIntervalSince(start) / 60
//        let dataEntry = ChartDataEntry(x: Double(i + 1), y: minute)
//        values.append(dataEntry)
//      }
//    }
    
    let set = LineChartDataSet(entries: values, label: "My Activities")
    set.mode = .cubicBezier
    set.drawCirclesEnabled = false
    set.lineWidth = 10
    set.setColor(UIColor(rgb: 0xA862EF))
    set.drawHorizontalHighlightIndicatorEnabled = false
    set.highlightColor = .systemRed
    
    let data = LineChartData(dataSet: set)
    data.setDrawValues(false)
    chartView.data = data
  }
  
  private func setupColor() {
    let isDark = traitCollection.userInterfaceStyle == .dark
    containerView.backgroundColor = isDark ? UIColor.cellBackgroundDark : UIColor.cellBackgroundLight
  }
}
