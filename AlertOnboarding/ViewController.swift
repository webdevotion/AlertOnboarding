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
    
    var arrayOfImage = ["onboarding", "train", "onboarding"]
    var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET\nACROSS TWO LINES", "DEPARTURE"]
    var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends",
                              "Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies. Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies.",
                              "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        alertView.delegate = self
    }
    
    @IBAction func onTouch(_ sender: AnyObject) {
      // IF YOU WANT TO CUSTOMISE ALERTVIEW
      self.alertView.colorForAlertViewBackground = .darkGray
      self.alertView.colorButtonText = .white
      self.alertView.colorButtonBottomBackground = .blue

      self.alertView.colorTitleLabel = .white
      self.alertView.colorDescriptionLabel = .white

      self.alertView.colorPageIndicator = .white
      self.alertView.colorCurrentPageIndicator = .blue

      self.alertView.percentageRatioHeight = 1.0
      self.alertView.percentageRatioWidth = 1.0
      self.alertView.show()
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
        print("Next step triggered! \(nextStep)")
    }
    
}
