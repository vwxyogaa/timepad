//
//  TimeIntervalExtension.swift
//  TimePad
//
//  Created by yxgg on 30/05/22.
//

import Foundation

extension TimeInterval {
  var durationString: String {
    let timeInterval = Int(self)
    
    let seconds = timeInterval % 60
    let minutes = (timeInterval / 60) % 60
    let hours = (timeInterval / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
  }
  
  var simpleDurationString: String {
    let timeInterval = Int(self)
    
    let seconds = timeInterval % 60
    let minutes = (timeInterval / 60) % 60
    
    return String(format: "%0.2d:%0.2d", minutes, seconds)
  }
}
