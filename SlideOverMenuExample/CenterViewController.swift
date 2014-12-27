//
//  CenterViewController.swift
//  SlideOverMenuExample
//
//  Created by Stephen Kyles on 12/5/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    var delegate: CenterViewControllerDelegate?
    var centerPanelExpandedOffset: CGFloat!
    var menuOptions: NSMutableArray = ["Cycles", "Notes", "Progress", "Quick % Calculate", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        view.insertSubview(blurView, atIndex: 0)
        
        var table = UITableView(
            frame: CGRectMake(
                centerPanelExpandedOffset,
                view.frame.height/4,
                view.frame.width - centerPanelExpandedOffset,
                view.frame.height
            ),
            style: UITableViewStyle.Grouped
        )
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clearColor()
        table.separatorColor = .clearColor()
        view.addSubview(table)
    }

    // MARK: Button actions
    
    @IBAction func puppiesTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    func animalSelected() {
        delegate?.collapseSidePanels?()
    }
    
    // MARK: Table view delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "UITableViewCell")
        }
        
        var name = menuOptions.objectAtIndex(indexPath.row) as? String
        
        cell?.textLabel?.text = name
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell?.imageView?.image = UIImage(named: name!)
        cell?.backgroundColor = .clearColor()
        
        return cell!
    }
}