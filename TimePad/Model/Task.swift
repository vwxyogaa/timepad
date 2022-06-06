//
//  Task.swift
//  TimePad
//
//  Created by yxgg on 29/05/22.
//

import Foundation
import RealmSwift

class Task: Object {
  @Persisted var title: String = ""
  @Persisted var category: String = ""
  @Persisted var tag: String = ""
  @Persisted var start: Date?
  @Persisted var finish: Date?
}

extension Task {
  var categoryType: Category? {
    return Category.allCases.first { $0.name == category }
  }
  
  var tagType: Tag? {
    return Tag.allCases.first { $0.name == tag }
  }
}
