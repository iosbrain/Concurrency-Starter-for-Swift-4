//
//  ViewController.swift
//  Concurrency Starter
//
//  Created by Andrew Jaffee on 2/4/17.
//  Updated by Andrew Jaffee on 3/7/18.
//
/*
 
 Copyright (c) 2017-2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 NOTE: As this code makes URL references to NASA images, if you make use of 
 those URLs, you MUST abide by NASA's image guidelines pursuant to 
 https://www.nasa.gov/multimedia/guidelines/index.html
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

import Foundation

class ViewController: UIViewController
{
    
    // MARK: - ViewController properties
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var tapCountTextField: UITextField!
    
    //
    // [*0]
    // NOTE: I'm applying the @objc attribute to the following
    // Swift properties to make them accessibile to the Objective-C
    // frameworks like Foundation and UIKit.
    //
    @objc let imageViewTags: [Int] = [10,11,12,13,14,15,16,17,18,19,20]
    
    // NASA images used pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
    @objc let imageURLs: [String] = ["https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1501a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1107a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/large/heic0715a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1608a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/potw1345a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/large/heic1307a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0817a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/opo0328a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0506a.jpg",
                               "https://cdn.spacetelescope.org/archives/images/large/heic0503a.jpg"]
    
    @objc var imageCounter = 0
    
    @objc var buttonTapCount = 0
    
    // MARK: - UIViewController delegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressView.progress = 0.0
        tapCountTextField.text = String(0)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        //buildLayerWithTag(tag: 10)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User interactions

    @IBAction func pressAsyncTapped(_ sender: Any)
    {
        buttonTapCount += 1
        tapCountTextField.text = String(buttonTapCount)
    }
    
    @IBAction func clearImages(_ sender: Any)
    {
        
        progressView.progress = 0.0
        imageCounter = 0
        buttonTapCount = 0
        tapCountTextField.text = String(buttonTapCount)
        
        for i in imageViewTags
        {
            let imageView : UIImageView = self.view.viewWithTag(i) as! UIImageView
            imageView.image = nil
        }
        
    }
    
    @IBAction func startAsyncImageDownload(_ sender: Any)
    {
        printDateTime()
        
        // Download enough images to fill in the UIImageViews on my
        // UIViewController; I've set each UIImageView's "tag" property
        // so I can access each UIImageView programmatically
        for i in imageViewTags
        {
            //
            // [*1] Thread initialization: "you should always call the methods
            // of the UIView class from code running in the main thread of
            // your application"
            // https://developer.apple.com/documentation/uikit/uiview
            //
            let imageView : UIImageView = self.view.viewWithTag(i) as! UIImageView
            
            // show adding the download task to the queue for execution;
            // note that tasks will be ADDED almost INSTANTLY, and you'll
            // see them finish executing later IN ORDER
            print("Image tagged \(i) enquued for execution")
            
            // Start each image download task asynchronously by submitting
            // it to the default background queue; this task is submitted
            // and DispatchQueue.global returns immediately.
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
                
/// *** BEGIN DEFINITION OF TASK/BLOCK TO RUN IN BACKGROUND *** \\\
                
                //
                // I'm PURPOSEFULLY downloading the image using a synchronous call
                // (NSData), but I'm doing so in the BACKGROUND.
                //
                
                //
                // [*1]
                // let imageView : UIImageView = self.view.viewWithTag(i) as! UIImageView
                //
                // ERROR: "UIView.viewWithTag(_:) must be used from main thread only"
                // This is a "Runtime" error.
                //
                let imageURL = URL(string: self.imageURLs[i-10])
                let imageData = NSData(contentsOf: imageURL!)
                
                // Once the image finishes downloading, I jump onto the MAIN
                // THREAD TO UPDATE THE UI.
                DispatchQueue.main.async
                {
                    
    // ** BEGIN DEFINITION OF TASK/BLOCK COMPLETION ** \\
                    
                    //
                    // [*2]
                    // imageView.image = UIImage(data: imageData as! Data)
                    //
                    // "Forced cast from 'NSData?' to 'Data' only
                    // unwraps and bridges; did you mean to use '!' with 'as'?"
                    // This is a "Buildtime" warning.
                    //
                    // So... forcibly unwrap imageData and cast to Data
                    imageView.image = UIImage(data: imageData! as Data)
                    self.imageCounter += 1
                    self.progressView.progress = Float(self.imageCounter) / Float(self.imageURLs.count)
                    print("Image tagged \(i) finished downloading")
                    self.view.setNeedsDisplay()
                    
                    if self.imageCounter == (self.imageURLs.count)
                    {
                        self.printDateTime()
                    }
                    
    // ** END DEFINITION OF TASK/BLOCK COMPLETION ** \\
                    
                } // end DispatchQueue.main.async
                
/// *** END DEFINITION OF TASK/BLOCK TO RUN IN BACKGROUND *** \\\
                    
            } // end DispatchQueue.global
            
        } // end for i in imageViewTags
        
    } // end startAsyncImageDownload
    
    @IBAction func startSyncImageDownload(_ sender: Any)
    {
        printDateTime()
        
        // Define a custom SERIAL background queue. I specify serial by not specifying
        // anything. Serial is the default.
        let serialQueue: DispatchQueue = DispatchQueue(label: "com.iosbrain.SerialImageQueue")
        
        // Download enough images to fill in the UIImageViews on my
        // UIViewController; I've set each UIImageView's "tag" property
        // so I can access each UIImageView programmatically
        for i in imageViewTags
        {
            //
            // [*3] Thread initialization: "you should always call the methods
            // of the UIView class from code running in the main thread of
            // your application"
            // https://developer.apple.com/documentation/uikit/uiview
            //
            let imageView : UIImageView = self.view.viewWithTag(i) as! UIImageView

            // show adding the download task to the queue for execution;
            // note that tasks will be ADDED almost INSTANTLY, and you'll
            // see them finish executing later IN **ANY** ORDER
            print("Image tagged \(i) enquued for execution")

            // Start each image download task asynchronously by submitting
            // it to the CUSTOM SERIAL background queue; this task is submitted
            // and serialQueue.async returns immediately.
            serialQueue.async
            {

/// *** BEGIN DEFINITION OF TASK/BLOCK TO RUN IN BACKGROUND *** \\\
                
                //
                // I'm PURPOSEFULLY downloading the image using a synchronous call
                // (NSData), but I'm doing so in the BACKGROUND.
                //
                
                //
                // [*3]
                // let imageView : UIImageView = self.view.viewWithTag(i) as! UIImageView
                //
                // "UIView.viewWithTag(_:) must be used from main thread only"
                // This is a "Runtime" error
                //
                let imageURL = URL(string: self.imageURLs[i-10])
                let imageData = NSData(contentsOf: imageURL!)
                
                // Once the image finishes downloading, I jump onto the MAIN
                // THREAD TO UPDATE THE UI.
                DispatchQueue.main.async
                {
                    
    // ** BEGIN DEFINITION OF TASK/BLOCK COMPLETION *** \\
                    
                    //
                    // [*4]
                    // imageView.image = UIImage(data: imageData as! Data)
                    //
                    // "Forced cast from 'NSData?' to 'Data' only
                    // unwraps and bridges; did you mean to use '!' with 'as'?"
                    // This is a "Buildtime" warning.
                    //
                    // So... forcibly unwrap imageData and cast to Data
                    imageView.image = UIImage(data: imageData! as Data)
                    self.imageCounter += 1
                    self.progressView.progress = Float(self.imageCounter) / Float(self.imageURLs.count)
                    print("Image tagged \(i) finished downloading")
                    self.view.setNeedsDisplay()
                    
                    if self.imageCounter == (self.imageURLs.count)
                    {
                        self.printDateTime()
                    }
                    
    // ** END DEFINITION OF TASK/BLOCK COMPLETION *** \\
                    
                } // end DispatchQueue.main.async
                
/// *** END DEFINITION OF TASK/BLOCK TO RUN IN BACKGROUND *** \\\
                
            } // end serialQueue.async
            
        } // end for i in imageViewTags
        
    } // end func startSyncImageDownload
    
    // MARK: - Utilities
    
    func printDateTime() -> Void
    {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss:SSS"
        
        let result = formatter.string(from: date)
        
        print(result)
    }
    
} // end class ViewController

