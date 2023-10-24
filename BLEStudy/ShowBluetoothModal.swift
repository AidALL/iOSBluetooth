//
//  ShowBluetoothModal.swift
//  BLEStudy
//
//  Created by 황재영 on 10/24/23.
//

import UIKit


class ShowBluetoothModal: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let bluetoothManager = BluetoothManager.shared

    var tableView: UITableView!
    var selectedIndex: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bluetoothManager.discoveredPeripherals.removeAll() // 데이터 초기화
        tableView.reloadData() // 테이블 뷰 데이터 갱신
        bluetoothManager.startScanning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        BluetoothManager.shared.tableView = tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BluetoothCell")
        self.view.addSubview(tableView)
        self .tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bluetoothManager.stopScanning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothManager.discoveredPeripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell", for: indexPath)
            let peripheral = bluetoothManager.discoveredPeripherals[indexPath.row]
            cell.textLabel?.text = peripheral.name ?? peripheral.identifier.uuidString
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print(indexPath.row)
        bluetoothConnect { (success) in
            if success {
                print("창닫음")
                ViewController().data = self.bluetoothManager.discoveredPeripherals[indexPath.row]
                print(ViewController().data ?? "nil")
                self.dismiss(animated: true, completion: nil) // 조건 달성시 창닫음
            } else {
                print("연결오류")
                return
            }
        }
    }

//    func bluetoothConnect() {
//        guard let index = selectedIndex else { return }
//        print(bluetoothManager.discoveredPeripherals[index])
//        bluetoothManager.centralManager.connect(bluetoothManager.discoveredPeripherals[index], options: nil)
//    }


    func bluetoothConnect(completion: @escaping (Bool) -> Void) {
        guard let index = selectedIndex else {
            completion(false)
            return
        }
        let peripheral = bluetoothManager.discoveredPeripherals[index]

        // 클로저를 BluetoothManager의 completion 프로퍼티에 설정
            bluetoothManager.completion = completion

        // 연결 시도...
        bluetoothManager.centralManager.connect(peripheral, options: nil)

        // 연결 결과는 CBCentralManagerDelegate의 메서드에서 처리될 예정입니다.
        // 해당 메서드에서 completion 콜백을 호출합니다.
    }





}
