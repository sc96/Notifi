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
import MessageUI



// to get the index of the selected row




class checkInViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var friendInfo: UIView!
    
    @IBOutlet weak var StatusTableView: UITableView!
    
    
    // These are all outlets for friendInfo View
    
    
    @IBOutlet weak var bigProfileImage: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    

    var rowindex : Int = 0
    var friendList :[SignifyUser] = []
    
    
    let locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebDatabase.sharedInstance.retriveContact(onCOmpletion: {users in
            self.friendList = users
            self.tableView.reloadData()
            
            
            
            // hardcoding location and status for a varied map
            
            if self.friendList.count >= 1 {
                self.friendList[0].coordinate = CLLocationCoordinate2D(latitude: -34.024, longitude: 18.489)
                //self.friendList[0].currstatus = .Attention
                
            }
            
            if self.friendList.count >= 2 {
                self.friendList[1].coordinate = CLLocationCoordinate2D(latitude: -34.045, longitude: 18.503)
                self.friendList[1].currstatus = .Help
              
            }
            
            if self.friendList.count >= 3 {
                self.friendList[2].coordinate = CLLocationCoordinate2D(latitude: -34.040, longitude: 18.503)
                
                
            }
            
            
            if self.friendList.count >= 4 {
                self.friendList[3].coordinate = CLLocationCoordinate2D(latitude: -34.033, longitude: 18.489)
                self.friendList[3].currstatus = .Attention
                print(self.friendList[3].title)
                print(self.friendList[3].currstatus.rawValue)
            }
            
            if self.friendList.count >= 5 {
                print(self.friendList[4].title)
                print(self.friendList[4].currstatus.rawValue)
                self.friendList[4].homeAddress = "107 Main Road"
                self.friendList[4].cellPhone = "2034450456"
                let s1 = Status(state: .Safe, time: "5 minutes ago", user: "asd")
                let s2 = Status(state: .Safe, time: "14 minutes ago", user: " ad")
                self.friendList[4].statusHistory = [s1, s2]
                
            }
            
            self.mapView.addAnnotations(self.friendList)

        })
        
        
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
          StatusTableView.delegate = self
        StatusTableView.dataSource = self

        
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()

        
        
        tableView.registerNib(UINib(nibName: "customCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 65
        
        
        StatusTableView.registerNib(UINib(nibName: "StatusTableViewCell", bundle: nil), forCellReuseIdentifier: "statusCell")
        StatusTableView.rowHeight = 36
        
        
        
    
        // this is to remove the empty space on the top of the table view. ns if it breaks anything lol
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        print(friendList.count)
        
        
        
        
        locationManager.requestWhenInUseAuthorization()
        
        
        // getting the compass to show
        mapView.showsCompass = true
        mapView.rotateEnabled = true
        
        // center the initial mapView to your location
        
        /*
        let userLocation = mapView.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
 */
            
        
        
        // do we need an add button?
        navigationItem.title = "Signifi"
        let add_button : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: nil)
        navigationItem.rightBarButtonItem = add_button
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
        
  
        // this is a fake back button. It just unhides the tableview and hides the info view.
        let back_button : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back_transparent"), style:. Done, target: self, action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItem = back_button
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        
        // hide the friendInfoView -- this is retarded 
        friendInfo.hidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imagePressed))
        bigProfileImage.addGestureRecognizer(tap)
        bigProfileImage.userInteractionEnabled = true
       
        
    }
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    func imagePressed() -> Void {
        
        let friendProfileViewController = FriendProfileViewController(nibName: "FriendProfileViewController", bundle: nil)
        friendProfileViewController.tempImageString = friendList[rowindex].profilePhotoString
        friendProfileViewController.tempName = friendList[rowindex].title
        friendProfileViewController.tempAddress1 = friendList[rowindex].homeAddress
        friendProfileViewController.tempPhone = friendList[rowindex].cellPhone
        
        if (friendList[rowindex].emergencyContactUser != nil) {
            
            friendProfileViewController.tempEmergency = friendList[rowindex].emergencyContactUser!.cellPhone
            
        }
        friendProfileViewController.state = friendList[rowindex].currstatus
        self.navigationController?.pushViewController(friendProfileViewController, animated: true)
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (tableView == self.tableView)   {
            return friendList.count
        }   else    {
            //statusTableViwe
            if friendList.count == 0 {
                return 0
            }   else    {
                return friendList[rowindex].statusHistory.count
            }
            
        }
            
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (tableView == self.tableView)  {
            //
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath)
                as! customCellTableViewCell
            
            
            
            cell.nameLabel.text = friendList[indexPath.row].title
            
            if friendList[indexPath.row].profilePhotoString != nil {
                let url = friendList[indexPath.row].profilePhotoString
                let picurl = NSURL(string: url!)
                cell.imageview.load(picurl!)
            }
            else {
                cell.imageview.image = nil
            }
            
            
            // get actual colors from the palette
            switch friendList[indexPath.row].currstatus {
                
            case .Help:
                cell.imageview.layer.borderColor = UIColor.noticeRed().CGColor
            case .Attention:
                cell.imageview.layer.borderColor = UIColor.noticeYellow().CGColor
            default:
                cell.imageview.layer.borderColor = UIColor.noticeGreen().CGColor
                
                
            }
            
            
            // tapAction closure sent to IBAction
            cell.tapAction = { (cell) in
                
                let message = self.friendList[indexPath.row].title! + " will be notified that you requested an update."
                
                let alert = UIAlertController(title: "Request Sent!", message: message,
                                              preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Okay", style: .Cancel, handler: { (action) in
                    
                    
                    
                })
                
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            
            return cell
        }   else    {
            //statusTableView
            
            let cell = tableView.dequeueReusableCellWithIdentifier("statusCell", forIndexPath: indexPath)
                as! StatusTableViewCell
            cell.statusTimeLabel.text = friendList[rowindex].statusHistory[indexPath.row].time
            
            
            if friendList[rowindex].statusHistory[indexPath.row].state == .Safe  {
                cell.statusTypeImage.backgroundColor = UIColor.greenColor()
            }
            else if friendList[rowindex].statusHistory[indexPath.row].state == .Attention {
                cell.statusTypeImage.backgroundColor = UIColor.yellowColor()
            }
            else {
                cell.statusTypeImage.backgroundColor = UIColor.redColor()
            }
            
            return cell
        }
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.tableView {
        
        let location = friendList[indexPath.row].coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
            
           
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        // there's prob a better solution then this
        for annotation in self.mapView.annotations {
            
            if annotation.title! == friendList[indexPath.row].title {
                mapView.selectAnnotation(annotation, animated: true)
            }
            
            
        }
        
        rowindex = indexPath.row
        StatusTableView.reloadData()
        tableView.hidden = true
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.leftBarButtonItem?.tintColor = UIColor.noticeGrey()
        
        
        navigationItem.title = friendList[indexPath.row].title!
        
        // friendInfo stuff
        nameLabel.text = friendList[indexPath.row].title!
        rowindex = indexPath.row
        
        bigProfileImage.layer.borderWidth = 2.0;
        bigProfileImage.frame.size.width = 100
        
        if friendList[indexPath.row].profilePhotoString != nil {
            let url = friendList[indexPath.row].profilePhotoString
            let picurl = NSURL(string: url!)
            bigProfileImage.load(picurl!)
            
        }
        else {
            bigProfileImage.image = nil
        }
        
      
        
        if friendList[indexPath.row].currstatus == .Help {
            bigProfileImage.layer.borderColor = UIColor.redColor().CGColor
        }
        else if friendList[indexPath.row].currstatus == .Attention {
            bigProfileImage.layer.borderColor = UIColor.yellowColor().CGColor
        }
        else {
            bigProfileImage.layer.borderColor = UIColor.greenColor().CGColor
        }

        
        
        
        self.bigProfileImage.layer.cornerRadius = self.bigProfileImage.frame.size.width / 2
        self.bigProfileImage.clipsToBounds = true
        
        
        
        friendInfo.hidden = false
        }
        
        else {
            
        }
        
    }


    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
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
            
            
            
            
        }
        
        let annotationUser = annotation as! SignifyUser
        
        
        if annotationUser.currstatus == .Help {
            annotationView?.annotationColor = UIColor.redColor()
        }
        else if annotationUser.currstatus == .Attention {
            annotationView?.annotationColor = UIColor.yellowColor()
        }
        else {
            annotationView?.annotationColor = UIColor.greenColor()
        }

        
        annotationView!.annotation = annotation
        return annotationView!
        
    }
    
    
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
        
    func addAction(sender:UIBarButtonItem) {
            
        print("This do something?")
        
        }
    
    func backAction(sender: UIBarButtonItem) {
        
        self.tableView.hidden = false
        self.friendInfo.hidden = true
        navigationItem.title = "Signifi"
        // hides the back button to imitate an actual back button
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        
    }
    
    
    
    
    // These are all actions for the friendInfo View
    
    
    @IBAction func callButtonPressed(sender: UIButton) {
        print("call button pressed")
        
        
        
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(friendList[rowindex].cellPhone)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
      
        
    }
    
    
    @IBAction func textButtonPressed(sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            
          
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [friendList[rowindex].cellPhone]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
            
        
        }
    }


    
    @IBAction func bigRequestButtonPressed(sender: UIButton) {
        
        
        let message = friendList[rowindex].title! + " will be notified that you requested an update."
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
