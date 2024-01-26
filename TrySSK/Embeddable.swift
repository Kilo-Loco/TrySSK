//
//  Embeddable.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import Foundation

public protocol Embeddable {
    var id: String { get }
    var embeddingText: String { get }
    var metadata: [String: String] { get }
}
