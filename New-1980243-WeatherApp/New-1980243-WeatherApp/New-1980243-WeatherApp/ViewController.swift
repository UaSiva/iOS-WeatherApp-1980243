//
//  ViewController.swift
//  New-1980243-WeatherApp
//
//  Created by SIVA SUBRAMANIAN PARI ARIVAZHAGAN on 5/28/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var weatherText: UILabel!
    
    @IBOutlet weak var placeText: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    
    let apikey="4360704a909b235cbd2a1172701a8c6d"
    var latitudeVar = 112.344533
    var longitudeVar = 104.33322
    let locMan = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locMan.requestWhenInUseAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            locMan.delegate = self
            locMan.desiredAccuracy = kCLLocationAccuracyBest
            locMan.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        latitudeVar = loc.coordinate.latitude
        longitudeVar = loc.coordinate.longitude
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitudeVar)&lon=\(longitudeVar)&appid=\(apikey)&units=metric"

        getData(from: url)

        }
    
    func getData(from url: String){
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                
                print("Something Went Wrong")
                return
                
            }
            
            var result: Response?
            do{
                result = try JSONDecoder().decode(Response.self, from: data )
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
                
            }
            
            guard let json = result else{
                return
            }
            
            
            DispatchQueue.main.async{
                
                self.weatherText.text = "\(Int(round(json.main.temp)))"+"°C"
                print("Hello1")
                self.placeText.text = "\(json.name)"
                print("Hello2")
                self.minTemp.text = "Min : "+"\(Int(round(json.main.temp_min)))"+"°C"
                print("Hello3")
                self.maxTemp.text = "Min : "+"\(Int(round(json.main.temp_max)))"+"°C"
                print("Hello4")
                self.humidity.text = "Hum : "+"\(json.main.humidity)"+"%"
            }

        }).resume()
    }
    
}

struct Response: Codable {
    let main: MyResult
    let name: String
}

struct MyResult: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}


