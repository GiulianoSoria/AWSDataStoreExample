//
//  WireUser.swift
//  Offline-Storage
//
//  Created by Kyle Lee on 6/30/20.
//

import Foundation

struct WireUser: Decodable {
    let id: Int
    let name: String
}

extension WireUser: Hashable {}
