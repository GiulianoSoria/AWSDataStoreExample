//
//  ViewController.swift
//  Offline-Storage
//
//  Created by Kyle Lee on 6/30/20.
//

import UIKit

class ViewController: UIViewController {
  
  let mainView = MainView()
  var dataSource: UICollectionViewDiffableDataSource<Section, User>?
  
  let manager = DataManager()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    getUsers()
  }
  
  func setupCollectionView() {
    let registration = UICollectionView.CellRegistration<UICollectionViewListCell, User> { cell, indexPath, user in
      
      var content = cell.defaultContentConfiguration()
      content.text = user.name
       
      cell.contentConfiguration = content
    }
    
    dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: mainView.collectionView) { collectionView, indexPath, user in
      
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: user)
    }
  }
  
  func getUsers() {
    manager.getUsers { [weak self] users in
      guard let self = self else { return }
      self.populate(with: users)
    }
  }
  
  func populate(with users: [User]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
    snapshot.appendSections([.main])
    snapshot.appendItems(users)
    dataSource?.apply(snapshot)
  }
}

extension ViewController {
  enum Section {
    case main
  }
}

