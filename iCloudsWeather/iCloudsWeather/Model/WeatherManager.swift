import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

let hourlyFormatter: DateFormatter = {
    let hourlyFormatter = DateFormatter()
    hourlyFormatter.dateFormat = "ha"
    return hourlyFormatter
}()

var dailyWeatherData: [DailyWeather] = []
var hourlyWeatherData: [HourlyWeather] = []

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=4b863902d71bda0b191ec9e4bcbfb628&units=metric&lang=en"
    
    var delegate: WeatherManagerDelegate?
    
//    func fetchWeather() {
//        let urlString = "\(weatherURL)"
//        performRequest(with: urlString)
//    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.current.weather[0].id
            let description = decodedData.current.weather[0].description
            let name = decodedData.timezone
            let humidity = decodedData.current.humidity
            let pressure = decodedData.current.pressure
            let speed = decodedData.current.wind_speed
            let temp = decodedData.current.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, description: description, temperature: temp, humidity: humidity, pressure: pressure, speed: speed, tempMax: 0, tempMin: 0, time: 0)
            
            //Mark: - DailyWeatherDataManager
            
            for index in 0..<decodedData.daily.count {
                let weekdayDate = Date(timeIntervalSince1970: TimeInterval(decodedData.daily[index].dt))
                dateFormatter.timeZone = TimeZone(identifier: decodedData.timezone)
                let dailyWeekday = dateFormatter.string(from: weekdayDate)
                let dailyIcon = decodedData.daily[index].weather[0].id
                let dailyHigh = decodedData.daily[index].temp.max.rounded()
                let dailyLow = decodedData.daily[index].temp.min.rounded()
                let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailyHigh: Int(dailyHigh), dailyLow: Int(dailyLow))
                dailyWeatherData.append(dailyWeather)
            }
            
            //Mark: - HourlyWeatherDataManager
            
            let lastHour = min(24, decodedData.hourly.count)
            for index in 0..<lastHour {
                let hourlyDate = Date(timeIntervalSince1970: decodedData.hourly[index].dt)
                hourlyFormatter.timeZone = TimeZone(identifier: decodedData.timezone)
                let hour = hourlyFormatter.string(from: hourlyDate)
                let hourlyIcon = decodedData.hourly[index].weather[0].id
                let temperature = decodedData.hourly[index].temp
                let hourlyWeather = HourlyWeather(hour: hour, hourlyIcon: hourlyIcon, hourlyTemperature: Int(temperature))
                hourlyWeatherData.append(hourlyWeather)
            }
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
