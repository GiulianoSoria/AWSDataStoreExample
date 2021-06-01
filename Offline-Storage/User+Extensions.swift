//
//  User+Extensions.swift
//  Offline-Storage
//
//  Created by Giuliano Soria Pazos on 2021-06-01.
//

import Foundation

extension User: Equatable {
  public static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }
}

extension User: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id + name)
  }
}
