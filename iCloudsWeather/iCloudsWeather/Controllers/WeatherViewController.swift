//
//  ViewController.swift
//  iCloudsWeather
//
//  Created by Tushar Vijayvargiya on 17/08/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var hourlyColllectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var perfectName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.layer.backgroundColor = UIColor.systemGray3.cgColor
        descriptionLabel.layer.cornerRadius = 5
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.5
        cityLabel.numberOfLines = 0
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        hourlyColllectionView.dataSource = self
        hourlyColllectionView.delegate = self

    }
}

//Mark: -WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate
{
    
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.humidityLabel.text = "\(String(weather.humidity))%"
            self.pressureLabel.text = "\(String(weather.pressure))mBar"
            self.windSpeedLabel.text = "\(String(weather.speed))m/s"
            self.cityLabel.text = self.perfectName
            self.descriptionLabel.text = weather.description.capitalized
            self.dailyTableView.reloadData()
            self.hourlyColllectionView.reloadData()
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//Mark: -CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
                locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemark, error in
                var locationName = ""
                if placemark != nil {
                    let placemark = placemark?.last
                    locationName = placemark?.name ?? "Parts Unknown"
                } else {
                    print("Error is = \(error?.localizedDescription)")
                    locationName = "Could not find location"
                }
                print("locationName = \(locationName)")
                self.perfectName = locationName
                self.weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
            print("current location is = \(lat), \(lon)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//Mark: - DailyTableViewManager

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dailyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyTableViewCell
        cell.dailyWeather = dailyWeatherData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//Mark: - HourlyCollectionViewManager

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = hourlyColllectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
        hourlyCell.hourlyWeather = hourlyWeatherData[indexPath.row]
        return hourlyCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.hourlyColllectionView.frame.height / 6*5, height: 120)
    }
}


