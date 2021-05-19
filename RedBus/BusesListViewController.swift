//
//  BusesListViewController.swift
//  RedBus
//
//  Created by pranay chander on 17/05/21.
//

import UIKit
import CoreData

class BusesListViewController: UIViewController {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    var rbData: RBData? {
        didSet {
            guard let busesList = rbData?.busList else {
                return
            }
            self.busesList = busesList
            DispatchQueue.main.async {
                self.sourceLabel.text = self.rbData?.source
                self.destinationLabel.text = self.rbData?.destination
                self.tableView.reloadData()
            }
        }
    }

    var busesList: [Bus] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: RBConstants.BusTableViewCell, bundle: nil), forCellReuseIdentifier: RBConstants.BusTableViewCell)

        RBNetworkService.getBuses { data in
            self.rbData = data
        }
    }
}

extension BusesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RBConstants.BusTableViewCell) as? BusTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = BusTableViewModel(bus: busesList[indexPath.row], currency: rbData?.currency ?? "INR")
        cell.configureData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
