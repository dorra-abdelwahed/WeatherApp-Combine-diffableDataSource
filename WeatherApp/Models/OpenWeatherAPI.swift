//
//  OpenWeatherAPI.swift
//  WeatherApp
//
//  Created by dorra on 1/19/21.
//

import Foundation
import Combine



// MARK: - WeatherFetcher

//MARK: Protocol
protocol WeatherFetcherProtocol {
    ///return a publisher <Output, Error>
    func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse,WeatherError>
    
    func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse,WeatherError>
}

//MARK: Class
class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

//MARK: WeatherFetcherProtocol
extension WeatherFetcher: WeatherFetcherProtocol{
    
    
    func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, WeatherError> {
        
        return request(with: OpenWeatherAPI.makeWeeklyForecastComponents(withCity: city))
    }
    
    func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError> {
        
        return request(with: OpenWeatherAPI.makeCurrentDayForecastComponents(withCity: city))
    }
    
    func request<T: Decodable>(with components: URLComponents) -> AnyPublisher<T,WeatherError>{
        
        ///get url else handler error
        guard let url = components.url else {
            let error = WeatherError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let URL = URLRequest(url: url)
        
        
        return session.dataTaskPublisher(for: URL)
            .mapError { error in
                .network(description: error.localizedDescription)
            }.flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
              }
              .eraseToAnyPublisher()
            
        
    }
    
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WeatherError> {
      
        let decoder = JSONDecoder()

      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    
}
    


// MARK: - OpenWeatherMap API

struct OpenWeatherAPI {
    
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "eafc80478b2fbd7f5b6b52f153aac652"
    
     static func makeWeeklyForecastComponents(
      withCity city: String
    ) -> URLComponents {
      var components = URLComponents()
      components.scheme = OpenWeatherAPI.scheme
      components.host = OpenWeatherAPI.host
      components.path = OpenWeatherAPI.path + "/forecast"
      
      components.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "mode", value: "json"),
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "APPID", value: OpenWeatherAPI.key),
    
      ]
      
      return components
    }
    
     static func makeCurrentDayForecastComponents(
      withCity city: String
    ) -> URLComponents {
      var components = URLComponents()
      components.scheme = OpenWeatherAPI.scheme
      components.host = OpenWeatherAPI.host
      components.path = OpenWeatherAPI.path + "/weather"
      
      components.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "mode", value: "json"),
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
      ]
      
      return components
    }
}

