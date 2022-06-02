//
//  ViewController.swift
//  Weather
//
//  Created by zdun on 29.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var sityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startLocationManager()
    }

    func startLocationManager() {
    
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()    {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            
        }
    
    }

    func updateView()
    {
        sityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        tempLabel.text = weatherData.main.temp.description
        weatherIcon.image = UIImage(named: weatherData.weather[0].icon)
    }
    
    func upd(latitude: Double, longtitude: Double) {
        let session = URLSession.shared
        let url =  URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=6638ee377d767e135076f83f82e2556a&lon=\(longtitude.description)&lang=ru&units=metric&lat=\(latitude.description)")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }

}



extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            upd(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}
