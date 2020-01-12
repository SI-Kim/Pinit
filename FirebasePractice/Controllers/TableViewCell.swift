//
//  TableViewCell.swift
//  FirebasePractice
//
//  Created by 김성일 on 2019/12/20.
//  Copyright © 2019 Skim88.1942. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var savedImageView: UIImageView!
    
    @IBOutlet weak var savedTitleLabel: UILabel!
    
    @IBOutlet weak var savedAddressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
