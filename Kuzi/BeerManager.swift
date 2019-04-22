//
//  BeerManager.swift
//  Kuzi
//
//  Created by John Bogil on 4/21/19.
//  Copyright © 2019 John Bogil. All rights reserved.
//

import Foundation


class BeerManager {

    // MARK: - INIT
    static let shared = BeerManager()
    var selectedBeers = [String]()
    var allBeers = [String]()

    init() {
        self.allBeers = self.getBeersFromCSV()
    }


    func getBeersFromCSV() -> [String] {
        var error: NSError?
        if let fileUrl = Bundle.main.url(forResource: "beerNames", withExtension:"csv") {
            if let text = try? String(contentsOf: fileUrl, encoding: .utf8) {
                let beers = text.components(separatedBy: "\r\n")
                print(beers.count)
                return beers
            } else {
                print("error reading file")
                if let error = error {
                    print(error.description)
                }
            }
        }
        return [""]
    }
}
