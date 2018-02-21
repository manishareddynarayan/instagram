//
//  PostImageViewController.swift
//  Instagram
//
//  Created by N Manisha Reddy on 2/19/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBAction func chooseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker,animated: true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.postImageView.image = editedImage
            
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.postImageView.image = orginalImage
        }
        else { print ("error") }
        
        picker.dismiss(animated: true, completion: nil)
        
            }
    func displayAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func postImage(_ sender: Any) {
        if let image = postImageView.image {
            let post = PFObject(className: "post")
            post["comment"] = comment.text
            post["userid"] = PFUser.current()?.objectId
            if let imageData = UIImagePNGRepresentation(image) {
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground(block: { (success,error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                        self.displayAlert(title: "Image Posted", message: "image has been posted successfully ")
                        self.comment.text = ""
                        self.postImageView.image = nil
                        
                    } else {
                        self.displayAlert(title: "Image not Posted", message: "please, try again ")

                    }
                    
                    
                })
            }
        
        
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
