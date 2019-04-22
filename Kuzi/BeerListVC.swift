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

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    init(pageVCTab: PageVCTab) {
        self.pageVCTab = pageVCTab
        super.init()
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
        BeerManager.shared.selectedBeers.append(self.beerList[indexPath.row])
    }
}
