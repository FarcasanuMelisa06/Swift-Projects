//
//  DogAPI.swift
//  StartDogAPI
//
//  Created by Melisa Farcasanu on 09.08.2022.
//

import Foundation
import UIKit

class DogAPI {
   
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageforBreed (String)
        //1.
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        //proprietate compusa
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
               return "https://dog.ceo/api/breeds/image/random"
            case .randomImageforBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
                //1.
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    
    //2. creați o metodă cu un handler de completare în dogAPI care solicită lista de rase
    class func requestBreedsList(completionHandler: @escaping ([String], Error?)-> Void) {
        let task = URLSession.shared.dataTask(with: Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            //3. faceți o cerere către punctul final „listAllBreeds” și analizați JSON.
let decoder = JSONDecoder()
            let breedsResponse = try!  decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
    }
    //@escaping este folosit pentru ca completionHandler e apelat abia dupa ce functia s-a executat
    //pasii 1, 2
    //am creat metoda, am adaugat parametrii
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void ){
     
      let randomImageEndpoint =
        DogAPI.Endpoint.randomImageforBreed(breed).url
     
      let task = URLSession.shared.dataTask(with: randomImageEndpoint) { data, response, error in

          guard let data = data else {
              //pasul 4 - apleam completionHandler pentru succes sau fail
              completionHandler(nil, error)
              return
          }
         
         
          let decoder = JSONDecoder()
        
          let imageData = try! decoder.decode(DogImage.self, from: data)
          print(imageData)
          //pasul 4
          completionHandler(imageData, nil)

}
      task.resume()
  }
    //folosim tip optional pentru ca știm că dacă obținem date de imagine, atunci nu a apărut o eroare
    class func requestImageFile(url: URL,  completionHandler: @escaping (UIImage?, Error?) -> Void ){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            //4.am încărcat imaginea în vizualizarea noastră de imagine
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
    }
        task.resume()
}
    
   
}

