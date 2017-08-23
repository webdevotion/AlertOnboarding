//
//  ViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AlertOnboardingDelegate {
    
    var alertView: AlertOnboarding!
    
    var arrayOfImage = ["tram", "graph", "train","graph"]
    var arrayOfTitle = ["Oh how rude,\nWe totaly forgot to\nintroduce our selves.", "CHOOSE THE PLANET ACROSS TWO LINES OR EVEN MORE.  IF POSSIBLE.", "DEPARTURE","SWIFTY"]
    var arrayOfDescription = ["In your profile",
                              "Purchase tickets on hot tours to your favorite planet!",
                              "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life!","This is very Swifty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, arrayOfContainers: [self.contentExample(0), self.contentExample(1), self.contentExample(1),self.contentExample(0)])
        alertView.delegate = self   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onTouch(self)
    }
    
    func contentExample(_ index:Int) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)

        switch index {
        case 1:
            return sb.instantiateViewController(withIdentifier: "exampleContent2")
        default:
            return sb.instantiateViewController(withIdentifier: "exampleContent")
        }
    }
    
    @IBAction func onTouch(_ sender: AnyObject) {
        // IF YOU WANT TO CUSTOMISE ALERTVIEW
        self.alertView.colorForAlertViewBackground = UIColor(hue:0.55, saturation:0.62, brightness:0.97, alpha:1.00)
        self.alertView.colorButtonText = .white
        self.alertView.colorButtonBottomBackground = UIColor(hue:0.59, saturation:0.89, brightness:0.98, alpha:1.00)

        self.alertView.colorTitleLabel = .white
        self.alertView.colorDescriptionLabel = .white

        self.alertView.colorPageIndicator = .white
        self.alertView.colorCurrentPageIndicator = .lightGray

        self.alertView.percentageRatioHeight = 1.0
        self.alertView.percentageRatioWidth = 1.0
        
        
        
        let attributedString = NSMutableAttributedString(string: "By creating an account, you accept our terms of use & privacy policy")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 10.0), range: NSRange())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 39, length: 12))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 54, length: 14))
//        attributedString.append(attributedString)
        self.alertView.legalText = attributedString
        self.alertView.show(animated:false)
    }
    
    //--------------------------------------------------------
    // MARK: DELEGATE METHODS --------------------------------
    //--------------------------------------------------------
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
    }
    
    func alertOnboardingCompleted() {
        print("Onboarding completed!")
    }
    
    func alertOnboardingNext(_ nextStep: Int) {
        
    }
    
    func alertOnboardingAllowedToContinue(_ completion: ((Bool) -> Void)?) {
        completion?(true) // test condition and return true or false
    }
    
}
