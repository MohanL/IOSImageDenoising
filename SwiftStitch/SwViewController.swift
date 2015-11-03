//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit

class SwViewController: UIViewController, UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    var photoimageview = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    let imagePicker = UIImagePickerController()
    var UIImagearray = [UIImage]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //stitch()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoimageview.contentMode = .ScaleAspectFit
            photoimageview.image = pickedImage
            UIImagearray.append(pickedImage)
            print("UIImagearray is of type [UIimage] with \(UIImagearray.count) items.")
        }
        else{
            print("wattt")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pick(sender: AnyObject) {
        print("called selectasdf")
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func remove(sender: AnyObject) {
        if(!UIImagearray.isEmpty)
        {
            UIImagearray.removeLast()
            print("UIImagearray is of type [UIimage] with \(UIImagearray.count) items.")
        }
        else{
            print("UIImagearray is of type [UIimage] with 0 items.")
        }
        
    }
    @IBAction func process(sender: AnyObject) {
        print("called stitch")
        stitch()
    }
    func stitch() {
        self.spinner.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            if(!self.UIImagearray.isEmpty)
            {
                let imageArray:[UIImage!] = self.UIImagearray
               
                let stitchedImage:UIImage = CVWrapper.processWithArray(imageArray) as UIImage
                // dispatch
                
                dispatch_async(dispatch_get_main_queue()) {
                    NSLog("stichedImage %@", stitchedImage)
                    let imageView:UIImageView = UIImageView.init(image: stitchedImage)
                    self.imageView = imageView
                    
                    self.scrollView.addSubview(self.imageView!)
                    self.scrollView.backgroundColor = UIColor.blackColor()
                    self.scrollView.contentSize = self.imageView!.bounds.size
                    self.scrollView.maximumZoomScale = 4.0
                    self.scrollView.minimumZoomScale = 0.5
                    self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                    NSLog("scrollview \(self.scrollView.contentSize)")
                    self.spinner.stopAnimating()
                }

            }
        }
    }
    
    
    func viewForZoomingInScrollView(scrollView:UIScrollView) -> UIView? {
        return self.imageView!
    }
    
}
