//
//  DataManager.swift
//  Offline-Storage
//
//  Created by Giuliano Soria Pazos on 2021-06-01.
//

import Amplify
import Foundation

class DataManager {
  
  func getUsers(completion: @escaping ([User]) -> Void) {
    // Return persisted users
    Amplify.DataStore.query(User.self) { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let persistedUsers):
        completion(persistedUsers)
      }
    }
    
    // Make networking request
    NetworkingService.requestUsers { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let wireUsers):
      // Persist the users
        self.save(wireUsers) { savedUsers in
          // Return the users
          DispatchQueue.main.async {
            completion(savedUsers)
          }
        }

      case .failure(let error):
        print(error)
      }
    }
  }
  
  func save(_ wireUsers: [WireUser], completion: @escaping ([User]) -> Void) {
    // Convert wireUsers to users
    let users = wireUsers.map { User(id: String($0.id), name: $0.name) }
    
    // Batch save users
    let batchSaveOp = BatchSaveOperation(models: users)
    batchSaveOp.completionBlock = { [unowned batchSaveOp] in
      
      // Return users
      let savedUsers = batchSaveOp.savedModels
      completion(savedUsers)
    }
    
    let queue = OperationQueue()
    queue.addOperations([batchSaveOp], waitUntilFinished: true)
    
  }
}
