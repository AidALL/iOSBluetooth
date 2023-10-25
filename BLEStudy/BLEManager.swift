//
//  CBCentralMangerController.swift
//  BLEStudy
//
//  Created by 황재영 on 10/23/23.
//

import CoreBluetooth
import os
import UIKit

class BluetoothLEManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let shared = BluetoothLEManager()

    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    var connectedPeripheral: CBPeripheral?
//    let CBCentralManagerOptionShowPowerAlertKey: String   // Bluetooth 서비스를 사용할 수 없을 때 앱이 중앙 관리자를 인스턴스화하는 경우 시스템이 사용자에게 경고할지 여부를 지정하는 bool 값 - 기본값 true
    var restoreIdentifier: String?
    var discoveredPeripherals: [CBPeripheral] = []
    var completion: ((Bool) -> Void)?
    weak var tableView: UITableView?
    


    private override init() {
        super.init()
        let options = [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifier] // UUID지정 앱이 백그라운드에서 종료되었을 때 연결된 주변 장치와의 연결을 유지하거나 복원하기 위해 사용됩니다.
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: options as [String : Any])
            }

    private func setupCentralManager() {
            centralManager = CBCentralManager(delegate: self, queue: nil) // CBCentralManager 객체를 초기화
        // delegate: self: CBCentralManager의 델리게이트(delegate)를 현재 클래스(즉, self)로 설정합니다. 이렇게 하면 CBCentralManager에서 발생하는 이벤트(예: Bluetooth 상태 변경, 주변 장치 발견 등)에 대한 콜백을 현재 클래스에서 받을 수 있습니다. 이를 위해서는 현재 클래스가 CBCentralManagerDelegate 프로토콜을 준수해야 합니다.
        // queue: nil: 이 매개변수는 델리게이트 메서드가 실행될 디스패치 큐(dispatch queue)를 지정합니다. nil로 설정하면 메인 큐에서 델리게이트 메서드가 실행됩니다. 특정 큐에서 이벤트를 처리하려면 해당 큐를 지정할 수 있습니다.
        }

    func connect(to peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

        func startScanning() {
            if centralManager.state == .poweredOn { // Bluetooth 중앙 관리자의 상태를 나타내는 state라는 속성이 .poweredOn이면
                centralManager.scanForPeripherals(withServices: nil, options: nil) // 주변장치 탐색
                // withServices: 스캔하려는 서비스의 UUID 목록입니다. nil로 설정하면 모든 서비스를 가진 주변 장치를 스캔합니다. 특정 서비스만 스캔하려면 "withServices: [serviceUUID]"를 사용
                // options: 스캔 옵션을 지정하는 딕셔너리입니다. 예를 들어, 이전에 연결이 끊어진 주변 장치를 스캔하려면 CBCentralManagerScanOptionAllowDuplicatesKey 옵션을 사용할 수 있습니다. nil로 설정하면 기본 옵션을 사용합니다.
                print("스캔 시작...")
            } else {
                print("스캔 불가")
            }
        } // 주변 장치 스캔 시작

        func stopScanning() {
            centralManager.stopScan()
            print("스캔 중지...")
        } // 주변 장치 스캔 중지

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
                print("Bluetooth status is UNKNOWN")
            case .resetting:
                print("Bluetooth status is RESETTING")
            case .unsupported:
                print("Bluetooth status is UNSUPPORTED")
            case .unauthorized:
                print("Bluetooth status is UNAUTHORIZED")
            case .poweredOff:
                print("Bluetooth status is POWERED OFF")
            case .poweredOn:
                print("Bluetooth status is POWERED ON")
            @unknown default:
                print("Unknown state")
            }
    } // 델리게이트 메서드 centralManagerDidUpdateState(_:)는 Bluetooth 상태의 변경을 처리하기 위해 구현

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {

        guard RSSI.intValue >= -70
            else {
                os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
                return
        } // 일정 수신도 이하의 장비들은 리스트에 추가하지 않도록 하는 guard 문

        os_log("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)

        if discoveredPeripheral != peripheral { // 디바이스가 일정 이상 수신도 일때 - 등록되지 않은 기기이면
            discoveredPeripheral = peripheral // peripheral 에 추가해둔다

            os_log("Connecting to perhiperal %@", peripheral)
            discoveredPeripherals.append(discoveredPeripheral!)
            DispatchQueue.main.async { // tableView의 리로딩을 메인스레드에 둬서 자연스럽게 한다
                self.tableView?.reloadData()
            }
//            centralManager.connect(peripheral, options: nil) // 장치를 저장하고 연결 시도
        }
    }

    func startConnection(completion: @escaping (Bool) -> Void) {
            self.completion = completion
            // callback 함수를 실행시키기 위한 연결 메소드
        }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "a device")")
        completion?(true) // 연결 성공 콜백 호출
        completion = nil  // 클로저를 호출한 후에는 nil로 설정하여 메모리 누수를 방지

        self.connectedPeripheral = peripheral

        // 해당 peripheral에 대한 서비스 탐색 시작
        peripheral.delegate = self
        print(peripheral.delegate ?? "UNKnown")
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "a device"). Error: \(error?.localizedDescription ?? "Unknown error")")
        completion?(false) //연결 실패 콜백 호출
        completion = nil  // 클로저를 호출한 후에는 nil로 설정하여 메모리 누수를 방지
    } // 연결 시도 후 실패했을때 실행되는 오류 메세지

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Disconnected from \(peripheral.name ?? "a device") due to error: \(error.localizedDescription)")
        } else {
            print("Disconnected from \(peripheral.name ?? "a device")")
        } // 연결 끊김 후 실행되는 오류 메세지
    }

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        if let restoredPeripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] { // 복원된 주변 장치들을 처리합니다.
            for peripheral in restoredPeripherals { // 예를 들어, 복원된 주변 장치를 discoveredPeripheral 변수에 저장합니다.
                self.discoveredPeripheral = peripheral
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let error = error {
                print("Error discovering services: \(error.localizedDescription)")
                return
            } // 오류 확인
    }

    // 1. 서비스와 특성 탐색 (이미 발견된 상황을 가정합니다)

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // 예를 들어, 원하는 특성의 UUID가 QCY-T5_BLER의 "XXXX-XXXX-..."일 경우
                if characteristic.uuid == CBUUID(string: "20F752FC-B049-B8C0-AA3F-CC34004F702D") {
                    // 2. 특성의 값을 읽습니다.
                    peripheral.readValue(for: characteristic)
                    print(peripheral.readValue(for: characteristic))
                }
            }
        }
    }

    // 3. peripheral(_:didUpdateValueFor:error:) 메서드에서 읽은 값을 처리합니다.

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading value for characteristic: \(error.localizedDescription)")
            return
        }

        if let data = characteristic.value {
            // 여기서 data를 사용하여 필요한 작업을 수행합니다.
            // 예를 들면, data를 문자열로 변환하거나 다른 형식으로 처리할 수 있습니다.
            let valueString = String(data: data, encoding: .utf8)
            print("Read value: \(valueString ?? "unknown")")
        }
    }

}
