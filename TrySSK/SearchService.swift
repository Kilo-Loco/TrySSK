//
//  SearchService.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import CoreML
import Foundation
import SimilaritySearchKit

public final class SearchService {
    
    private var similarityIndex: SimilarityIndex!
    
    public init() {
        Task {
            self.similarityIndex = await SimilarityIndex(
                model: NativeEmbeddings(),
                metric: EuclideanDistance()
            )
        }
    }
    
    public func embed<E: Embeddable>(items: [E]) async {
        let ids = items.map(\.id)
        let texts = items.map(\.embeddingText)
        let metadata = items.map(\.metadata)
        var finished = 0.0
        let total = Double(items.count)
        await similarityIndex.addItems(ids: ids, texts: texts, metadata: metadata) { str in
            finished = finished + 1
            print("Progress:", finished/total)
        }
    }
    
    public func search(_ query: String) async -> [SearchResult] {
        await similarityIndex.search(query, top: 10, metric: EuclideanDistance())
    }
}

extension SearchService {
    public func search<E: Embeddable>(_ query: String, against cache: [String: E]) async -> [E] {
        let results = await self.search(query)
        let scores = results.map { ($0.text, $0.score) }
        print(scores)
        var matchedEmbeddings: [E] = []
        
        for result in results {
            if let embed = cache[result.id] {
                matchedEmbeddings.append(embed)
            }
        }
        
        return matchedEmbeddings
    }
}
