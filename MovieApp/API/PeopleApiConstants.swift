//
//  PeopleApiConstants.swift
//  MovieApp
//
//  Created by Mac on 30.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

private struct PeopleApiConstants {
    private static let api_Key  =  "?api_key=40674bd02c63d8ba4824b1224fa2fb94"
    static let latest_People_URL = "https://api.themoviedb.org/3/person/latest\(PeopleApiConstants.api_Key)"
    static let popular_People_URL = "https://api.themoviedb.org/3/person/popular\(PeopleApiConstants.api_Key)"
    static func people_Images(peopleId id :String)->String{
        return "https://api.themoviedb.org/3/person/\(id)/images\(PeopleApiConstants.api_Key)"
    }
    static func people_Detail(peopleId id :String)->String{
        return "https://api.themoviedb.org/3/person/\(id)\(PeopleApiConstants.api_Key)"
    }
}
class PeopleApiClass{
    
    func getPeopleData(id:String? = nil , type : PeopleEnum){
        var urlString = ""
        if type == .PeopleDetail{
            guard let id = id else {return}
            urlString = PeopleApiConstants.people_Detail(peopleId: id)
        }
        if type == .LatestPeople{
            urlString = PeopleApiConstants.latest_People_URL
        }
        if type == .PeopleImages{
            guard let id = id else {return}
            urlString = PeopleApiConstants.people_Images(peopleId: id)
        }
        if type == .PopularPeoples{
            urlString = PeopleApiConstants.popular_People_URL
        }
        fetchData(urlString: urlString, type: type)
    }
    private func fetchData(urlString : String , type : PeopleEnum){
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
                if type == .PeopleDetail{self.parsePeopleDetail(data: data)}
                if type == .PopularPeoples{self.parsePeople(data: data)}
                if type == .LatestPeople{self.parsePeopleDetail(data: data)}
                if type == .PeopleImages{self.parsePeopleImages(data:data)}
            }
        }
        task.resume()
    }
    //MARK:-> Parsing
    private func parsePeopleDetail(data:Data){
        let decoder = JSONDecoder()
        do {
            let people = try decoder.decode(People.self, from: data)
            //listen işlemi burada olacak
            print(people.name as Any)
        }catch _ {
               print ("Codable Problem occurred")
        }
    }
    private func parsePeople(data:Data){
        let decoder = JSONDecoder()
        do {
            let people = try decoder.decode(Peoples.self, from: data)
            //listen işlemi burada olacak
            print(people.results?.first?.name as Any)
        }catch _ {
               print ("Codable Problem occurred")
        }
    }
    private func parsePeopleImages(data:Data){
        let decoder = JSONDecoder()
        do {
            let people = try decoder.decode(PeopleImages.self, from: data)
            //listen işlemi burada olacak
            print(people.profiles?.first?.filePath as Any)
        }catch _ {
               print ("Codable Problem occurred")
        }
    }
    
}
