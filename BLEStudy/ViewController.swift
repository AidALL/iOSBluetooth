//
//  ViewController.swift
//  BLEStudy
//
//  Created by 황재영 on 10/20/23.
//

import UIKit
import CoreBluetooth
import os

class ViewController: UIViewController {

    let bluetoothManager = BluetoothLEManager.shared

    var nameLabel: UILabel!
    var identifierLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()

        view.backgroundColor = .white // UIViewController들이 배경색이 검정이라 흰색으로 변경

        touchUpScanButton() // 블루투스 스캔 버튼
        touchUpClassicButton() // 블루투스 스캔 종료

        sendData() // 수동 데이터 업데이트용 임시버튼

        print("hello 블루투스 World")

    }


    @objc func BLEButton(_ sender: UIButton) {
        let showBluetooth = ShowBluetoothModal()
        print("click BLE")
        self.present(showBluetooth, animated: true, completion: nil) // 모달화면 불러오기
//        let _: () = bluetoothManager.startScanning()

        showBluetooth.dismissCompletion = { [weak self] in
            self?.updatePeripheralData()
//            bluetoothManager.0
        } // ShowBluetoothModal의 dismissCompletion 클로저를 받아서 updatePeripheralData() 실행
    }

    @objc func classic(_ sender: UIButton) {
        let showClassic = BluetoothClassicController()
        print("click Classic")
//        let _: () = bluetoothManager.stopScanning()
        self.present(showClassic, animated: true, completion: nil)
    }

    @objc func updateData() {
            let dataToSend = "Hello from AnotherViewController".data(using: .utf8)!

            if let characteristic = bluetoothManager.writableCharacteristic,
               let peripheral = bluetoothManager.connectedPeripheral {
                bluetoothManager.writeValue(toCharacteristic: characteristic, onPeripheral: peripheral, value: dataToSend)
                print("데이터 전송 성공")
            } else {
                print("특성 또는 퍼리퍼럴이 nil입니다.")
            }
        }
    

    func touchUpScanButton() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("BLE", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (BLEButton), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button) // 화면에 버튼 구현
    }

    func touchUpClassicButton() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("Classic", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 250, width: 150, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (classic), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button) // 화면에 버튼 구현
    }


    func sendData() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("Cc", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 300, width: 50, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (updateData), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button)
    }

    private func setupLabels() {
        // 레이블 초기화 및 레이아웃 설정
        nameLabel = UILabel(frame: CGRect(x: 40, y: 400, width: 300, height: 30))
        nameLabel.backgroundColor = .red
        nameLabel.textColor = .black
        nameLabel.text = ""
        identifierLabel = UILabel(frame: CGRect(x: 40, y: 440, width: 300, height: 30))
        identifierLabel.backgroundColor = .green
        identifierLabel.textColor = .black
        identifierLabel.text = ""

        view.addSubview(nameLabel)
        view.addSubview(identifierLabel)

        print("레이블 세팅")
    }

    private func updatePeripheralData() {
        
        print(bluetoothManager.connectedPeripheral?.name ?? "이름 못받음")
        print(bluetoothManager.connectedPeripheral?.identifier.uuidString ?? "식별번호 못받음")
        DispatchQueue.main.async { // 메인 스레드에서 비동기로 Label을 데이터에 맞게 업데이트
            self.nameLabel?.text = "Name: \(self.bluetoothManager.connectedPeripheral?.name ?? "Unknown name")" // 옵셔널 체인 사용
            self.identifierLabel?.text = "Identifier: \(self.bluetoothManager.connectedPeripheral?.identifier.uuidString ?? "Unknown identifier number")"  // 옵셔널 체인 사용
        }
    }

}

