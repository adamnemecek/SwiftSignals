//
//  Scheduler.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/5/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

struct Task {
    var timestamp = 0
    typealias Function = (Void) -> Void
    var taskToBeDone: Function = {_ in return}
    
    func perform() {
        taskToBeDone()
    }
}

class Scheduler {
    
    var time = 0
    var tasks = [Task]()
    
    func addTask(t: Task) {
        for index in 0..<tasks.count {
            if t.timestamp > tasks[index].timestamp && t.timestamp < tasks[index + 1].timestamp {
                tasks.insert(t, atIndex: index)
            }
        }
    }
    
    func update(timestamp: Int) {
        
        time = timestamp
        
        for task in tasks {
            if task.timestamp <= timestamp {
                task.perform()
            }
        }
    }
}