//
//  BeerListVC.swift
//  Kuzi
//
//  Created by John Bogil on 4/21/19.
//  Copyright © 2019 John Bogil. All rights reserved.
//

import Foundation
import Anchors
import UIKit

enum PageVCTab {
    case allBeers
    case selectedBeeers
}

class BeerListVC: UIViewController {
    // MARK: - PROPERTIES
    var beerList = [String]()
    private var pageVCTab: PageVCTab

    // MARK: - VIEWS
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var lightHapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()

    // MARK: - INIT
    init(pageVCTab: PageVCTab) {
        self.pageVCTab = pageVCTab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        self.view.addSubviews([
            self.tableView
            ])
        activate(
            self.tableView.anchor.edges.toSafeLayoutGuide(self.view)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.pageVCTab == .selectedBeeers {
            self.beerList = BeerManager.shared.selectedBeers
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func presentBeerCountAlert() {
        let alert = UIAlertController(title: "Alert", message: "Must be 3 unique beers.", preferredStyle: .alert)
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

    func filterAllBeers(with text: String) {
        if text.count > 0 {
            let allBeers = BeerManager.shared.allBeers
            let filteredList = allBeers.filter({$0.lowercased().contains(text.lowercased())})
            self.beerList = filteredList
            self.tableView.reloadData()
        } else {
            self.beerList = BeerManager.shared.allBeers
            self.beerList.sort()
            self.tableView.reloadData()
        }
    }
}

extension BeerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = beerList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.lightHapticGenerator.impactOccurred()

        // Prevent duplicates
        if self.pageVCTab == .allBeers {
            let selectedBeer = self.beerList[indexPath.row]
            if BeerManager.shared.selectedBeers.contains(selectedBeer) {
                return
            }
        }

        // Add beers to selected Beers tab
        if BeerManager.shared.selectedBeers.count < 3 {
            if self.pageVCTab == .allBeers {
                BeerManager.shared.selectedBeers.append(self.beerList[indexPath.row])
                self.tableView.reloadData()
            }
        } else {
            self.presentBeerCountAlert()
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                //            EntriesManager.shared.entriesArray.remove(at: indexPath.row)
                BeerManager.shared.selectedBeers.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                //            self.configureStreakCount()
                self.lightHapticGenerator.impactOccurred()

        }
    }
}
