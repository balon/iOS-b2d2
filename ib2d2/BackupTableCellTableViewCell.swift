//
//  BackupTableCellTableViewCell.swift
//  ib2d2
//
//  Created by balon on 5/8/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit

class BackupTableCellTableViewCell: UITableViewCell {

    static let reuseIdentifier = "BackupCell"
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
