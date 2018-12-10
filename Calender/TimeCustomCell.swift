//
//  TimeCustomCell.swift
//  Calender
//
//  Created by Jesse Li on 12/10/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit

class TimeCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var startTime: UILabel!
    

    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
