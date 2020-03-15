//
//  TableViewCell.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/14/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellSubtitle: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
