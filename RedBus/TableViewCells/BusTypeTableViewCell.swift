//
//  BusTypeTableViewCell.swift
//  RedBus
//
//  Created by pranay chander on 19/05/21.
//

import UIKit

enum busTypeOption: Int {
    case AC, NonAC, Seater, Sleeper

    var predicate: NSPredicate {
        switch self {
        case .AC:
            return NSPredicate(format: "isAC==true")
        case .NonAC:
            return NSPredicate(format: "isNonAc==true")
        case .Seater:
            return NSPredicate(format: "isSeater==true")
        case .Sleeper:
           return NSPredicate(format: "isSleeper==true")
        }
    }
}
protocol BusTypeSelectionProtocol: AnyObject {
    func busTypeSelected(option: busTypeOption)
}

class BusTypeTableViewCell: UITableViewCell {

    weak var delegate: BusTypeSelectionProtocol?

    @IBOutlet var busTypeButtons: [UIButton]!{
        didSet {
            busTypeButtons.forEach { $0.backgroundColor = .darkGray}
            busTypeButtons.forEach {
                $0.layer.cornerRadius = $0.bounds.height / 2
            }
        }
    }

    @IBAction func busTypeSelected(_ sender: UIButton) {
        sender.backgroundColor = .white
        busTypeButtons.filter { $0 != sender}.forEach {$0.backgroundColor = .darkGray}
        guard let sortOption = busTypeOption(rawValue: sender.tag) else {
            return
        }
        delegate?.busTypeSelected(option: sortOption)
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
