//
//  BatchSaveOperation.swift
//  Offline-Storage
//
//  Created by Giuliano Soria Pazos on 2021-06-01.
//

import Amplify
import Foundation

class AsyncOperation: Operation {
  override var isAsynchronous: Bool { true }
  
  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.rawValue)
      willChangeValue(forKey: state.rawValue)
    }
    
    didSet {
      didChangeValue(forKey: oldValue.rawValue)
      didChangeValue(forKey: state.rawValue)
    }
  }
  
  override var isExecuting: Bool {
    state == .executing
  }
  
  override var isFinished: Bool {
    state == .finished
  }
  
  override var isReady: Bool {
    super.isReady && state == .ready
  }
  
  override func start() {
    guard !isCancelled else {
      state = .finished
      return
    }
    
    main()
    state = .executing
  }
}

extension AsyncOperation {
  enum State: String {
    case executing = "isExecuting"
    case finished = "isFinished"
    case ready = "isReady"
  }
}

class BatchSaveOperation<M: Model>: AsyncOperation {
  private let models: [M]
  
  var savedModels: [M] = []
  
  init(models: [M]) {
    self.models = models
    super.init()
  }
  
  override func main() {
    guard !isCancelled else {
      state = .finished
      return
    }
    
//    var counter = 0
    let group = DispatchGroup()
    models.forEach { [weak self] model in
      group.enter()
      Amplify.DataStore.save(model) { result in
        guard let self = self else { return }
//        counter += 1
        
        switch result {
        case .failure(let error):
          print(error)
          group.leave()
        case .success(let savedModel):
          self.savedModels.append(savedModel)
          group.leave()
        }
        
//        if counter == self.models.count {
//          self.state = .finished
//        }
      }
    }
    
    group.notify(queue: .main) {
      self.state = .finished
      print("Finished saving the models!")
    }
  }
}
