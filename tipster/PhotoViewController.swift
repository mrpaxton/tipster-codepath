//
//  PhotoViewController.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/16/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController{
    
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var billImage: UIImage!
    
    @IBAction func onPhotoSaved(sender: AnyObject) {
        if let image = photoImageView.image {
            savePhotoToLibrary(image)
        } else {
            print("image not present yet")
        }
    }
    
    func savePhotoToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    //callback function for the savePhotoToLibrary() method
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to Photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK",style: .Default) {
                UIAlertAction in self.performSegueWithIdentifier("exitPhotoView", sender: self)
            })
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save Error", message: error?.localizedDescription,
                preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler:  nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    //required unwindForSegue method for unwinding to exit the view
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = billImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
