//
//  API.swift
//  SOLID
//
//  Created by Mario Rotz on 05.01.21.
//

import Foundation

struct WeatherDataJson : Decodable {
    let main : Main
    let weather : [Weather]
}
 
struct Weather : Decodable {
    let main : String
    let description : String
}

struct Main : Decodable {
    let temp : Double
}

class WeatherData {
    var weather : String = ""
    var city : String = ""
    var temperature : Double = 0.0
    init(weather:String,city:String,temperature:Double) {
        self.weather=weather
        self.city=city
        self.temperature=temperature
    }
}


class WeatherJSONDecoder {
    func jsonToWeather(data:Data,for city:String) -> WeatherData? {
        do {
            let jsonDecoder = JSONDecoder()
            let weather = try jsonDecoder.decode(WeatherDataJson.self, from: data)
            return WeatherData(weather: weather.weather[0].description, city: city, temperature: weather.main.temp)
        } catch let jsonError as NSError {
            print("JSON decode failed: \(jsonError.localizedDescription)")
        }
        return nil
    }
}

class WeatherAPI {
    let apiKey = "2be3a6a7d79242453460bc8c7117e615"
    func fetchData(city:String, result: @escaping (Data)->()) {
        let escapedCity = city.addingPercentEncoding(withAllowedCharacters:.urlPathAllowed)!
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lang=de&q="+escapedCity+"&appid=\(apiKey)")
        guard let requestUrl = url else {
            fatalError()
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request,completionHandler:
        {
            data, response, error in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data //let dataString = String(data: data, encoding: .utf8)
            {
                result(data)
                //if let w = WeatherJSONDecoder().jsonToWeather(data: data, for: city)
                //{
                  //  print("Das Wetter in \(w.city) : \(w.weather). Die Temperatur beträgt \(w.temperature) Kelvin")
                //}
            }
        })
        task.resume()
    }
}
