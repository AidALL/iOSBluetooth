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

    var data: CBPeripheral? {
        didSet {
            print("데이터 \(data as Any) 전송 받음")
            updatePeripheralData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(bluetoothManager.connectedPeripheral ?? "몰루?")
        setupLabels()

        view.backgroundColor = .white // UIViewController들이 배경색이 검정이라 흰색으로 변경

        touchUpScanButton() // 블루투스 스캔 버튼
        touchUpStopButton() // 블루투스 스캔 종료

        print("hello 블루투스 World")

    }


    @objc func startScanning(_ sender: UIButton) {
        let showBluetooth = ShowBluetoothModal()
        print("click scanning")
        self.present(showBluetooth, animated: true, completion: nil)
//        let _: () = bluetoothManager.startScanning()
    }

    @objc func stopScanning(_ sender: UIButton) {
        print("stop scanning")
        let _: () = bluetoothManager.stopScanning()
    }

    func touchUpScanButton() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("Scan", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (startScanning), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button) // 화면에 버튼 구현
    }

    func touchUpStopButton() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("Stop", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 250, width: 150, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (stopScanning), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button) // 화면에 버튼 구현
    }

    private func setupLabels() {
        // 레이블 초기화 및 레이아웃 설정
        nameLabel = UILabel(frame: CGRect(x: 40, y: 400, width: 300, height: 30))
        nameLabel.backgroundColor = .red
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 5)
        identifierLabel = UILabel(frame: CGRect(x: 40, y: 440, width: 300, height: 30))
        identifierLabel.backgroundColor = .green
        identifierLabel.textColor = .black

        view.addSubview(nameLabel)
        view.addSubview(identifierLabel)
    }



    private func updatePeripheralData() {
        var name: String = String(describing: data?.name) ?? "Unknown"
        var identifier: String = data?.identifier.uuidString ?? "nil???"

        nameLabel?.text = "Name: \(bluetoothManager.connectedPeripheral?.name ?? "Unknown")" // 옵셔널 체인 사용
        identifierLabel?.text = "Identifier: \(identifier ?? "nil???")"  // 옵셔널 체인 사용
        print(bluetoothManager.connectedPeripheral?.name ?? "이름 못받음")
        print(data?.identifier.uuidString ?? "식별번호 못받음")
    }

}

