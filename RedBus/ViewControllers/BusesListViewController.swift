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

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedSort = SortOption.leavingLast.sortDescriptor
    var selectedRating = RatingOption.base.predicate
    var selectedType = busTypeOption.Seater.predicate

    private lazy var fetchedResultController: NSFetchedResultsController<Bus> = {
        let fetchRequest: NSFetchRequest<Bus> = Bus.fetchRequest()
        fetchRequest.sortDescriptors = [selectedSort]
        fetchRequest.predicate = selectedRating
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters & Sort", style: .plain, target: self, action: #selector(self.didTapSortFilters))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
        self.tableView.register(UINib(nibName: RBConstants.BusTableViewCell, bundle: nil), forCellReuseIdentifier: RBConstants.BusTableViewCell)
        fetchedResultController.delegate = self
        do {
            try self.fetchedResultController.performFetch()
        } catch  {
            print("Couldnt Perform Fetch")
        }
        RBNetworkService.getBuses(context: context)

        let data = try? context.fetch(RBData.fetchRequest()).first as? RBData

        self.sourceLabel.text = data?.source
        self.destinationLabel.text = data?.destination
    }

    @objc func didTapSortFilters() {
        self.performSegue(withIdentifier: RBConstants.filterSortSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterSortVC = (segue.destination as? UINavigationController)?.topViewController as? FiltersSortTableViewController {
            filterSortVC.delegate = self
        }
    }
}

extension BusesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RBConstants.BusTableViewCell) as? BusTableViewCell  else {
            return UITableViewCell()
        }
        let bus = fetchedResultController.object(at: indexPath)
        let currency = bus.data?.currency ?? "INR"
        cell.viewModel = BusTableViewModel(bus: bus, currency: currency)
        cell.configureData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension BusesListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}

extension BusesListViewController: FilterSortSelectionProtocol {
    func filterSortOptionsSelected(sortOption: SortOption?, ratingOption: RatingOption?, busTypeOption: busTypeOption?) {
        if let sortOption = sortOption {
            self.selectedSort = sortOption.sortDescriptor
        }

        if let ratingOption = ratingOption {
            self.selectedRating = ratingOption.predicate
        }
        if let busTypeOption = busTypeOption {
            self.selectedType = busTypeOption.predicate
        }
        try? fetchedResultController.performFetch()
    }
}
