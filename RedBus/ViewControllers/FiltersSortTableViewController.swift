//
//  FiltersSortTableViewController.swift
//  RedBus
//
//  Created by pranay chander on 19/05/21.
//

import UIKit

protocol FilterSortSelectionProtocol: AnyObject {
    func filterSortOptionsSelected(sortOption: SortOption?, ratingOption: RatingOption?, busTypeOption: busTypeOption?)
}

class FiltersSortTableViewController: UITableViewController {
    var selectedSortOption: SortOption?
    var selectedRatingOption: RatingOption?
    var selectedBusTypeOption: busTypeOption?

    weak var delegate: FilterSortSelectionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: RBConstants.sortCell, bundle: nil), forCellReuseIdentifier: RBConstants.sortCell)
        self.tableView.register(UINib(nibName: RBConstants.ratingCell, bundle: nil), forCellReuseIdentifier: RBConstants.ratingCell)
        self.tableView.register(UINib(nibName: RBConstants.busTypeCell, bundle: nil), forCellReuseIdentifier: RBConstants.busTypeCell)
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(save))
    }

    @objc func save() {
        delegate?.filterSortOptionsSelected(sortOption: selectedSortOption, ratingOption: selectedRatingOption, busTypeOption: selectedBusTypeOption)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RBConstants.sortCell, for: indexPath) as? SortTableViewCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RBConstants.ratingCell, for: indexPath) as? RatingTableViewCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: RBConstants.busTypeCell, for: indexPath) as? BusTypeTableViewCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension FiltersSortTableViewController: SortSelectionProtocol, RatingSelectionProtocol, BusTypeSelectionProtocol {
    func ratingSelected(option: RatingOption) {
        self.selectedRatingOption = option
    }

    func busTypeSelected(option: busTypeOption) {
        self.selectedBusTypeOption = option
    }

    func sortOptionSelected(option: SortOption) {
        self.selectedSortOption = option
    }
}
