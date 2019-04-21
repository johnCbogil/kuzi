//
//  ViewController.swift
//  Kuzi
//
//  Created by John Bogil on 4/7/19.
//  Copyright © 2019 John Bogil. All rights reserved.
//

import UIKit
import Anchors

class ViewController: UIViewController {

    // MARK: - PROPERTIES
    private lazy var selectedBeers = [String]()
    private lazy var resultBeers = [Beer]()

    // MARK: - VIEWS
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 62, weight: .bold)
        label.text = "Kuzi"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Beer Recommendations"
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "To get started, let us know which beers you like"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var getRecommendationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Recommendations", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.addTarget(self, action: #selector(getRecommendationsButtonDidPress), for: .touchUpInside)
        button.backgroundColor = .red
        button.tintColor = .white
        button.sizeToFit()
        button.layer.cornerRadius = button.frame.height / 2.0
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = .zero
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Beer name"
        searchBar.returnKeyType = .done
        return searchBar
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
        button.tintColor = UIColor.gray.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(infoButtonDidPress), for: .touchUpInside)

        return button
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .white
        self.title = "Kuzi"
        self.view.addSubviews([
            titleLabel,
            subtitleLabel,
            instructionLabel,
            searchBar,
            tableView,
            getRecommendationsButton,
            infoButton
            ])
        activate(
            self.titleLabel.anchor.top.toSafeLayoutGuide(self.view),
            self.titleLabel.anchor.paddingHorizontally(20),

            self.subtitleLabel.anchor.top.to(self.titleLabel.anchor.bottom).constant(10),
            self.subtitleLabel.anchor.paddingHorizontally(20),

            self.instructionLabel.anchor.top.to(self.subtitleLabel.anchor.bottom).constant(20),
            self.instructionLabel.anchor.paddingHorizontally(10),

            self.infoButton.anchor.size.equal.to(25),
            self.infoButton.anchor.trailing.constant(-15),
            self.infoButton.anchor.centerY.equal.to(self.searchBar.anchor.centerY),
            
            self.searchBar.anchor.top.to(self.instructionLabel.anchor.bottom).constant(10),
            self.searchBar.anchor.leading.constant(10),
            self.searchBar.anchor.trailing.to(self.infoButton.anchor.leading).constant(-5),

            self.tableView.anchor.top.to(self.searchBar.anchor.bottom).constant(10),
            self.tableView.anchor.paddingHorizontally(0),
            self.tableView.anchor.height.equal.to(300),

            self.getRecommendationsButton.anchor.centerX,
            self.getRecommendationsButton.anchor.paddingHorizontally(20),
            self.getRecommendationsButton.anchor.bottom.toSafeLayoutGuide(self.view).constant(-20)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func getRecommendations() {
//        let Url = String(format: "https://safe-beach-47162.herokuapp.com/predict")
        let Url = String(format: "https://safe-beach-47162.herokuapp.com/predict")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["userId" : ["101010"], "beer_name" : ["Founders CBS Imperial Stout"]]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    self.resultBeers = beers
                    print(beers)
                    let resultsVC = ResultsVC()
                    resultsVC.testArray = self.resultBeers
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }


                } catch {
                    print(error)
                }
            }
            }.resume()

    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    @objc private func getRecommendationsButtonDidPress() {
        getRecommendations()

    }

    @objc private func infoButtonDidPress() {

        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")

            @unknown default:
                fatalError()
            }
        }
            )
        )
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        guard let text = searchBar.text else { return }
        self.selectedBeers.append(text)
        self.tableView.reloadData()
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedBeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.selectedBeers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.selectedBeers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach(self.addSubview)
    }
}

extension Anchor {
    func toSafeLayoutGuide(_ view: UIView) -> Anchor {
        return self.to(view.safeAreaLayoutGuide.anchor)
    }
}

