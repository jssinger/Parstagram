//
//  CommentCell.swift
//  Parstagram
//
//  Created by Jonathan Singer on 8/18/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {


    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
