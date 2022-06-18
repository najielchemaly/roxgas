//
//  POSViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit
import GoogleMaps

class POSViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var buttonList: UIButton!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var textFieldArea: UITextField!    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTopMap: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var refreshControl: UIRefreshControl!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.initializeViews()
        self.setupTableView()
        self.getPos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "POINTS OF SALE"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonMapTapped(_ sender: Any) {
        self.buttonMap.setBackgroundImage(#imageLiteral(resourceName: "next"), for: .normal)
        self.buttonMap.setTitleColor(.white, for: .normal)
        self.buttonList.setBackgroundImage(#imageLiteral(resourceName: "unselectedicon"), for: .normal)
        self.buttonList.setTitleColor(.black, for: .normal)
        
        self.mapView.isHidden = false
        self.viewTopMap.isHidden = false
    }
    
    @IBAction func buttonListTapped(_ sender: Any) {
        self.buttonList.setBackgroundImage(#imageLiteral(resourceName: "next"), for: .normal)
        self.buttonList.setTitleColor(.white, for: .normal)
        self.buttonMap.setBackgroundImage(#imageLiteral(resourceName: "unselectedicon"), for: .normal)
        self.buttonMap.setTitleColor(.black, for: .normal)
        
        self.mapView.isHidden = true
        self.viewTopMap.isHidden = true
    }
    
    func getPos() {
        self.showWaitOverlay(color: Colors.appGreen)
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getPOS()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    DatabaseObjects.pointsOfSale = [Pos]()
                    if let jsonArray = response?.jsonArray {
                        for json in jsonArray {
                            let pos = Pos.init(dictionary: json)
                            DatabaseObjects.pointsOfSale.append(pos!)
                        }
                        
                        self.loadMapView()
                        self.tableView.reloadData()
                    }
                }
                
                self.removeAllOverlays()
            }
        }
    }
    
    func loadMapView() {
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.mapType = .normal
        self.mapView.isMyLocationEnabled = true
        
        var index = 0
        for pos in DatabaseObjects.pointsOfSale {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            if let location = pos.location {
                let coordinates = location.characters.split{$0 == ","}.map(String.init)
                if let latitude = coordinates.first, let longitude = coordinates.last {
                    let latitude = Double(latitude)
                    let longitude = Double(longitude)
                    marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                }
            }
            
            if pos.items_quantity == nil || pos.items_quantity == 0 {
                marker.icon = #imageLiteral(resourceName: "notavailable")
            } else {
                marker.icon = #imageLiteral(resourceName: "available")
            }
            
            marker.title = String(describing: index)
            marker.map = self.mapView
            
            index += 1
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = Bundle.main.loadNibNamed("MarkerView", owner: self.view, options: nil)
        if let markerView = view?.first as? MarkerView {
            markerView.frame.size.width = self.view.frame.size.width/1.2
            markerView.layer.borderColor = Colors.appGreen.cgColor
            markerView.layer.borderWidth = 2.0
            markerView.layer.cornerRadius = 5.0
            
            if let title = marker.title {
                guard let row = Int(title) else {
                    return UIView()
                }
                
                let pos = DatabaseObjects.pointsOfSale[row]
                markerView.labelTitle.text = pos.title
                markerView.labelAddress.text = pos.address
                markerView.labelPhone.text = pos.phoneNumber
            }
            
            return markerView
        }

        return UIView()
    }
    
    func initializeViews() {
        self.viewArea.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "POSTableViewCell", bundle: nil), forCellReuseIdentifier: "POSTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseObjects.pointsOfSale.filter { $0.id != nil }.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let pos = DatabaseObjects.pointsOfSale[indexPath.row]
        if pos.isExpanded != nil && pos.isExpanded! {
            return 130
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "POSTableViewCell") as? POSTableViewCell {
            let pos = DatabaseObjects.pointsOfSale[indexPath.row]
            cell.labelAddress.text = pos.address
            
            if pos.isExpanded != nil && pos.isExpanded! {
                cell.viewExpandable.alpha = 1
            } else {
                cell.viewExpandable.alpha = 0
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(tap)
            
            cell.buttonGetLocation.tag = indexPath.row
            cell.buttonGetLocation.addTarget(self, action: #selector(buttonGetLocationTapped(sender:)), for: .touchUpInside)
            
            cell.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            let row = view.tag
            let indexPath = IndexPath.init(row: row, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? POSTableViewCell {
                let pos = DatabaseObjects.pointsOfSale[row]
                if pos.isExpanded != nil && pos.isExpanded! {
                    cell.labelExpand.text = "-"
                    pos.isExpanded = false
                } else {
                    cell.labelExpand.text = "+"
                    pos.isExpanded = true
                }
                
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    @objc func buttonGetLocationTapped(sender: UIButton) {
        let row = sender.tag
        let pos = DatabaseObjects.pointsOfSale[row]
        if let location = pos.location {
            let coordinates = location.characters.split{$0 == ","}.map(String.init)
            let latitude = Double(coordinates.first!)
            let longitude = Double(coordinates.last!)
            let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 10.0)
            self.mapView?.animate(to: camera)
            
            self.buttonMapTapped(self.buttonMap)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 8.0)
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
