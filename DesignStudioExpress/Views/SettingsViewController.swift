//
//  SettingsViewController.swift
//  DesignStudioExpress
//
//  Created by Tim Broder on 12/10/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import MGSwipeTableCell


class SettingsViewController: UIViewControllerBase, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let vm = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return vm.getTotalRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = self.createCell("photoCell", indexPath: indexPath, MGSwipeTableCellCentered.self)
            self.stylePhotoCell(cell, indexPath: indexPath)
            return cell
        }
        
        let cell = self.createCell("setttingCell", indexPath: indexPath, UITableViewCellSettings.self)
        
        return cell
    }
    
    // customize row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // default row height for DS cells
        var rowHeight = 60
        
        // row height for photo
        // dynamically adjust based on the device height
        // should refactor to use autoconstraints
        if indexPath.row == 0 {
            let screenSize = UIScreen.mainScreen().bounds.height
            if screenSize <= 480  { // 4s
                rowHeight = 245
            } else if screenSize <= 568 { // 5
                rowHeight = 245
            } else if screenSize <= 667 { // 6
                rowHeight = 330
            } else { // 6++
                rowHeight = 320
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    @objc func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let action = vm.getAction(indexPath) {
            action(self)
        }
    }
    
    // MARK: - Custom
    
    // creates table view cell of a specified type
    private func createCell<T: UITableViewCell>(reuseIdentifier: String, indexPath: NSIndexPath, _: T.Type) -> T {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! T!
        if cell == nil {
            cell = T(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        if let settingsCell = cell as? UITableViewCellSettings {
            settingsCell.title?.text = vm.getTitle(indexPath)
        } else {
            cell.textLabel?.text = vm.getTitle(indexPath)
        }
        
        if let description = vm.getDescription(indexPath) {
            cell.detailTextLabel?.text = description
        }
        
        // set separator from edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        // image for the first cell is a background image not an icon
        // skip setting the icon for first row
        if indexPath.row == 0 {
            return cell
        }
        
        guard let imagePath = vm.getImageName(indexPath) else {
            return cell
        }
        
        // we have to add an image to the attachment
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imagePath)
        // adjust the position of the icon
        
        // TODO fix text alignment (currently center)
        //attachment.bounds = CGRectMake(-4, -1, attachment.image!.size.width, attachment.image!.size.height);
        
        // create a attributed string with attachment
        let attributedString = NSAttributedString(attachment: attachment)
        // create mutable string from that so we can add more attributes
        let iconString = NSMutableAttributedString(attributedString: attributedString)
        // add the text to the iconString so that the text is on the right side of the icon
        let initialText = NSMutableAttributedString(string: vm.getTitle(indexPath))
        iconString.appendAttributedString(initialText)
        
        cell.textLabel!.attributedText = iconString
        cell.textLabel?.textColor = UIColor(red:0.53, green:0.65, blue:0.82, alpha:1.0)
        
        return cell
    }
    
    private func customizeStyle() {
        // this in comb. with UIEdgeInsetsZero on layoutMargins for a cell
        // will make the cell separator show from edge to edge
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
    }
    
    func stylePhotoCell(cell: MGSwipeTableCellCentered, indexPath: NSIndexPath) {
        // set the background image
        if let imagePath = vm.getImageName(indexPath) {
            let image = UIImage(named: imagePath)
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleAspectFill
            cell.backgroundView = imageView
        }
        // style title
        // TODO change to constant from DesignStudioStyle
        cell.textLabel?.textColor = UIColor(red:0.53, green:0.65, blue:0.82, alpha:1.0)
        cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 14)
        cell.textLabel?.attributedText = NSAttributedString.attributedStringWithSpacing(cell.textLabel!.attributedText!, kerning: 2.5)
        
        // style detail
        cell.detailTextLabel?.textColor = DesignStudioStyles.white
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light", size: 22)
        cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.sizeToFit()
        
        // disable user interactions so we don't have highlighted state
        cell.userInteractionEnabled = false
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
