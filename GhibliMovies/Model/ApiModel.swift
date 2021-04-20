//
//  ApiModel.swift
//  GhibliMovies
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import Foundation

struct MoviesDetail: Decodable {
    let title: String
    let description: String
    let release_date: String
    let director: String
}
