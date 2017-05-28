//
//  TableViewCell.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/23/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //Mark: table view cell outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userWebsite: UILabel!

    //Mark: table view cell awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Mark: table view cell set selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
