//
//  newsFeedTableViewCell.swift
//  Instagram
//
//  Created by N Manisha Reddy on 2/21/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit

class newsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
                gesture.numberOfTapsRequired = 2
                contentView.addGestureRecognizer(gesture)
                likeImage?.isHidden = true
        
        // Initialization code
    }
    func onDoubleTap(_ sender: UITapGestureRecognizer) {
        likeImage?.isHidden = false
        likeImage?.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.likeImage?.alpha = 0
        }) { (finished) in
            if finished {
                self.likeImage?.isHidden = true
            }
        }
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
