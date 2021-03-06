//
//  AddToSiriViewController.swift
//  SiriShortcuts
//
//  Created by Nic Laughter on 2/21/19.
//  Copyright © 2019 Gaire Tech, LLC. All rights reserved.
//

import UIKit
import IntentsUI
import CoreSpotlight
import MobileCoreServices

class AddToSiriViewController: UIViewController {
    
    let awesomeThingUserActivity = NSUserActivity(activityType: "tech.gaire.SiriShortcuts.awesome-thing")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "greetingCount") + 1, forKey: "greetingCount")
        
        let addToSiriButton = INUIAddVoiceShortcutButton(style: .blackOutline)
        addToSiriButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addToSiriButton)
        self.view.centerXAnchor.constraint(equalTo: addToSiriButton.centerXAnchor).isActive = true
        self.view.centerYAnchor.constraint(equalTo: addToSiriButton.centerYAnchor).isActive = true
        
        addToSiriButton.addTarget(self, action: #selector(self.addToSiri(_:)), for: .touchUpInside)
        
        let notNowButton = UIButton(frame: addToSiriButton.frame)
        notNowButton.setTitle("Not now", for: .normal)
        notNowButton.setTitleColor(.black, for: .normal)
        notNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(notNowButton)
        self.view.centerXAnchor.constraint(equalTo: notNowButton.centerXAnchor).isActive = true
        let notNowTopConstraint = NSLayoutConstraint(item: notNowButton, attribute: .top, relatedBy: .equal, toItem: addToSiriButton, attribute: .bottom, multiplier: 1, constant: 16)
        self.view.addConstraint(notNowTopConstraint)
        
        notNowButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NSUserActivity.deleteAllSavedUserActivities {
            print("deleted all")
            self.awesomeThingUserActivity.isEligibleForSearch = true
            self.awesomeThingUserActivity.isEligibleForPrediction = true
            
            self.awesomeThingUserActivity.title = "Do Awesome Thing"
            self.awesomeThingUserActivity.suggestedInvocationPhrase = "Get awesome"
            let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            attributes.contentDescription = "Siri can do the awesome thing for you!"
            attributes.thumbnailData = UIImage(named: "awesome-thing")?.pngData()
            
            self.awesomeThingUserActivity.contentAttributeSet = attributes
            
            self.userActivity = self.awesomeThingUserActivity
        }
    }

    // Present the Add Shortcut view controller after the
    // user taps the "Add to Siri" button.
    @objc func addToSiri(_ sender: Any) {
        let shortcut = INShortcut(userActivity: self.awesomeThingUserActivity)
        INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
        
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.modalPresentationStyle = .formSheet
        viewController.delegate = self // self conforming to INUIAddVoiceShortcutViewControllerDelegate.
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddToSiriViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        UserDefaults.standard.set(true, forKey: "hasSetSiriShortcut")
        controller.dismiss(animated: true, completion: nil)
        self.dismissView()
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.dismissView()
    }
}
