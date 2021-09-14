//
//  HourlyCollectionViewCell.swift
//  iCloudsWeather
//
//  Created by Tushar Vijayvargiya on 31/08/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hourlyTemperature: UILabel!
    
    var hourlyWeather: HourlyWeather! {
        didSet {
            hourLabel.text = hourlyWeather.hour
            iconImageView.image = UIImage(systemName: hourlyWeather.conditionIcon)
            hourlyTemperature.text = "\(hourlyWeather.hourlyTemperature)°"
        }
    }
}
