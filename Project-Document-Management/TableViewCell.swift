//
//  TableViewCell.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/23/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionPreview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
