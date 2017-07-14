//
//  RatingView.swift
//  CustomView
//
//  Created by Marcelo Reina on 02/05/17.
//  Copyright © 2017 Marcelo Reina. All rights reserved.
//

import UIKit


/// Provides a set of functions to manage a RatingView.
/// It is not necessary to implement the protocol to use RatingView
/// but it improves the control over it.
protocol RatingViewDelegate: NSObjectProtocol {
    
    /// Called before the `currentRating` is changed.
    ///
    /// - Parameter newValue: the value that will be atributed to currentRating.
    func willChangeRating(to newValue: Int)
    
    /// Called after the `currentRating` has changed.
    ///
    /// - Parameter oldValue: the value `currentRating` had before the change.
    func didChangeRating(oldValue: Int)
    
    /// If the view is tapped, outside of any button, it will be cleared based on
    /// the return of this function. The default behavior is set to `false`.
    ///
    /// - Returns: true if it should set the `currentRating` to 0, false does nothing.
    func shouldClearRatingOnTap() -> Bool
    
    
    /// Provides a fade in animation whenever a star button will change it's background image.
    /// The default behavior is set to `false`
    ///
    /// - Returns: `true` if it should animate, `false` does nothing.
    func shouldAnimateRatingChanges() -> Bool
}


/// Custom UIView to manage users ratings using blue stars.
/// It sets ratings from 0 to 5. It also provides a protocol `RatingViewDelegate` that can
/// improve its usage by giving the developer options to control animations and behaviors.
/// - Important: The only way let the user choose a 0 rating after one selected is by implementing
/// the `RatingViewDelegate` protocol. See `shouldClearRatingOnTap`.
@IBDesignable class RatingView: UIView {

    //MARK: Constants
    
    fileprivate let emptyStarAssetName: String = "emptyStar"
    fileprivate let filledStarAssetName: String = "filledStar"
    fileprivate let starAnimationDuration: TimeInterval = 0.3
    
    //MARK: Properties
    
    /// view that is loaded from xib file
    fileprivate var contentView: UIView!
    
    /// outlet collection with all star buttons
    @IBOutlet var stars: [UIButton]!
    
    
    /// delegate to control animation, tap to clear or `currentRating` observing
    weak var delegate: RatingViewDelegate?
    
    /// current rating that can range from 0 to 5
    fileprivate(set) var currentRating: Int = 0 {
        willSet {
            if (newValue != currentRating) {
                delegate?.willChangeRating(to: newValue)
            }
        }
        
        didSet {
            if oldValue != currentRating {
                updateStars()
                delegate?.didChangeRating(oldValue: oldValue)
            }
        }
    }
    
    @IBInspectable var isViewOnly: Bool = false 
    
    //MARK: Designable properties
    //## 2 - UNCOMMENT: Debug view to find the error
    @IBInspectable var contentBackgroundColor: UIColor = UIColor.clear {
        didSet {
            backgroundColor = UIColor.clear
            contentView.backgroundColor = contentBackgroundColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            contentView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            contentView.layer.borderColor = borderColor.cgColor
        }
    }
    
    //MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupXib()
    }
    
    //MARK: IBDesignable
    
    //## 3 - UNCOMMENT: Solution
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    //## 1 - UNCOMMENT: XIB Appears
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    //MARK: Actions
    
    /// Called everytime a star button is pressed. It changes the currentRating
    /// based on the tag of the button and updates all stars to reflect that change
    ///
    /// - Parameter sender: the star button pressed
    @IBAction func starPressed(sender: UIButton) {
        if(!isViewOnly) {
           currentRating = sender.tag
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        // check if it necessary to clear rating with delegate 
        if delegate != nil {
            if delegate!.shouldClearRatingOnTap() {
                currentRating = 0
            }
        }
    }
    
    //MARK: Stars Management
    
    /// Set the correct background image for all star buttons based on the currentRating
    /// It will animate the image change based on delegate's choice
    fileprivate func updateStars() {
        for star in stars {
            // set the correct image for the button
            if star.tag > currentRating {
                star.setImage(UIImage(named: emptyStarAssetName), for: .normal)
            } else {
                star.setImage(UIImage(named: filledStarAssetName), for: .normal)
            }
            
            // check if it is necessary to animate the star
            if delegate != nil {
                if delegate!.shouldAnimateRatingChanges() {
                    animateImageChange(star: star)
                }
            }
        }
    }
    
    public func setRating(rating:Float) {
        self.currentRating = Int(rating.rounded())
    }
    
    
    /// Perform a fade in animation on a specific star button
    ///
    /// - Parameter star: button that should perform the fade animation
    fileprivate func animateImageChange(star: UIButton) {
        star.alpha = 0
        UIView.animate(withDuration: starAnimationDuration) {
            star.alpha = 1
        }
    }
    
}

//MARK: Xib functions
extension RatingView {
    
    /// Instantiate the view defined in a xib file using the same name of the class
    ///
    /// - Returns: the first view found in the xib or nil if it was unable to find any view
    func loadViewFromXib() -> UIView? {
        // first of all, load the bundle where the xib is.
        let bundle = Bundle(for: type(of: self))
        
        // load the xib from the main bundle
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        // load the view inside the xib
        return xib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /// Loads the xib, associates it to the contentView and add it to the view's hierarchy
    func setupXib() {
        // only load the xib if the contentView is not loaded yet
        if contentView == nil {
            // load content view from xib
            contentView = loadViewFromXib()
            
            // if it has failed, this example needs to be rewriten
            guard contentView != nil else {
                fatalError("Can't load the view from \(String(describing: type(of: self))).xib")
            }
            
            // adjust the contentView to have the same size of the view itself
            contentView.frame = bounds
            
            // let the content view adjusts automatically for flexible size (width and height)
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // set background color to transparent as default
            backgroundColor = UIColor.clear
            
            for star in self.stars {
                star.imageView?.tintColor = self.tintColor
            }
            
            // add content view to the view hierarchy
            addSubview(contentView)
        }
    }
    
}
