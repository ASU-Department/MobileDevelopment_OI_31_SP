//
//  ViewController.swift
//  Lecture4Demo_UIKit
//
//  Created by Dmytro Ostrovka on 20.10.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonAction(_ sender: Any) {
        self.navigationController?.pushViewController(SomeNewViewController(),
                                                      animated: true)
    }
}
