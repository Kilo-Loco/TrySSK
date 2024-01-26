//
//  ContentView.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List(vm.animesToDisplay) { anime in
                NavigationLink {
                    VStack(alignment: .leading) {
                        Text(anime.name)
                            .font(.largeTitle)
                        Text(anime.genres)
                            .font(.caption)
                        ScrollView {
                            Text(anime.synopsis)
                        }
                    }
                    .padding(.horizontal)
                } label: {
                    VStack(alignment: .leading) {
                        Text(anime.name)
                        Text(anime.genres)
                            .font(.caption)
                    }
                }
            }
        }
        .searchable(text: $vm.searchText)
        .onSubmit(of: .search) {
            vm.getResults()
        }
        .onAppear(perform: vm.loadData)
    }
}

extension ContentView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private var matchingAnimes: [AnimeListing] = []
        
        var animesToDisplay: [AnimeListing] {
            if matchingAnimes.isEmpty {
                return animeListings
            } else {
                return matchingAnimes
            }
        }
        
        @Published var animeListings: [AnimeListing] = []
        @Published var searchText: String = ""
        
        private let csvService: CSVService = .init()
        private let searchService: SearchService = .init()
        private let animeCache: AnimeListingCache = .init()
        
        func loadData() {
            Task {
                do {
                    try csvService.loadCSV(named: "anime-dataset-2023")
                    let animes: [AnimeListing] = csvService.getItems(pageCount: 55_000)
                    self.animeListings = animes
                    self.animeCache.cache(animes)
                    self.embedListings()
                } catch {
                    print(error)
                }
            }
        }
        
        func embedListings() {
            Task {
                await searchService.embed(items: animeListings)
            }
        }
        
        func getResults() {
            Task {
                let matchingAnimes = await searchService.search(searchText, against: animeCache.cache)
                
                self.matchingAnimes = matchingAnimes
            }
        }
    }
}

#Preview {
    ContentView()
}
