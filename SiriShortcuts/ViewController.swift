//
//  ViewController.swift
//  SiriShortcuts
//
//  Created by Nicholas Laughter on 2/20/19.
//  Copyright © 2019 Gaire Tech, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(sayHello), name: .SiriShortcutReceived, object: nil)
    }

    @IBAction func sayHiButtonTapped(_ sender: Any) {
        self.sayHello()
    }

    @objc func sayHello() {
        guard SiriShortcutManager.shared.intent == "awesome-thing" || SiriShortcutManager.shared.intent == nil,
        let awesomeThingViewController = UIStoryboard(name: "AwesomeThing", bundle: nil).instantiateInitialViewController() else { return }
        SiriShortcutManager.shared.intent = nil
        self.present(awesomeThingViewController, animated: true, completion: nil)
    }
}
