//
//  ViewController.swift
//  Project22
//
//  Created by Maicon Mota on 03/12/2021.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    
    
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .systemYellow
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
//        let uuid = UUID(uuidString: "426C7565-4368-6172-6D42-6561636F6E73")! //regular 1
//        let uuid = UUID(uuidString: "426C7565-4368-6172-6D42-6561636F6E73")! //regular 2
        let uuid = UUID(uuidString: "163EB541-B100-4BA5-8652-EB0C513FB0F4")!  //simulated
//        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 3838, minor: 4949, identifier: "ali-beacon")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")  //simulated
//        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 3838, minor: 4949, identifier: "Ali2") //regular2
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
//        UIView.animate(withDuration: 0.8) {
        if distance == .far{
            self.view.backgroundColor = UIColor.blue
            self.distanceReading.text = "FAR"
        }else if distance == .near || distance == .immediate{
            self.view.backgroundColor = UIColor.orange
            self.distanceReading.text = "Notification"
            print("doing this")
        }else{
            self.view.backgroundColor = UIColor.gray
            self.distanceReading.text = "UNKNOWN"
        }
      
//        switch distance {
//        case .unknown:
//            self.view.backgroundColor = UIColor.gray
//            self.distanceReading.text = "UNKNOWN"
//        case .immediate:
//            self.view.backgroundColor = UIColor.red
//            self.distanceReading.text = "RIGHT HERE"
//        case .near:
//            self.view.backgroundColor = UIColor.orange
//            self.distanceReading.text = "NEAR"
//        case .far:
//            self.view.backgroundColor = UIColor.blue
//            self.distanceReading.text = "FAR"
//        @unknown default:
//            self.view.backgroundColor = UIColor.gray
//            self.distanceReading.text = "UNKNOWN"
//        }

        
//        }
    }
    
    var beaconPrevState: CLProximity = .unknown
    var checkerState: CLProximity = .unknown
    var cnt: Int = 0
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            //checks if the readings are same
            if (checkerState == beacon.proximity){
                cnt+=1
            }else{
                checkerState = beacon.proximity
                cnt=0
            }
            
            //only update if the information is new
            if ((cnt >= 1) && (beaconPrevState != checkerState)){
                beaconPrevState = checkerState
                update(distance: beaconPrevState)
            }else{
                cnt=0
            }
//            update(distance: beacon.proximity)
            
        } else {
            update(distance: .unknown)
        }
    }
    
    
}

