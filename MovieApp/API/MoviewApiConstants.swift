//
//  ApiConstants.swift
//  MovieApp
//
//  Created by Mac on 28.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import RxSwift
private struct MovieApiConstant {
    private static let api_Key  =  "?api_key="
    //MARK: MOVIE Constants
    // TOP Rated Movies
    static let Top_Rated_MovieURL = "https://api.themoviedb.org/3/movie/top_rated\(MovieApiConstant.api_Key)&language=en-US"
    static let discover_Movies = "https://api.themoviedb.org/3/discover/movie\(MovieApiConstant.api_Key)&sort_by=popularity.desc"
    // Popular Movies
    static let Popular_MoviesURL = "https://api.themoviedb.org/3/movie/popular\(MovieApiConstant.api_Key)&language=en-US"
    // UPComing URL
    static let Upcoming_MoviesURL = "https://api.themoviedb.org/3/movie/upcoming\(MovieApiConstant.api_Key)&language=en-US"
    // Get Latest
    static let Latest_MovieURL = "https://api.themoviedb.org/3/movie/latest\(MovieApiConstant.api_Key)"
    // Get Similar Movies
    static func getSimilarMoviesURL(movieId id :String)->String{
        return "https://api.themoviedb.org/3/movie/\(id)/similar\(MovieApiConstant.api_Key)"
    }
    // Get Movie Images
    static func getMovieImages(moviewId id : String) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)/images\(MovieApiConstant.api_Key)"
    }
    // Get Movie Detail
    static func getMovieDetail(moviewId id :String) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)\(MovieApiConstant.api_Key)"
    }
    static func search(name:String , year : Int? = nil)->String{
        let urlString = "https://api.themoviedb.org/3/search/movie\(MovieApiConstant.api_Key)&query=\(name)"
        if let year = year{
            return urlString + "&year=\(year)"
        }
        return urlString
    }
}
class MovieApiClass {
    // MARK: Movie Detail
    var movieDetailObject = PublishSubject<MovieDetail>()
    var moviesObject = PublishSubject<Movies>()
    func getMovieData(id:String? = nil , type:MovieEnum , pageNumber : Int? = nil){
        var urlString = ""
        if type == .MovieDetail{
            guard let id = id else {return}
            urlString = MovieApiConstant.getMovieDetail(moviewId: id)
        }
        if type == .MovieGetLatest{
            urlString = MovieApiConstant.Latest_MovieURL
        }
        if type == .MovieImages{
            guard let id = id else {return}
            urlString = MovieApiConstant.getMovieImages(moviewId: id)
        }
        if type == .PopularMovies{
            guard let number = pageNumber else {return}
            urlString = MovieApiConstant.Popular_MoviesURL + "&page=\(number)"
        }
        if type == .SimilarMovies{
            guard let id = id else {return}
            urlString = MovieApiConstant.getSimilarMoviesURL(movieId: id)
        }
        if type == .TopRatedMovies{
            guard let number = pageNumber else {return}
            urlString = MovieApiConstant.Top_Rated_MovieURL + "&page=\(number)"
        }
        if type == .UpComingMovies {
            guard let number = pageNumber else{return}
            urlString = MovieApiConstant.Upcoming_MoviesURL + "&page=\(number)"
        }
        if type == .DiscoverMovies {
            guard let number = pageNumber else {return}
            urlString = MovieApiConstant.discover_Movies + "&page=\(number)"
        }
        fetchData(urlString: urlString,type:type)
    }
    private func fetchData(urlString : String , type:MovieEnum){
        guard let dataURL = URL(string: urlString) else {return}
        var request = URLRequest(url: dataURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("URL Response : \(httpResponse.statusCode)")
            }
            if let error =  err {
                print("Error has been occured : \(error.localizedDescription)")
            }
            if let data = data {
                if type == .MovieDetail{self.parseMovieDetail(data: data)}
                if type == .PopularMovies{self.parseMovies(data: data)}
                if type == .TopRatedMovies{self.parseMovies(data: data)}
                if type == .UpComingMovies{self.parseMovies(data: data)}
                if type == .MovieGetLatest{self.parseMovieDetail(data: data)}
                if type == .SimilarMovies {self.parseMovies(data: data)}
                if type == .MovieImages{self.parseMovieImages(data: data)}
                if type == .DiscoverMovies{self.parseMovies(data: data)}
                if type == .SearchMovie{self.parseMovies(data: data)}
            }
        }
        task.resume()
    }
    
    //SEARCH MOVIE
    func searchMoview(name:String , year:Int? = nil){
        let urlString = MovieApiConstant.search(name: name, year: year)
        self.fetchData(urlString: urlString, type: .SearchMovie)
    }
    
    //MARK: Parsing
    private func parseMovieDetail(data:Data){
        let decoder = JSONDecoder()
        do {
            let movie = try decoder.decode(MovieDetail.self, from: data)
            self.movieDetailObject.onNext(movie)
        }catch _ {
                print ("Codable Problem occurred")
        }
    }
    private func parseMovies(data:Data){
        let decoder = JSONDecoder()
               do {
                   let movie = try decoder.decode(Movies.self, from: data)
                self.moviesObject.onNext(movie)
               }catch _ {
                       print ("Codable Problem occurred")
                }
    }
    private func parseMovieImages(data : Data){
        let decoder = JSONDecoder()
        do {
            let images = try decoder.decode(MovieImages.self, from: data)
            print(images.posters?.count as Any)
        }catch _ {
               print ("Codable Problem occurred")
        }
    }
    
}




