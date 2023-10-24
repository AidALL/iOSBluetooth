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

    let bluetoothManager = BluetoothManager.shared

    private var nameLabel: UILabel!
    private var identifierLabel: UILabel!

    var data: CBPeripheral? {
        didSet {
            print("\(data as Any) 데이터 전송")
            updatePeripheralData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white // UIViewController들이 배경색이 검정이라 흰색으로 변경


        touchUpScanButton() // 블루투스 스캔 버튼
        touchUpStopButton() // 블루투스 스캔 종료

        updatePeripheralData()

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

    private func updatePeripheralData() {
        guard var nameLabel = nameLabel,
              var identifierLabel = identifierLabel else {
            return
        }

        nameLabel.text = "Name: \(data?.name ?? "Unknown")"
        identifierLabel.text = "Identifier: \(data?.identifier.uuidString ?? "N/A")"

        // 각 레이블 초기화 및 레이아웃 설정
        nameLabel = UILabel(frame: CGRect(x: 15, y: 500, width: view.bounds.width - 30, height: 30))
        identifierLabel = UILabel(frame: CGRect(x: 15, y: 540, width: view.bounds.width - 30, height: 30))

        view.addSubview(nameLabel)
        view.addSubview(identifierLabel)
    }

}

