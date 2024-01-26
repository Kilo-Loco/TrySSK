//
//  CSVDecodable.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import Foundation

public protocol CSVDecodable {
    init?(dict: [String: String])
}
