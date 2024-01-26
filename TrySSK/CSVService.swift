//
//  CSVService.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import Foundation
import SwiftCSV

public final class CSVService {
    private var rows: [Named.Row] = []
    
    public func loadCSV(named csvFileName: String) throws {
        guard let filePath = Bundle.main.path(forResource: csvFileName, ofType: "csv") else {
            throw CSVError.invalidFilePath
        }
        guard let csvFile = try? CSV<Named>(url: URL(fileURLWithPath: filePath)) else {
            throw CSVError.invalidCSVFile
        }
        self.rows = csvFile.rows
    }
    
    public func getItems<I: CSVDecodable>(at index: Int = 0, pageCount: Int = 250) -> [I] {
        guard !rows.isEmpty else { return [] }
        
        if rows.count > pageCount {
            let lowerLimit = index * pageCount
            
            let upperLimit = lowerLimit + pageCount - 1
            let trueUpperLimit: Int
            
            if rows.count > upperLimit  {
                trueUpperLimit = upperLimit
            } else {
                trueUpperLimit = rows.count - 1
            }
            
            var paginatedItems: [I] = []
            
            for row in rows[lowerLimit...trueUpperLimit] {
                guard let item = I(dict: row) else { continue }
                paginatedItems.append(item)
            }
            
            return paginatedItems
        } else {
            return rows.compactMap(I.init(dict:))
        }
    }
}

public extension CSVService {
    enum CSVError: Error {
        case invalidFilePath
        case invalidCSVFile
    }
}
