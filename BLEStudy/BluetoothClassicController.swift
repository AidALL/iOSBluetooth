//
//  BluetoothClassicController.swift
//  BLEStudy
//
//  Created by 황재영 on 10/25/23.
//

import UIKit

class BluetoothClassicController: UIViewController, UITableViewDelegate {

    let bluetoothClassic = BluetoothClassicManager.shared

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BluetoothCell")
        self.view.addSubview(tableView)
        self .tableView.reloadData()

        let connectedAccessories = bluetoothClassic.connectedAccessories

        for accessory in connectedAccessories {
            print("Name: \(accessory.name)")
            print("Manufacturer: \(accessory.manufacturer)")
            print("Model Number: \(accessory.modelNumber)")
            print("Serial Number: \(accessory.serialNumber)")
            print("Protocol Identifiers: \(accessory.protocolStrings)")
        }

    }



}
