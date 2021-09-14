//
//  WeatherModel.swift
//  Clima
//
//  Created by Tushar Vijayvargiya on 29/06/21.
//

import Foundation
struct WeatherModel {
    let conditionId:Int
    let cityName:String
    let description:String
    let temperature:Double
    var humidity: Int
    var pressure: Int
    var speed: Double
    var tempMax: Double
    var tempMin: Double
    var time: Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}


struct DailyWeather {
    var dailyIcon: Int
    var dailyWeekday: String
    var dailyHigh: Int
    var dailyLow: Int
    
    var conditionIcon: String{
        switch dailyIcon {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct HourlyWeather: Codable {
    var hour: String
    var hourlyIcon: Int
    var hourlyTemperature: Int
    
    var conditionIcon: String{
        switch hourlyIcon {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
