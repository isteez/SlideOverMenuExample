//
//  SidePanelViewController.swift
//  SlideOverMenuExample
//
//  Created by Stephen Kyles on 12/5/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func animalSelected()
}

class SidePanelViewController: UIViewController {
    var delegate: SidePanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func tap() {
        delegate?.animalSelected()
    }
}