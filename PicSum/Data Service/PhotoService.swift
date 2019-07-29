//
//  File.swift
//  PicSum
//
//  Created by Arjuna on 09/06/19.
//  Copyright © 2019 Arjuna. All rights reserved.
//

import Foundation

struct Photo:Decodable, CustomStringConvertible {
    var description: String {
        return "Author = \(author), width = \(width), height = \(height), download_url = \(downloadUrl)"
    }
    
    let author:String
    let width:Int
    let height:Int
    let downloadUrl:String
    let id:String
    
    enum CodingKeys : String, CodingKey {
        case author
        case width
        case height
        case id
        case downloadUrl = "download_url"
    }
    
}

protocol PhotoServiceProtocol {
    func fetchPhotoList(_ pageNumber:Int, limit:Int, completion: @escaping (_ photos:[Photo]?,_ hasMorePhotos:Bool?, _ error:Error?)->(Void))
}

class PhotoServiceProvider:PhotoServiceProtocol {

    
    static let baseURL = "https://picsum.photos"
    
    func fetchPhotoList(_ pageNumber: Int, limit: Int, completion: @escaping ([Photo]?, Bool?, Error?) -> (Void)) {
        let urlString = "\(type(of: self).baseURL)/v2/list?page=\(pageNumber)&limit=\(limit)"
        let url = URL(string: urlString)!
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var photos:[Photo]?
            var hasMorePhotos:Bool?
            
            if let data = data {
                let decoder = JSONDecoder()
                if let _photos = try? decoder.decode([Photo].self, from: data) {
                    let pageLink = (response as! HTTPURLResponse).allHeaderFields["Link"] as? String
                    hasMorePhotos  = pageLink?.contains("rel=\"next\"")
                    photos = _photos
                }
            }
            completion(photos,hasMorePhotos,error)
        }.resume()
    }
}
