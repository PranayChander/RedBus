//
//  SortTableViewCell.swift
//  RedBus
//
//  Created by pranay chander on 19/05/21.
//

import UIKit

enum SortOption: Int {
    case cheapestFirst, topRated, arrivingFirst, leavingLast

    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .cheapestFirst:
            return NSSortDescriptor(key: "fare", ascending: false)
        case .topRated:
            return NSSortDescriptor(key: "rating", ascending: true)
        case .arrivingFirst:
            return NSSortDescriptor(key: "arrivalTime", ascending: false)
        case .leavingLast:
           return NSSortDescriptor(key: "departureTime", ascending: false)
        }
    }
}
protocol SortSelectionProtocol: AnyObject {
    func sortOptionSelected(option: SortOption)
}

class SortTableViewCell: UITableViewCell {

    weak var delegate: SortSelectionProtocol?

    @IBOutlet var sortButtons: [UIButton]! {
        didSet {
            sortButtons.forEach { $0.backgroundColor = .darkGray}
            sortButtons.forEach {
                $0.layer.cornerRadius = $0.bounds.height / 2
            }
        }
    }


    @IBAction func didSelectSortOption(_ sender: UIButton) {
        sender.backgroundColor = .white
        sortButtons.filter { $0 != sender}.forEach {$0.backgroundColor = .darkGray}
        guard let sortOption = SortOption(rawValue: sender.tag) else {
            return
        }
        delegate?.sortOptionSelected(option: sortOption)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
