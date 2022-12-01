

import UIKit

enum KittenImageLocation: String {
    case http = "http://www.kittenswhiskers.com/wp-content/uploads/sites/23/2014/02/Kitten-playing-with-yarn.jpg"
    case https = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Kitten_in_Rizal_Park%2C_Manila.jpg/460px-Kitten_in_Rizal_Park%2C_Manila.jpg"
    case error = "not a url"
}
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //pentru primirea cereri se fac doi pasi
    //1. crearea si trimiterea cererii http
    //2. primire si gestionarea raspunsului http
    let imageLocation = KittenImageLocation.http.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func handleLoadImageButton(_ sender: Any) {
        guard let imageUrl = URL(string: imageLocation) else {
            print("Cannot create URL")
            return
        }
        //data task
//        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error ) in
//
//            guard let data = data else {
//                print("No data, or there was an error ")
//                return
//            }
//let downloadedImage = UIImage(data: data)
//            DispatchQueue.main.async {
//                self.imageView.image = downloadedImage
//            }
//
//        }
//        task.resume()
        
        //download task - datele returnate de server sunt stocate pe dispozitiv și locația acestuia este adresa URL a acestui fișier
        let task = URLSession.shared.downloadTask(with: imageUrl) { (location, response, error ) in
            
            guard let location = location else {
                print("location is nil ")
                return
            }
            print(location)

            //1. trebuie să încărcăm datele din fișier
            let imageData = try! Data(contentsOf: location)
        
            //2. trebuie să o transformăm într-o imagine
            
           let image = UIImage(data: imageData)
            
            //3. setam  imaginea în vizualizarea noastră de imagine
            DispatchQueue.main.async {
                          self.imageView.image = image
                      }
    }
        task.resume()
}

}
