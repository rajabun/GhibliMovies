//
//  ApiViewModel.swift
//  GhibliMovies
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import Foundation

class ApiViewModel {
    let request = APIRequest()
    var listOfMovies = [MoviesDetail]()
    var listOfYear = [String]()
    var selectedYear: String = ""
    var filteredMovies = [MoviesDetail]()
    
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
}
