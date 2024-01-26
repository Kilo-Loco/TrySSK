//
//  JobListing.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import Foundation

public struct JobListing: Embeddable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let location: String
    
    public var embeddingText: String { title }
    
    public var metadata: [String: String] {
        ["description": description, "location": location]
    }
}

extension JobListing: CSVDecodable {
    public init?(dict: [String: String]) {
        guard
            let id = dict["job_id"],
            let title = dict["title"],
            let description = dict["description"],
            let location = dict["location"]
        else { return nil }
        self.id = id
        self.title = title
        self.description = description
        self.location = location
    }
}

public final class JobListingCache {
    public var cache: [String: JobListing] = [:]
    
    public func cache(_ jobs: [JobListing]) {
        for job in jobs {
            cache[job.id] = job
        }
    }
    
    public func getCachedJobs() -> [JobListing] {
        Array(cache.values)
    }
}
