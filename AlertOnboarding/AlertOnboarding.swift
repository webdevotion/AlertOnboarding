//
//  AlertOnboarding.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//  Forked by Webdevotion 07/2017

import UIKit

public protocol AlertOnboardingDelegate {
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int)
    func alertOnboardingCompleted()
    func alertOnboardingNext(_ nextStep: Int)
    func alertOnboardingPrev(_ prevStep: Int)
    func alertOnboardingAllowedToContinue(_ completion: ((Bool) -> Void)?)
    func alertOnboardingAllowedToGoBack(_ completion: ((Bool) -> Void)?)
}

open class AlertOnboarding: UIView, AlertPageViewDelegate {
    
    //FOR DATA  ------------------------
    fileprivate var arrayOfImage = [String]()
    fileprivate var arrayOfTitle = [String]()
    fileprivate var arrayOfDescription = [String]()
    fileprivate var arrayOfContainers = [UIViewController]()
    
    //FOR DESIGN    ------------------------
    open var buttonBottom: UIButton!
    fileprivate var container: AlertPageViewController!
    open var background: UIView!
    open var legalTextView: UITextView!
    
    
    //PUBLIC VARS   ------------------------
    open var colorForAlertViewBackground: UIColor = UIColor.white
    
    open var colorButtonBottomBackground: UIColor = UIColor(red: 226/255, green: 237/255, blue: 248/255, alpha: 1.0)
    open var colorButtonText: UIColor = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var colorTitleLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorDescriptionLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    
    open var colorPageIndicator = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorCurrentPageIndicator = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var heightForAlertView: CGFloat!
    open var widthForAlertView: CGFloat!
    
    open var percentageRatioHeight: CGFloat = 1.0
    open var percentageRatioWidth: CGFloat = 1.0
    
    open var titleSkipButton = "SKIP"
    open var titleGotItButton = "GOT IT !"
    open var legalText: NSAttributedString = NSAttributedString()
    
