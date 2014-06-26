//
//  MainViewController.swift
//  Derailr
//
//  Created by Jamie White on 20/06/2014.
//  Copyright (c) 2014 Jamie White. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, NSURLConnectionDataDelegate {
    @IBOutlet var imageView: UIImageView
    @IBOutlet var progressView: UIProgressView
    @IBOutlet var flickView: UIView

    var data: NSMutableData?
    var total: Float?

    let URL = NSURL(string: "http://derailr.s3.amazonaws.com/bike-001.jpg")

    override func viewDidAppear(animated: Bool) {
        loadImage()
    }

    func loadImage() {
        data = NSMutableData()

        NSURLConnection(
            request: NSURLRequest(URL: URL),
            delegate: self
        )
    }

    func connection(connection: NSURLConnection, didReceiveResponse response: NSHTTPURLResponse) {
        if response.statusCode == 200 {
            total = Float(response.expectedContentLength)
        } else {
            showAlert()
        }
    }

    func showAlert() {
        let alert = UIAlertView()
        alert.title = "Something Went Wrong"
        alert.message = "The image could not be downloaded."
        alert.addButtonWithTitle("Dismiss")
        alert.show()
    }

    func connection(connection: NSURLConnection, didReceiveData chunk: NSData) {
        if let data = self.data {
            data.appendData(chunk)
            updateProgress()
        }
    }

    func updateProgress() {
        if (self.data && self.total) {
            let progress = Float(data!.length) / total!
            progressView.setProgress(progress, animated: true)
        }
    }

    func connectionDidFinishLoading(connection: NSURLConnection) {
        progressView.removeFromSuperview()

        imageView.image = UIImage(data: data)
        imageView.alpha = 0
        imageView.transform = CGAffineTransformMakeScale(0.9, 0.9)

        UIView.animateWithDuration(0.25, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = CGAffineTransformMakeScale(1, 1)
        })
    }
}
