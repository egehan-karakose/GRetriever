//
//  ViewController.swift
//  GRetriever
//
//  Created by Egehan KARAKOSE on 10/02/2022.
//  Copyright (c) 2022 egehan205. All rights reserved.
//

import UIKit
import GRetriever

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var characterNames: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        callApi()
        
    }
    
    func callApi() {
        getPeople().retrieve { (response: Response?) in
            guard let response = response else { return }
            self.characterNames = response.results?.compactMap({ $0.name })
            self.tableView.reloadData()
        } failure: { error in
            print(error?.localizedDescription as Any)
        }

    }
    
    func getPeople() -> Retrieve {
        return BaseEndpointType(endpoint: Swapi.getPeople())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characterNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = characterNames?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: MODELS
struct Response: Codable {
    let count: Int?
    let next: String?
    let results: [Result]?
}

struct Result: Codable {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear: String?
    let gender: Gender?
    let homeworld: String?
    let films, species, vehicles, starships: [String]?
    let created, edited: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor
        case skinColor
        case eyeColor
        case birthYear
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
    case nA = "n/a"
}

// MARK: ENDPOINT
public enum Swapi {
    static func getPeople() -> Endpoint {
        return Endpoint(baseURL:  URL(string: "https://swapi.dev")!,
                 path: "/api/people/",
                 httpMethod: .get,
                 httpTask: .request,
                 httpHeaders: HTTPHeaders.json([HeaderModel(key: "Content-Type", value: "application/json")]))
    }
}

