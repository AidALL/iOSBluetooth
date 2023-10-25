//
//  BluetoothClassicController.swift
//  BLEStudy
//
//  Created by 황재영 on 10/25/23.
//

import UIKit

class BluetoothClassicController: UIViewController {

    let bluetoothClassic = BluetoothClassicManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

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
