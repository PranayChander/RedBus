//
//  RatingTableViewCell.swift
//  RedBus
//
//  Created by pranay chander on 19/05/21.
//

import UIKit

enum RatingOption: Int {
    case star5, star4, star3, star2, base

    var predicate: NSPredicate {
        switch self {
        case .star5:
            return NSPredicate(format: "fare==5")
        case .star4:
            return NSPredicate(format: "fare>=4")
        case .star3:
            return NSPredicate(format: "fare>=3")
        case .star2:
           return NSPredicate(format: "fare>=2")
        case .base:
            return NSPredicate(format: "fare>=0")
        }
    }
}
protocol RatingSelectionProtocol: AnyObject {
    func ratingSelected(option: RatingOption)
}

class RatingTableViewCell: UITableViewCell {

    weak var delegate: RatingSelectionProtocol?

    @IBOutlet var ratingButtons: [UIButton]! {
    didSet {
        ratingButtons.forEach { $0.backgroundColor = .darkGray}
        ratingButtons.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
    }
    }


    @IBAction func ratingButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .white
        ratingButtons.filter { $0 != sender}.forEach {$0.backgroundColor = .darkGray}
        guard let sortOption = RatingOption(rawValue: sender.tag) else {
            return
        }
        delegate?.ratingSelected(option: sortOption)
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
