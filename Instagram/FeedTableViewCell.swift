//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by N Manisha Reddy on 2/19/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var likeIconImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    override func awakeFromNib() {
//        let gesture = UITapGestureRecognizer(target: self, action:Selector(("onDoubleTap:")))
//        gesture.numberOfTapsRequired = 2
//        contentView.addGestureRecognizer(gesture)
//        
//        likeIconImage?.isHidden = true
//        func onDoubleTap(sender:AnyObject) {
//            likeIconImage?.isHidden = false
//            likeIconImage?.alpha = 1.0
//            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.repeat, animations: {
//                  self.likeIconImage?.alpha = 0
//            }) { (Bool) in
//                self.likeIconImage?.isHidden = true
//            }
//        }
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
