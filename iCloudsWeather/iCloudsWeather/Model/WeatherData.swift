//
//  WeatherData.swift
//  Clima
//
//  Created by Tushar Vijayvargiya on 29/06/21.
//

import Foundation

struct WeatherData: Codable {
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let dt: TimeInterval
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let visibility: Double
    let wind_speed: Double
    let weather: [Weather]
    
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}

struct Hourly: Codable {
    
    let dt: TimeInterval
    let temp: Double
    let humidity: Int
    let weather: [Weather]
    
}

struct Daily: Codable {
    
    let dt: Int
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    
}

struct Temp: Codable {
    let min: Double
    let max: Double
}
