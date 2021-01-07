//
//  main.swift
//  SOLID
//
//  Created by Mario Rotz on 05.01.21.
//

import Foundation

print("Von welcher Stadt soll das Wetter angezeigt werden?")
let input = readLine()
if let name = input {
    WeatherAPI().fetchData(city: name,result: {
        data in
        if let w = WeatherJSONDecoder().jsonToWeather(data: data, for: name)
        {
            print("Das Wetter in \(w.city) : \(w.weather). Die Temperatur beträgt \(w.temperature) Kelvin")
        }
    })
}
let name2 = readLine()

