//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Vishay Nihalani on 3/6/16.
//  Copyright © 2016 Vishay Nihalani. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var topLevelContainerView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var rescheduleImageView: UIImageView!
    
    var initialCenterTopLevelContainer: CGPoint!
    var initialCenterMessagesView: CGPoint!
    var initialCenterLaterButton: CGPoint!
    var initialCenterListButton: CGPoint!
    var initialCenterArchiveButton: CGPoint!
    var initialCenterDeleteButton: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        feedScrollView.contentSize = CGSize(width: 320, height: 1202)
        
        initialCenterTopLevelContainer = topLevelContainerView.center
        initialCenterMessagesView = messageView.center
        initialCenterLaterButton = laterButton.center
        initialCenterListButton = listButton.center
        initialCenterArchiveButton = archiveButton.center
        initialCenterDeleteButton = deleteButton.center
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "didPanMenu:")
        edgeGesture.edges = UIRectEdge.Left
        topLevelContainerView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {

        }
        
        else if sender.state == UIGestureRecognizerState.Changed {
            messageView.center.x = initialCenterMessagesView.x + translation.x
            laterButton.center.x = self.messageView.frame.width + 25 + translation.x
            listButton.center.x = self.messageView.frame.width + 25 + translation.x
            archiveButton.center.x = self.messageView.frame.origin.x - 25
            deleteButton.center.x = self.messageView.frame.origin.x - 25

            // Changes for swipe lefts
            if ((messageView.frame.origin.x + messageView.frame.width < view.frame.width) &&
                (messageView.frame.origin.x + messageView.frame.width >= 0.65 * view.frame.width)) {
               
                containerView.backgroundColor = UIColor.lightGrayColor()
                laterButton.alpha = 1.0
                listButton.alpha = 0
            } else if ((messageView.frame.origin.x + messageView.frame.width < 0.65 * view.frame.width) &&
                (messageView.frame.origin.x + messageView.frame.width >= 0.35 * view.frame.width)) {
                
                containerView.backgroundColor = UIColor(red: 250.0/255, green: 210.0/255, blue: 51.0/255, alpha: 1.0)
                laterButton.alpha = 0
                listButton.alpha = 1.0
            } else if ((messageView.frame.origin.x + messageView.frame.width) < 0.35 * view.frame.width) {
                
                containerView.backgroundColor = UIColor(red: 216.0/255, green: 166.0/255, blue: 117.0/255, alpha: 1.0)
                laterButton.alpha = 0
                listButton.alpha = 1.0
            }
            
            // Changes for swipe rights
            else if ((messageView.frame.origin.x > 0) &&
                    (messageView.frame.origin.x <= 0.1 * view.frame.width)) {
                containerView.backgroundColor = UIColor.lightGrayColor()
                
            }
            else if ((messageView.frame.origin.x > 0.1 * view.frame.width) &&
                    (messageView.frame.origin.x <= view.frame.width / 2)) {
                containerView.backgroundColor = UIColor(red: 112.0/255, green: 217.0/255, blue: 98.0/255, alpha: 1.0)
                        
                // Archive for short swipes
                archiveButton.alpha = 1.0
                deleteButton.alpha = 0
            } else if (messageView.frame.origin.x > view.frame.width / 2) {
                // Change the color of the
                containerView.backgroundColor = UIColor(red: 235.0/255, green: 84.0/255, blue: 51.0/255, alpha: 1.0)
                
                // Archive changes to Delete if the swipe is long enough
                archiveButton.alpha = 0
                deleteButton.alpha = 1.0
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            // When the swipe was to the left...
            if (velocity.x < 0) {
                if (messageView.frame.origin.x + messageView.frame.width >= 0.55 * view.frame.width) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.center.x = self.view.frame.width / 2
                        self.laterButton.center = self.initialCenterLaterButton
                        self.archiveButton.center = self.initialCenterArchiveButton
                        self.deleteButton.center = self.initialCenterDeleteButton
                        self.rescheduleImageView.alpha = 0.0
                    })
                } else if (messageView.frame.origin.x + messageView.frame.width < 0.55 * view.frame.width) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.origin.x = -1 * self.view.frame.width
                        self.laterButton.center.x = self.laterButton.frame.width / 2 + 8
                        self.archiveButton.center = self.initialCenterArchiveButton
                        self.deleteButton.center = self.initialCenterDeleteButton
                        
                        self.laterButton.alpha = 0
                        self.rescheduleImageView.alpha = 1.0
                    })
                }
                
            // When the swipe was to the right...
            } else {
                if (messageView.frame.origin.x < view.frame.width * 0.45) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.center.x = self.view.frame.width / 2
                        self.archiveButton.center = self.initialCenterArchiveButton
                        self.deleteButton.center = self.initialCenterDeleteButton
                    })
                } else if (messageView.frame.origin.x >= view.frame.width * 0.45) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.origin.x = self.view.frame.width
                        self.archiveButton.center.x = self.view.frame.width - self.archiveButton.frame.width / 2 - 8
                        self.deleteButton.center.x = self.view.frame.width - self.deleteButton.frame.width / 2 - 8
                    })
                }
            }
        }
    }
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {


        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.rescheduleImageView.alpha = 0
            self.laterButton.alpha = 1.0
            self.messageView.center.x = self.view.frame.width / 2
            self.laterButton.frame.origin.x = self.view.frame.width - self.laterButton.frame.width - 8
            self.feedImageView.frame.origin.y -= self.messageView.frame.height
        })
    }
    
    @IBAction func didPanMenu(sender: UIPanGestureRecognizer) {

        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            
            initialCenterTopLevelContainer = topLevelContainerView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            topLevelContainerView.center.x = initialCenterTopLevelContainer.x +  translation.x
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if velocity.x > 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.topLevelContainerView.frame.origin.x = self.view.frame.width - 50
                })
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.topLevelContainerView.frame.origin.x = 0
                })
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
