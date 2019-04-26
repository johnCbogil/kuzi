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
        if self.pageVCTab == .allBeers {
            BeerManager.shared.selectedBeers.append(self.beerList[indexPath.row])
            self.tableView.reloadData()
        }
    }
}
