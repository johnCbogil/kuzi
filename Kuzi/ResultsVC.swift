//
//  ResultsVC.swift
//  Kuzi
//
//  Created by John Bogil on 4/7/19.
//  Copyright © 2019 John Bogil. All rights reserved.
//

import Foundation
import UIKit
import Anchors

class ResultsVC: UIViewController {
    // MARK: - PROPERTIES
    var testArray = [Beer]()
    // MARK: - VIEWS
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = .zero
        return tableView
    }()
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.addSubviews([
            tableView
            ])
        activate(tableView.anchor.edges.toSafeLayoutGuide(self.view))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.testArray[indexPath.row].beer_name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
