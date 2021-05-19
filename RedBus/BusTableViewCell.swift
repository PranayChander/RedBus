//
//  BusTableViewCell.swift
//  RedBus
//
//  Created by pranay chander on 17/05/21.
//

import UIKit

class BusTableViewModel {
    let bus: Bus
    let currency: String

    init(bus: Bus, currency: String) {
        self.bus = bus
        self.currency = currency
    }

    var fare: String {
            return String(bus.fare)
    }

    var rating: String {
       return String(bus.rating )
    }

    

    let calendar = Calendar.current

    var departureTime: String {
        guard let depDate = self.bus.departureTime,
              let depDateInDate = jsonDateFormatter.date(from: self.bus.departureTime)
        else {
            return "NA"
        }
        let components = calendar.dateComponents([.hour, .minute], from: depDateInDate)

        guard let hour = components.hour, let minute = components.minute else {
            return "NA"
        }
        return String(hour) + ":" + String(minute)
    }

    var arrivalTime: String {
        guard let depDate = self.bus.arrivalTime,
              let depDateInDate = jsonDateFormatter.date(from: depDate)
        else {
            return "NA"
        }
        let components = calendar.dateComponents([.hour, .minute], from: depDateInDate)

        guard let hour = components.hour, let minute = components.minute else {
            return "NA"
        }
        return String(hour) + ":" + String(minute)
    }
}

class BusTableViewCell: UITableViewCell {
    @IBOutlet weak var totalStackView: UIStackView!
    @IBOutlet weak var busLogo: UIImageView!
    @IBOutlet weak var busName: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var fare: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var fareStackView: UIStackView!

    var viewModel: BusTableViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
        self.configureData()
    }

    private func configureView() {
        self.totalStackView.layer.cornerRadius = 10.0
        self.totalStackView.layer.borderColor = UIColor.systemOrange.cgColor
        self.totalStackView.layer.borderWidth = 2.0

        self.bookButton.layer.cornerRadius = 10.0
        self.bookButton.layer.maskedCorners = [.layerMinXMinYCorner]

        self.fareStackView.layer.cornerRadius = 10.0
        self.fareStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }

    func configureData() {
        guard let viewModel = self.viewModel else {
            return
        }
        self.currency.text = viewModel.currency
        self.busName.text = viewModel.bus.travelsName
        self.arrivalTime.text = viewModel.arrivalTime
        self.departureTime.text = viewModel.departureTime
        self.fare.text =  viewModel.fare
        self.rating.text = viewModel.rating

        guard let busLogoURL = self.viewModel?.bus.busLogo else {
            return
        }
        RBNetworkService.getBusLogo(url: busLogoURL) { image in
            DispatchQueue.main.async {
                self.busLogo.image = image
            }
        }
    }
}
