//
//  ViewController.swift
//  FlickrRocket
//
//  Created by jbaumann on 2/16/18.
//  Copyright © 2018 jbaumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Handle swipe gestures by showing the previous or next photo for a right or left swipe, respectively
    @IBAction func swipeRightGestureHandler(_ sender: UISwipeGestureRecognizer) {
        showPreviousPhoto()
    }
    @IBAction func swipeLeftGestureHandler(_ sender: UISwipeGestureRecognizer) {
        showNextPhoto()
    }
    
    // The list of all the Photos tagged as rockets
    var rocketPhotos: [Photo] = []
    // The index in rocketPhotos of the photo currently being shown in the imageView
    var currentPhotoIndex: Int = 0
    // The total number of Photos in rocketPhotos
    var numPhotos: Int = 0
    // The current progress of the progressView as images are being downloaded
    var progressBarProgress: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow swipes on the imageView to be sensed
        imageView.isUserInteractionEnabled = true
        
        guard let rocketPhotosURL = URL(string: "https://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=rocket&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1") else {
            print("Error while creating search results URL")
            return
        }
        
        NetworkingService.shared.fetchPhotoSearchResults(url: rocketPhotosURL) { photos in
            self.rocketPhotos = photos
            self.numPhotos = self.rocketPhotos.count
            self.downloadImages(photos: self.rocketPhotos)
            self.updatePhotoShown(photo: self.rocketPhotos[self.currentPhotoIndex])
            // In case the progress view is still in the view
            DispatchQueue.main.async {
                if self.progressView?.progress == 1.0 {
                    self.progressView.removeFromSuperview()
                }
            }
        }
    }
    
    // Shows the photo at the next index in rocketPhotos, or the first if the current index is numPhotos-1
    func showNextPhoto() {
        // Check to see if the list of photos needs to wrap to the first element from the last
        if currentPhotoIndex >= numPhotos-1 {
            currentPhotoIndex = 0
        } else {
            currentPhotoIndex += 1
        }
        updatePhotoShown(photo: rocketPhotos[currentPhotoIndex])
    }
    
    // Shows the photo at the previous index in rocketPhotos, or the last if the current index is 0
    func showPreviousPhoto() {
        // Check to see if the list of photos needs to wrap to the last element from the first
        if currentPhotoIndex <= 0 {
            currentPhotoIndex = numPhotos-1
        } else {
            currentPhotoIndex -= 1
        }
        updatePhotoShown(photo: rocketPhotos[currentPhotoIndex])
    }
    
    // Retrieve the given photo from the ImageDownloadService cache and display it (and its title) with a cross disolve animation
    func updatePhotoShown(photo: Photo) {
        ImageDownloadService.shared.downloadImage(url: photo.photoURL) { image  in
            DispatchQueue.main.async {
                // Set the new image and animate its transition with a cross dissolve for 1 second
                UIView.transition(with: self.imageView, duration: 1, options: .transitionCrossDissolve, animations: {self.imageView.image = image}, completion: nil)
                self.titleLabel.text = photo.title
            }
        }
    }
    
    // Downloads all of the images in the given list of Photos to store them in the ImageDownloadService cache
    func downloadImages(photos: [Photo]) {
        // For each Photo, download its image and increment the progress bar
        for photo in photos {
            ImageDownloadService.shared.downloadImage(url: photo.photoURL) { image  in
                self.incrementProgressBar()
            }
        }
    }
    
    // Increments the image downloading progress bar by one and removes it if all the images have been downloaded
    func incrementProgressBar() {
        progressBarProgress += 1
        let progress = progressBarProgress / Float(numPhotos)
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
            
            // Remove progressView from the view if it is full
            if self.progressView?.progress == 1.0 {
                self.progressView.removeFromSuperview()
            }
        }
    }

}

