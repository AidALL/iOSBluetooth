    //
//  BluetoothClassicManager.swift
//  BLEStudy
//
//  Created by 황재영 on 10/25/23.
//

import ExternalAccessory
import os

class BluetoothClassicManager: NSObject { // MFi 인증이 안된 기기는 사용이 불가?

    static let shared = BluetoothClassicManager()
   
    var accessoryList: [EAAccessory] = []
    var selectedAccessory: EAAccessory?
    var session: EASession?
    var connectedAccessories = EAAccessoryManager.shared().connectedAccessories

    func refreshDevices() {
        accessoryList = EAAccessoryManager.shared().connectedAccessories
    }

    func connectToAccessory(_ accessory: EAAccessory) {
        selectedAccessory = accessory
        if let protocolString = accessory.protocolStrings.first {
            session = EASession(accessory: accessory, forProtocol: protocolString)
            if let inputStream = session?.inputStream,
               let outputStream = session?.outputStream {
                inputStream.open()
                outputStream.open()
                // TODO: 데이터 읽기/쓰기 로직 구현
            }
        }
    }

    func disconnectAccessory() {
        session?.inputStream?.close()
        session?.outputStream?.close()
        session = nil
    }
}
