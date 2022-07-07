//
//  RequestViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit
import RealmSwift

class RequestViewController: UIViewController {

    @IBOutlet weak var tableViewForRequestedData: UITableView!

    var realmProvider: RealmProviderProtocol!
    private var notificationToken: NotificationToken?
    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {

        super.viewDidLoad()

        realmProvider = RealmProvider()

        tableViewForRequestedData.delegate = self
        tableViewForRequestedData.dataSource = self

        tableViewForRequestedData.register(UINib(nibName: "RequestDataCell", bundle: nil), forCellReuseIdentifier: RequestDataCell.key)
        
        //Add refreshControl
        refreshControl = UIRefreshControl()
        tableViewForRequestedData.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data table")
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

        let data = realmProvider.getResultForDataBase(objectName: QueryListForRealm.self)

        notificationToken = data.observe { [weak self] (changes: RealmCollectionChange) in

            guard let tableViewForRequest = self?.tableViewForRequestedData else { return }

            switch changes {

            case .initial: break

            case .update(_, _, let insertions, _):
                tableViewForRequest.performBatchUpdates({ tableViewForRequest.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                })

            case .error(let error): fatalError("\(error)")
            }
        }
    }

    //Func for refresh Table
    @objc private func refreshTable() {
        
        tableViewForRequestedData.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            self.refreshControl.endRefreshing()
        }
    }
    
    deinit {

        notificationToken?.invalidate()
    }
}
