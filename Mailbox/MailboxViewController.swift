//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Hearsay Guest on 10/23/14.
//  Copyright (c) 2014 John Barkis. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    // Associate the assets as variables
    @IBOutlet weak var navView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helpView: UIImageView!
    @IBOutlet weak var searchView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageContainerView: UIImageView!
    @IBOutlet weak var laterView: UIImageView!
    @IBOutlet weak var archiveView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var menuContainerView: UIImageView!
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var messageViewCenter: CGPoint!
    var laterViewCenter: CGPoint!
    var menuContainerViewCenter: CGPoint!
    var yellowX: CGFloat!
    var brownX: CGFloat!
    var greenX: CGFloat!
    var redX: CGFloat!
    var edges: UIRectEdge!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1367)
        self.yellowX = 120
        self.brownX = -80
        self.greenX = 240
        self.redX = 440
        
        var screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onLeftMenuPan:")
        screenEdgePanGestureRecognizer.edges = UIRectEdge.Left
        self.menuContainerView.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        // Begin Pan Gesture
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.laterView.alpha = 0
            self.laterView.center.x = 315
            self.listIconView.alpha = 0
            self.listIconView.center.x = 315
            self.archiveView.alpha = 0
            self.archiveView.center.x = 45
            self.deleteIconView.alpha = 0
            self.deleteIconView.center.x = 45
            self.messageViewCenter = self.messageView.center
            self.messageContainerView.backgroundColor = UIColor.lightGrayColor()
        
            println("messageView.center.x: \(self.messageView.center.x)")
            
        // Change Pan Gesture
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            var laterViewAlpha = abs(100 / self.messageView.center.x)
            self.messageView.center.x = self.messageViewCenter.x + translation.x
    
            
            
                // Sets background to yellow and displays the laterView icon
                if self.messageView.center.x < self.yellowX && self.messageView.center.x > self.brownX {
                    self.listIconView.alpha = 0
                    self.laterView.center.x = self.messageView.center.x + 195
                    
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.laterView.alpha = 1
                        self.messageContainerView.backgroundColor = UIColor.yellowColor()
                    })
                
                // Sets background to brown and changes the icon to listIconView
                } else if self.messageView.center.x <= self.brownX {
                    self.laterView.alpha = 0
                    self.listIconView.center.x = self.messageView.center.x + 195
                    self.listIconView.alpha = 1
                    self.messageContainerView.backgroundColor = UIColor.brownColor()

                // Sets background to green and displays the archiveView icon
                } else if self.messageView.center.x > self.greenX && self.messageView.center.x < self.redX {
                        self.deleteIconView.alpha = 0
                        self.archiveView.center.x = self.messageView.center.x - 195
                    
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.archiveView.alpha = 1
                        self.messageContainerView.backgroundColor = UIColor.greenColor()
                    })

                // Sets background to red and changes the icon to the deleteIconView icon
                } else if self.messageView.center.x >= self.redX {
                    self.archiveView.alpha = 0
                    self.deleteIconView.center.x = self.messageView.center.x - 195
                    self.deleteIconView.alpha = 1
                    self.messageContainerView.backgroundColor = UIColor.redColor()

                // Resets background to gray and hides icons
                } else {
                    self.messageContainerView.backgroundColor = UIColor.lightGrayColor()
                    
                    // Fades the laterView and archiveView icons depending on the direction of the velocity
                    if velocity.x < 0 {
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.laterView.alpha = 1
                            self.archiveView.alpha = 0
                        })
                    } else {
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.laterView.alpha = 0
                            self.archiveView.alpha = 1
                        })
                    }
                }
            
        // End Pan Gesture
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            // Checks if the message is moving to the left
            if velocity.x < 0 {
                
                // Moves the message all the way to the left and displays the reschedule screen if in the yellow background view
                if self.messageView.center.x <= self.yellowX && self.messageView.center.x > self.brownX {
                    UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
                        self.messageView.center.x = -200
                        self.rescheduleView.alpha = 1
                        }, completion: nil)
                    
                // Moves the message all the way to the left and displays the list screen if in the brown background view
                } else if self.messageView.center.x <= self.brownX {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.messageView.center.x = -200
                        self.listView.alpha = 1
                    })
                    
                // Re-centers the message if it is still in the gray background view
                } else {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.center.x = 180
                    })
                }

            // If the message is moving to the right
            } else {
                var laterViewAlpha = abs(self.messageView.center.x / 70)
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageView.center.x = 180
                    self.laterView.center.x = self.messageView.center.x + 195
                    self.laterView.alpha = 0
                    self.archiveView.center.x = self.messageView.center.x - 195
                    self.archiveView.alpha = 0
                    self.messageContainerView.backgroundColor = UIColor.lightGrayColor()
                })
            }
        }
    }

    // Re-hides the rescheduleView and moves the messages up
    @IBAction func onRescheduleTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            self.scrollView.contentSize = CGSize(width: 320, height: 1281)
            self.feedView.center.y = self.feedView.center.y - 86
        })
        
    }
    
    // Re-hides the listView and moves the messages up
    @IBAction func onListTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.listView.alpha = 0
            self.scrollView.contentSize = CGSize(width: 320, height: 1281)
            self.feedView.center.y = self.feedView.center.y - 86
        })
    }
    
    @IBAction func toggleSegments(sender: UISegmentedControl) {

    }

    
    @IBAction func onLeftMenuPan(screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var menuPoint = screenEdgePanGestureRecognizer.locationInView(view)
        var menuVelocity = screenEdgePanGestureRecognizer.velocityInView(view)
        var menuTranslation = screenEdgePanGestureRecognizer.translationInView(view)
        println("screenedge")
        
        if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.menuContainerViewCenter.x = self.menuContainerView.center.x
            println("left begin")
            
        } else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Changed {
            self.menuContainerView.center.x = self.menuContainerViewCenter.x + menuTranslation.x
            println("left show")
            
        } else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            
        }
        
    }
    
    
    
}
