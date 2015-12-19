//
//  PhotoViewController.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/16/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func onPhotoSaved(sender: AnyObject) {
        if let image = photoImageView.image {
            savePhotoToLibrary(image)
        } else {
            print("image not present yet")
        }
    }
    
    @IBAction func onPhotoTaken(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        //show the device camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        //set the selected image to the photoImageView.image
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func savePhotoToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    //callback function for the savePhotoToLibrary() method
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to Photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK",style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save Error", message: error?.localizedDescription,
                preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
