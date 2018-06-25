//
//  ContactsTableViewCell.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 25/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var region: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with country: CountryModel) -> (Void) {
        self.name.text = country.name!
        self.capital.text = country.capital!
        self.region.text = country.region!
    }
    
}
