//
//  ViewController.swift
//  StartDogAPI
//
//  Created by Melisa Farcasanu on 09.08.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogAPI.requestBreedsList(completionHandler: handleBreedsResponse(breeds:error:))
    }
    
    
        // Do any additional setup after loading the view.
//        //1. am preluat cu ajutorul URL-ului o imagine random
//        let randomImageEndpoint = DogAPI.Endpoint.randomImageFromAllDogsCollection.url
//        //2. am preluat raspunsul json care contine adresa url a imaginii
//        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { data, response, error in
//
//            guard let data = data else {
//                return
//            }
////           print(data)
////
////            do {
////                //convertirea datelor json intr-un dictionar
////                //care ne permite sa luam valori individuale
////                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
////                let url = json["message"] as! String
////                print(url)
////            } catch {
////                print(error)            }
//            //3. am utilizat json decode
//            //instantiate our DogImage struct from the JSON data
//            let decoder = JSONDecoder()
//            //creem o insta a structurii DogImage
//            //self -> ne referim la definitia structurii DogImage
//            let imageData = try! decoder.decode(DogImage.self, from: data)
//            print(imageData)
            //prin 2 pasi am creat un decoder si
            //l-am decodat intr-un tip anume
            
            //Direnta intre JSON decoder si JSON serialization
            //este că codul de rețea nu trebuie să extragă fiecare proprietate din json
        //pasul 5 - actualizare viewController
//        DogAPI.requestRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
    
    
    func handleBreedsResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?){
        guard let imageURL = URL(string: imageData?.message ?? "") else{
        return
        }
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
          
        }


    func handleImageFileResponse(image: UIImage?, error: Error?){
        //o sincronizare pentru a se asigura că au loc actualizări pe firul principal
        DispatchQueue.main.async {
            //daca a aparut o eroare, inseamna ca aceasta imagine ar  trebui sa fie nil
            self.imageView.image = image
        }
    }
}


//functiile si inchiderile sunt una

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents (in pickerView: UIPickerView) -> Int {
        //returnam 1 pentru ca utilizatorul alege doar o singura rasa
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //numele rasei care va fi selectata de utilizator
        //avem un număr întreg pentru rândul în care va fi afișată rasa
        //vom returna valoarea din matricea rase folosind rândul ca index
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //se apeleaza cand picker view stops spinning si rasa a fost selectata
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
}

