//
//  ApiRequest.swift
//  GhibliMovies
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import Foundation

enum APIError:Error
{
    case noDataAvailable
    case canNotProcessData
}

class APIRequest
{
    var resourceURL: URL
    let getMovies = "https://ghibliapi.herokuapp.com/films"
    
    init()
    {
        guard let resourceURL = URL(string: getMovies)
        else
        {
            fatalError()
        }
        self.resourceURL = resourceURL
        print("init berhasil")
    }
}
