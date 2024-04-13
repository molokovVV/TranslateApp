//
//  APIService.swift
//  TranslateApp
//
//  Created by Виталик Молоков on 12.04.2024.
//

import Foundation

class TranslatorAPI {
    private static var currentDataTask: URLSessionDataTask?

    // Сделаем метод translate статическим
    static func translate(text: String, from sl: String, to dl: String, completion: @escaping (String) -> Void) {
        // Отменяем предыдущий запрос, если он существует
        currentDataTask?.cancel()

        let urlString = "https://ftapi.pythonanywhere.com/translate?dl=\(dl)&text=\(text)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            completion("Error: URL formation failed")
            return
        }

        currentDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError, urlError.code == .cancelled {
                // Запрос был отменен, ничего не делаем
                return
            } else if let error = error {
                // Обработка других сетевых ошибок
                completion("Error: Network problem - \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion("Error: No data received")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let translatedText = json["destination-text"] as? String {
                DispatchQueue.main.async {
                    completion(translatedText)
                }
            } else {
                DispatchQueue.main.async {
                    completion("Translation failed: No valid response")
                }
            }
        }
        currentDataTask?.resume()
    }
}

