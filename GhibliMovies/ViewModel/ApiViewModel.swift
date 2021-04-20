//
//  ApiViewModel.swift
//  GhibliMovies
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import Foundation
import Combine

class ApiViewModel: ObservableObject {
    let request = APIRequest()
    var listOfMovies = [MoviesDetail]()
    
    @Published var listOfYear = [String]()
    @Published var selectedYear: String = ""
    @Published var filteredMovies = [MoviesDetail]()
    
    private var movieSubscriber: AnyCancellable?
    
    func getData (completion: @escaping(Result<[MoviesDetail], APIError>) -> Void)
    {
        let dataTask = URLSession.shared.dataTask(with: request.resourceURL)
        {data,_,_ in
            guard let jsonData = data
            else
            {
                completion(.failure(.noDataAvailable))
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let topListsResponse = try decoder.decode([MoviesDetail].self, from: jsonData)
                DispatchQueue.main.async
                {
                    let topListsDetails = topListsResponse
                    
                    if self.listOfYear.isEmpty == true {
                        self.selectedYear = "All"
                        for year in topListsDetails {
                            self.listOfYear.append(year.release_date)
                        }
                        
                        let filteredListOfYear = Set(self.listOfYear).sorted()
                        self.listOfYear = filteredListOfYear
                        self.listOfYear.insert("All", at: 0)
                    }
                    
                    self.filteredMovies.removeAll()
                    for year in topListsDetails {
                        if self.selectedYear == year.release_date {
                            self.filteredMovies.append(year)
                        } else if self.selectedYear == "All" {
                            self.filteredMovies = topListsDetails
                        }
                    }
                    
                    completion(.success(topListsDetails))
                    print("completion berhasil")
                }
                
            }
            catch
            {
                completion(.failure(.canNotProcessData))
                print(error)
            }
        }
        dataTask.resume()
       print("getdata berhasil")
    }
    
    func getDataCombine() {
        self.movieSubscriber = URLSession.shared.dataTaskPublisher(for: request.resourceURL)
        .map { $0.data }
        .decode(type: [MoviesDetail].self, decoder: JSONDecoder())
        .replaceError(with: [])
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure( _):
                    fatalError(APIError.canNotProcessData.localizedDescription)
                }
            }, receiveValue: { posts in
                print(posts.count)
                if self.listOfYear.isEmpty == true {
                    self.selectedYear = "All"
                    for year in posts {
                        self.listOfYear.append(year.release_date)
                    }

                    let filteredListOfYear = Set(self.listOfYear).sorted()
                    self.listOfYear = filteredListOfYear
                    self.listOfYear.insert("All", at: 0)
                }

                self.filteredMovies.removeAll()
                for year in posts {
                    if self.selectedYear == year.release_date {
                        self.filteredMovies.append(year)
                    } else if self.selectedYear == "All" {
                        self.filteredMovies = posts
                    }
                }
            })
        self.movieSubscriber?.cancel()
    }
}
