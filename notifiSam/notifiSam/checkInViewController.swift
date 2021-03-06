//
//  checkInViewController.swift
//  notifiSam
//
//  Created by Sam on 7/18/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation







class checkInViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var friendInfo: UIView!
    
    
    
    // These are all outlets for friendInfo View
    
    
    @IBOutlet weak var bigProfileImage: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var address1Label: UILabel!
    
    @IBOutlet weak var address2Label: UILabel!
    
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Label2: UILabel!
    
    @IBOutlet weak var Label3: UILabel!
    
    @IBOutlet weak var Label4: UILabel!
    
    
    @IBOutlet weak var smallImage1: UIImageView!
    
    @IBOutlet weak var smallImage2: UIImageView!
    
    @IBOutlet weak var smallImage3: UIImageView!
    
    @IBOutlet weak var smallImage4: UIImageView!
    
    var friendList : [User] = []
    
    let locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        tableView.registerNib(UINib(nibName: "customCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 80
        
        // this is to remove the empty space on the top of the table view. ns if it breaks anything lol
        self.automaticallyAdjustsScrollViewInsets = false
        
        friendList = UserController.sharedInstance.getJournals()
        
        mapView.addAnnotations(friendList)
        locationManager.requestWhenInUseAuthorization()
        mapView.showsCompass = true
        mapView.rotateEnabled = true
        
        // do we need an add button?
        navigationItem.title = "Notifi"
        let add_button : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: nil)
        navigationItem.rightBarButtonItem = add_button
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
        
        // this is a fake back button. It just unhides the tableview and hides the info view.
        let back_button : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItem = back_button
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        
        // hide the friendInfoView -- this is retarded 
        friendInfo.hidden = true
    
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendList.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
      
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath)
            as! customCellTableViewCell
        
        
        
        cell.nameLabel.text = friendList[indexPath.row].title
        
        
        // get actual colors from the palette
        switch friendList[indexPath.row].status {
            
        case .Danger:
            cell.imageview.layer.borderColor = UIColor.redColor().CGColor
        case .Weary:
            cell.imageview.layer.borderColor = UIColor.yellowColor().CGColor
        default:
            cell.imageview.layer.borderColor = UIColor.greenColor().CGColor
  
            
        }
        
        
        // tapAction closure sent to IBAction
        cell.tapAction = { (cell) in
            
            let message = self.friendList[indexPath.row].title! + " will be notified that you requested an update from them."
            
            let alert = UIAlertController(title: "Request Sent!", message: message,
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertAction = UIAlertAction(title: "Okay", style: .Cancel, handler: { (action) in
                
                
                
            })
            
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)

        }

        
        return cell
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        
        
        if (annotation.isKindOfClass(MKUserLocation)) {
            return nil
        }
        
        
        
        let identifier = "MyPin"
        
        
        
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("MyPin") as? SVPulsingAnnotationView
        
        
        
        
        
        
        if (annotationView == nil) {
            
          
            
             annotationView = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            
            
            annotationView!.canShowCallout = true
            
            
            
            var frame = annotationView!.frame
            frame.size.height = 25
            frame.size.width = 25
            annotationView!.frame = frame
            
            
            
            // change to real colors later
            
            let annotationUser : User = annotation as! User
            
            if annotationUser.status == .Danger {
                annotationView?.annotationColor = UIColor.redColor()
            }
            else if annotationUser.status == .Weary {
                annotationView?.annotationColor = UIColor.yellowColor()
            }
            else {
                annotationView?.annotationColor = UIColor.greenColor()
            }
            
            
        
           
            
            
        }
        
        
        annotationView!.annotation = annotation
        return annotationView!
        

        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      //  tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.darkGrayColor()
        
        let location = friendList[indexPath.row].coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        // there's prob a better solution then this
        for annotation in self.mapView.annotations {
            
            if annotation.title! == friendList[indexPath.row].title {
                mapView.selectAnnotation(annotation, animated: true)
            }
            
            
        }
        
        
        tableView.hidden = true
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
        
        
        // friendInfo stuff
        nameLabel.text = friendList[indexPath.row].title!
        address1Label.text = friendList[indexPath.row].address1
        address2Label.text = friendList[indexPath.row].address2
        
        bigProfileImage.layer.borderWidth = 2.0;
        bigProfileImage.frame.size.width = 100
        
        
        if friendList[indexPath.row].status == .Danger {
            bigProfileImage.layer.borderColor = UIColor.redColor().CGColor
        }
        else if friendList[indexPath.row].status == .Weary {
            bigProfileImage.layer.borderColor = UIColor.yellowColor().CGColor
        }
        else {
            bigProfileImage.layer.borderColor = UIColor.greenColor().CGColor
        }
        
    
    
        self.bigProfileImage.layer.cornerRadius = self.bigProfileImage.frame.size.width / 2
        self.bigProfileImage.clipsToBounds = true
        
        
        
        self.smallImage1.layer.cornerRadius = self.smallImage1.frame.size.width/2
        self.smallImage1.clipsToBounds = true
        
        
        
        self.smallImage2.layer.cornerRadius = self.smallImage2.frame.size.width/2
        self.smallImage2.clipsToBounds = true
        
        self.smallImage3.layer.cornerRadius = self.smallImage3.frame.size.width/2
        self.smallImage3.clipsToBounds = true
        
        self.smallImage4.layer.cornerRadius = self.smallImage4.frame.size.width/2
        self.smallImage4.clipsToBounds = true
        
        
        // this is all hard coded stuff
        
        
        self.smallImage1.backgroundColor = UIColor.greenColor()
        self.smallImage2.backgroundColor = UIColor.redColor()
        self.smallImage3.backgroundColor = UIColor.yellowColor()
        self.smallImage4.backgroundColor = UIColor.greenColor()
        
        
        
        friendInfo.hidden = false
        
        
        
        
        
        
    }
        
        
        func addAction(sender:UIBarButtonItem){
            
            print("This do something?")
            
            
            
        }
    
    func backAction(sender: UIBarButtonItem) {
        
        self.tableView.hidden = false
        self.friendInfo.hidden = true
        
        // hides the back button to imitate an actual back button
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        
    }
    
    
    // seriously though, what does this button do?
    @IBAction func editButtonPressed(sender: UIButton) {
        print("Edit button pressed")
    }
    
    

    @IBAction func informationButtonPressed(sender: UIButton) {
        print("Information button pressed")
    }
    
    
    @IBAction func findMeButtonPressed(sender: UIButton) {
        let userLocation = mapView.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func twoDButtonPressed(sender: UIButton) {
    mapView.camera.pitch = 0.0
    mapView.camera.altitude = 1000.0
    mapView.camera.heading = 0.0
    }
    
    
    
    
    // These are all actions for the friendInfo View
    
    
    @IBAction func callButtonPressed(sender: UIButton) {
        print("call button pressed")
    }
    
    
    @IBAction func textButtonPressed(sender: UIButton) {
        print("text button pressed")
    }
    
    
    @IBAction func bigRequestButtonPressed(sender: UIButton) {
        
        
        let message = nameLabel.text! + " will be notified that you requested an update from them"
        let alert = UIAlertController(title: "Request Sent!", message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Okay", style: .Cancel, handler: { (action) in
            
            
            
        })
        
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)


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
