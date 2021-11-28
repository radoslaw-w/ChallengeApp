//
//  CellData.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 28/11/2021.
//

import Foundation

struct CellData: Codable, Hashable {
    let identifier = UUID()
    public let url: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
    
    static func == (lhs: CellData, rhs: CellData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