    open var delegate: AlertOnboardingDelegate?
    
    
    public init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String], arrayOfContainers: [UIViewController]) {
        super.init(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        self.configure()
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        self.arrayOfContainers = arrayOfContainers
        self.interceptOrientationChange()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //-----------------------------------------------------------------------------------------
    // MARK: PUBLIC FUNCTIONS    --------------------------------------------------------------
    //-----------------------------------------------------------------------------------------
    
    open func show(animated:Bool = false) {
        
        //Update Color
        self.buttonBottom.backgroundColor = colorButtonBottomBackground
        self.backgroundColor = colorForAlertViewBackground
        self.buttonBottom.setTitleColor(colorButtonText, for: UIControlState())
        self.buttonBottom.setTitle(self.titleSkipButton, for: UIControlState())
        
        self.legalTextView.attributedText = self.legalText
        
        self.container = AlertPageViewController(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, arrayOfContainers: self.arrayOfContainers,alertView: self)
        self.container.delegate = self
        self.insertSubview(self.container.view, aboveSubview: self)
        self.insertSubview(self.buttonBottom, aboveSubview: self)
        self.insertSubview(self.legalTextView, aboveSubview: self)
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current stop viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self.background)
            superView.addSubview(self)
            self.configureConstraints(topController.view)
            self.animateForOpening(animated)
        }
    }
    
    //Hide onboarding with animation
    open func hide(animated:Bool = false){
        self.checkIfOnboardingWasSkipped()
        DispatchQueue.main.async { () -> Void in
            self.animateForEnding(animated)
        }
    }
    
    
    //------------------------------------------------------------------------------------------
    // MARK: PRIVATE FUNCTIONS    --------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //MARK: Check if onboarding was skipped
    fileprivate func checkIfOnboardingWasSkipped(){
        let currentStep = self.container.currentStep
        if currentStep.isLastPageIndex && !self.container.isCompleted{
            self.delegate?.alertOnboardingSkipped(currentStep.value, maxStep: self.container.maxStep)
        }
        else {
            self.delegate?.alertOnboardingCompleted()
        }
    }
    
    
    //MARK: FOR CONFIGURATION    --------------------------------------
    fileprivate func configure(cornerRadius:CGFloat=4.0) {
        
        self.buttonBottom = UIButton(frame: .zero)
        self.buttonBottom.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        self.buttonBottom.addTarget(self, action: #selector(AlertOnboarding.onContinue), for: .touchUpInside)
        self.buttonBottom.layer.cornerRadius = cornerRadius
        
        self.legalTextView = UITextView(frame: .zero)
        self.legalTextView.backgroundColor = .clear
        
        
        self.background = UIView(frame: CGRect(x: 0,y: 0, width: 0, height: 0))
        self.background.backgroundColor = UIColor.black
        self.background.alpha = 0.5
        
        
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    
    fileprivate func configureConstraints(_ superView: UIView) {

        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBottom.translatesAutoresizingMaskIntoConstraints = false
        self.container.view.translatesAutoresizingMaskIntoConstraints = false
        self.background.translatesAutoresizingMaskIntoConstraints = false
        self.legalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.removeConstraints(self.constraints)
        self.buttonBottom.removeConstraints(self.buttonBottom.constraints)
        self.container.view.removeConstraints(self.container.view.constraints)
        
        heightForAlertView = UIScreen.main.bounds.height*percentageRatioHeight
        widthForAlertView = UIScreen.main.bounds.width*percentageRatioWidth
        
        //Constraints for alertview
        let horizontalContraintsAlertView   = NSLayoutConstraint(item: self, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let verticalContraintsAlertView     = NSLayoutConstraint(item: self, attribute:.centerYWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForAlertView    = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView)
        let widthConstraintForAlertView     = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        
        //Constraints for legal text
        self.legalTextView.isScrollEnabled = false
        let megasize = self.legalTextView.sizeThatFits(CGSize(width: widthForAlertView, height: CGFloat.greatestFiniteMagnitude))
        
        let verticalContraintsLegalText     = NSLayoutConstraint(item: self.legalTextView, attribute:.centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForLegalText    = NSLayoutConstraint(item: self.legalTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: megasize.height)
        let widthConstraintForLegalText     = NSLayoutConstraint(item: self.legalTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView - 50.0)
        let pinContraintsButtonLegalText    = NSLayoutConstraint(item: self.legalTextView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -12.0)
        
        //Constraints for button
        let verticalContraintsButtonBottom  = NSLayoutConstraint(item: self.buttonBottom, attribute:.centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForButtonBottom = NSLayoutConstraint(item: self.buttonBottom, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0)
        let widthConstraintForButtonBottom  = NSLayoutConstraint(item: self.buttonBottom, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView - 50.0)
        let pinContraintsButtonBottom       = NSLayoutConstraint(item: self.buttonBottom, attribute: .bottom, relatedBy: .equal, toItem: self.legalTextView, attribute: .top, multiplier: 1.0, constant: 0)
        
        
        //Constraints for container
        let horizontalContraintForContainer = NSLayoutConstraint(item: self.container.view, attribute:.centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        // let cHeight = heightForAlertView - heightConstraintForButtonBottom.constant -
        // let heightConstraintForContainer = NSLayoutConstraint.init(item: self.container.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cHeight)
        let widthConstraintForContainer     = NSLayoutConstraint(item: self.container.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsForContainer1      = NSLayoutConstraint(item: self.container.view, attribute: .bottom, relatedBy: .equal, toItem: self.buttonBottom, attribute: .top, multiplier: 1.0, constant: -102.0)
        let pinContraintsForContainer2      = NSLayoutConstraint(item: self.container.view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        //Constraints for background
        let widthContraintsForBackground = NSLayoutConstraint(item: self.background, attribute:.width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraintForBackground = NSLayoutConstraint(item: self.background, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalContraintsAlertView, verticalContraintsAlertView,heightConstraintForAlertView, widthConstraintForAlertView,
                                     verticalContraintsButtonBottom, heightConstraintForButtonBottom, widthConstraintForButtonBottom, pinContraintsButtonBottom,
                                     horizontalContraintForContainer, widthConstraintForContainer, pinContraintsForContainer1, pinContraintsForContainer2,
                                     widthContraintsForBackground, heightConstraintForBackground,
                                     verticalContraintsLegalText, heightConstraintForLegalText, widthConstraintForLegalText, pinContraintsButtonLegalText])
    }
    
    //MARK: FOR ANIMATIONS ---------------------------------
    fileprivate func animateForOpening(_ animate:Bool = false){
        if(!animate){
            return
        }
        
        self.alpha = 1.0
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    fileprivate func animateForEnding(_ animate:Bool = false){
        
        func destroy(_ completion: Bool = true) {
            DispatchQueue.main.async {
                () -> Void in
                self.background.removeFromSuperview()
                self.removeFromSuperview()
                self.container.removeFromParentViewController()
                self.container.view.removeFromSuperview()
            }
        }
        
        if( !animate ){
            destroy()
            return;
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
            self.alpha = 0.0
        }, completion: destroy)
    }
    
    //MARK: BUTTON ACTIONS ---------------------------------
    
    func onContinue(){
        // is user allowed to go to next page?
        
        self.delegate?.alertOnboardingAllowedToContinue { allowed in
            if !allowed { return }
            self.goToNextPage()
        }
    }
    
    public func onBack(){
        self.delegate?.alertOnboardingAllowedToGoBack { allowed in
            if !allowed { return }
            self.goToPrevPage()
        }
    }
    
    func goToNextPage(){
        // try to go to the next page
        // if there are no pages left,
        // close the onboarding view
        if !self.container.nextPage() {
            self.hide()
        }
    }
    
    func goToPrevPage(){
        // try to go to the prev page
        // if there are no pages left,
        // close the onboarding view
        if !self.container.prevPage() {
            self.hide()
        }
    }
    
    //MARK: ALERTPAGEVIEWDELEGATE    --------------------------------------
    
    func prevStep(_ step: Int) {
        self.delegate?.alertOnboardingPrev(step)
    }
    
    func nextStep(_ step: Int) {
        self.delegate?.alertOnboardingNext(step)
    }
    
    //MARK: OTHERS    --------------------------------------
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    //MARK: NOTIFICATIONS PROCESS ------------------------------------------
    fileprivate func interceptOrientationChange(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(AlertOnboarding.onOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func onOrientationChange(){
        if let superview = self.superview {
            self.configureConstraints(superview)
            self.container.configureConstraintsForPageControl()
        }
    }
}
