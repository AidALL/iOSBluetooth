#  BLEStudy Docs v0.1

** 2023.12 기준


***
***


## BluetoothClassicManager

 - Description
    
    앱을 통하여 Classic Bluetooth 기기를 연결하여 제어하는 기능을 만들고자 생성

#### MFi 인증이 없는 블루투스기기는 IPhone앱을 통해 제어할수 없도록 되어 있는것으로 보임


***


## BluetoothClassicController

 - Description
    
    앱을 통하여 Classic Bluetooth 기기를 연결하여 제어하는 기능을 만들고자 생성

#### MFi 인증이 없는 블루투스기기는 IPhone앱을 통해 제어할수 없도록 되어 있는것으로 보임


***


## BLEManager

 - Description
 
    BluetoothLEManager 클래스는 Core Bluetooth 프레임워크를 사용하여 iOS 디바이스에서 블루투스 저에너지(BLE) 통신을 관리합니다. 이 클래스는 싱글톤 패턴을 사용하여 앱 전역에서 하나의 인스턴스를 공유합니다.

    #### 주요 구성요소

    - `static let shared = BluetoothLEManager()`: 싱글톤 인스턴스를 제공합니다. 이 인스턴스를 통해 클래스의 메서드와 프로퍼티에 접근할 수 있습니다.
    
    - `var centralManager: CBCentralManager!`: BLE 장치를 탐색하고 연결하는 데 사용되는 중앙 관리자입니다.
    
    - `var discoveredPeripheral: CBPeripheral?`: 탐색된 BLE 주변 장치를 저장합니다. 이 프로퍼티는 현재 탐색 중인 장치를 나타냅니다.
    
    - `var connectedPeripheral: CBPeripheral?`: 현재 연결된 BLE 주변 장치를 저장합니다.
    
    - `var restoreIdentifier: String?`: 중앙 관리자의 상태 복원을 위한 식별자입니다.
    
    - `var discoveredPeripherals: [CBPeripheral]`: 탐색된 모든 주변 장치의 리스트를 저장합니다.
    
    - `var completion: ((Bool) -> Void)?`: 연결이나 데이터 전송과 같은 작업의 완료 여부를 알려주는 콜백 함수입니다.
    
    - `var writableCharacteristic: CBCharacteristic?`: 데이터를 쓸 수 있는 주변 장치의 특성(characteristic)을 저장합니다.
    
    - `weak var tableView: UITableView?`: 연결된 또는 탐색된 BLE 장치를 표시하기 위한 테이블 뷰입니다. 이 뷰는 사용자 인터페이스와 상호작용하는 데 사용됩니다.

    #### 기능

    - BluetoothLEManager 클래스는 CBCentralManager를 사용하여 주변의 BLE 장치를 탐색하고, 사용자가 선택한 장치에 연결합니다. 연결된 장치는 connectedPeripheral에 저장되며, 탐색된 모든 장치는 discoveredPeripherals 배열에 저장됩니다.

    - 연결된 장치와의 데이터 통신은 CBPeripheral의 특성을 통해 이루어집니다. writableCharacteristic은 쓰기 가능한 특성을 나타내며, 이를 통해 데이터를 전송할 수 있습니다.
    
    - 이 클래스는 tableView 프로퍼티를 사용하여 사용자 인터페이스와 상호작용합니다. UITableView는 탐색된 장치 목록을 표시하고 사용자가 장치를 선택할 수 있게 합니다.



### private override init()

 - Description
 
    BluetoothLEManager 클래스의 인스턴스를 초기화합니다.
    이 메서드는 override 키워드를 사용하여 NSObject의 init 메서드를 재정의합니다.
    private 접근 제어자는 클래스 외부에서 이 초기화자를 직접 사용하지 못하게 제한합니다. 이는 싱글톤 패턴을 구현하는 데 일반적으로 사용되는 방법입니다.
    
    `super.init(): NSObject`의 초기화 메서드를 호출합니다. 이는 상위 클래스의 초기화 과정을 수행하는 표준 절차입니다.

    `let options = [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifier]`:

    여기서 `CBCentralManagerOptionRestoreIdentifierKey`는 `Core Bluetooth` 중앙 관리자 옵션 중 하나입니다.
    
    `restoreIdentifier`는 UUID 문자열로, 앱이 백그라운드에서 종료되었을 때 연결된 BLE 주변 장치와의 연결을 유지하거나 복원하는 데 사용됩니다. 이 식별자는 앱의 상태 복원 과정에서 중요한 역할을 합니다.
    
    `self.centralManager = CBCentralManager(delegate: self, queue: nil, options: options as [String : Any])`:
    `CBCentralManager` 인스턴스를 생성하고 `BluetoothLEManager` 클래스의 인스턴스를 그 대리자(delegate)로 지정합니다.
    `queue: nil`은 이벤트가 메인 큐에서 처리되도록 설정합니다. 필요에 따라 다른 디스패치 큐를 지정할 수 있습니다.
    `options` 매개변수는 `CBCentralManager`의 동작을 구성하는 데 사용됩니다. 여기서는 상태 복원을 위한 `restoreIdentifier`를 포함합니다.


### private func setupCentralManager()

 - Description
 
    `CBCentralManager` 객체를 초기화
    `Delegate: self: CBCentralManager`의 델리게이트(delegate)를 현재 클래스(즉, self)로 설정합니다. 이렇게 하면 CBCentralManager에서 발생하는 이벤트(예: Bluetooth 상태 변경, 주변 장치 발견 등)에 대한 콜백을 현재 클래스에서 받을 수 있습니다. 이를 위해서는 현재 클래스가 CBCentralManagerDelegate 프로토콜을 준수해야 합니다.
    `queue: nil`: 이 매개변수는 델리게이트 메서드가 실행될 디스패치 큐(dispatch queue)를 지정합니다. nil로 설정하면 메인 큐에서 델리게이트 메서드가 실행됩니다. 특정 큐에서 이벤트를 처리하려면 해당 큐를 지정할 수 있습니다.




### func connect(to peripheral: CBPeripheral)

 - Description
 
    이 메소드는 지정된 CBPeripheral에 연결을 초기화합니다. `connectedPeripheral` 속성을 주어진 페리퍼럴로 설정하고 `centralManager`에게 페리퍼럴과의 연결을 시도하도록 지시합니다. 이 단계는 블루투스 통신 과정에서 중요하며, 이 코드를 실행하는 중앙 장치가 주변 장치와 상호 작용할 수 있게 해줍니다.
 
 - Parameters
 
    `peripheral`: 연결을 맺을 `CBPeripheral` 객체입니다. 이 매개변수는 연결하고자 하는 블루투스 주변 장치를 나타냅니다.




### func startScanning()

 - Description
 
    이 메소드는 블루투스 주변장치를 스캔하기 시작합니다. 먼저, `centralManager`의 `state` 속성을 확인하여 블루투스가 켜져 있는지 (poweredOn) 확인합니다. 상태가 `poweredOn`이면 `centralManager는 scanForPeripherals(withServices:options:)` 메소드를 사용하여 주변장치를 스캔합니다. `nil`로 설정된 `withServices`는 모든 서비스를 가진 주변 장치를 스캔하며, 특정 서비스만 스캔하고자 할 경우 해당 UUID 목록을 제공할 수 있습니다. `options`는 스캔 옵션을 지정하는데 사용되며, 기본적으로 `nil`로 설정됩니다.

    - 주요기능
        블루투스 상태 확인: `centralManager.state`가 `.poweredOn`인지 확인합니다.
        주변장치 스캔: 조건이 충족되면 모든 서비스를 가진 주변장치를 스캔합니다.
        스캔 상태 메시지: 스캔이 시작되거나 불가능할 때 적절한 메시지를 출력합니다.




### func stopScanning()

 - Description
 
    `func startScanning()`으로 진행하고 있던 스캔을 중지합니다.




### func centralManagerDidUpdateState(_ central: CBCentralManager)

 - Description
 
    이 메소드는 `CBCentralManager`의 상태가 변경될 때마다 호출되는 델리게이트 메서드입니다. `central`의 상태(state)에 따라 다양한 경우를 처리합니다. 상태는 `.unknown`, `.resetting`, `.unsupported`, `.unauthorized`, .`poweredOff`, `.poweredOn` 등으로 분류됩니다. 각 상태에 대해 적절한 메시지를 출력하여 현재 블루투스 상태를 사용자에게 알립니다. `@unknown default` 케이스는 미래에 추가될 수 있는 새로운 상태를 처리하기 위해 포함되어 있습니다.

    - 주요기능
        `central.state`에 따른 분기 처리: 블루투스 상태에 따라 적절한 메시지 출력.
        다양한 블루투스 상태 인식: `.unknown`, `.resetting` 등 다양한 상태를 구분하여 처리.
        상태 변경에 대한 로깅: 현재 블루투스 상태에 대한 정보를 로그로 출력.

- Parameters

    central: 상태가 변경된 `CBCentralManager` 인스턴스입니다.




### func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber)

 - Description
 
    이 메소드는 `CBCentralManager`가 주변 장치를 발견할 때마다 호출됩니다. 메소드는 발견된 장치의 수신 신호 강도 지시자(RSSI)를 확인하여 특정 범위 (-70dBm 이상) 내에 있는지 검사합니다. 수신도가 이 범위 내에 있다면, 해당 장치에 대한 정보를 기록하고, 아직 등록되지 않은 장치라면 `discoveredPeripheral` 목록에 추가합니다. 그 후, 메인 스레드에서 테이블 뷰를 리로드하여 사용자 인터페이스를 업데이트합니다.

 - Parameters
 
    `central`: 주변 장치를 발견한 `CBCentralManager` 인스턴스.
    `peripheral`: 발견된 CBPeripheral 장치.
    `advertisementData`: 발견된 장치의 광고 데이터. `[String: Any]` 형태의 딕셔너리입니다.
    `RSSI`: 발견된 장치의 수신 신호 강도 지시자 (NSNumber).




### func startConnection(completion: @escaping (Bool) -> Void)

 - Description

    이 메소드는 연결 과정을 시작하고 완료될 때 콜백 함수를 실행하기 위해 설계되었습니다. `completion`이라는 이름의 클로저 매개변수를 받으며, 이는 연결의 성공 또는 실패에 따라 `true` 또는 `false` 값을 반환합니다. 메소드 내부에서는 `self.completion`에 `completion` 클로저를 할당함으로써, 연결 프로세스가 완료되었을 때 해당 클로저가 실행될 수 있도록 합니다. 이러한 설계는 비동기 연결 프로세스에서 연결 상태에 대한 결과를 처리하는 데 유용합니다.

    - 주요기능
        클로저 저장: 연결 상태에 대한 결과를 처리할 `completion` 클로저를 저장합니다.
        비동기 연결 처리: 연결 프로세스의 결과가 나타나면 이 클로저를 실행하여 결과를 처리합니다.

 - Parameters
 
    `completion`: 연결 상태의 결과를 나타내는 `Bool` 값을 반환하는 클로저입니다. 연결이 성공적으로 완료되면 `true`, 실패하면 `false`를 반환합니다.




### func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)

 - Description
 
    이 메소드는 `CBCentralManager`가 주변장치에 성공적으로 연결되었을 때 호출됩니다. 연결된 장치의 이름을 출력하고, 성공적인 연결을 나타내는 콜백 함수 `completion`을 `true`로 호출합니다. 콜백 호출 후 `completion`은 `nil`로 설정되어 메모리 누수를 방지합니다. 그 후, 연결된 `peripheral`의 서비스 탐색을 시작하기 위해 `peripheral`의 델리게이트를 `self`로 설정하고, 서비스 탐색을 위한 `discoverServices` 메소드를 호출합니다.

    - 주요기능
        연결 상태 로깅: 연결된 장치의 이름을 로그로 출력합니다.
        연결 성공 콜백 호출: `completion` 클로저를 `true`로 호출하여 연결 성공을 알립니다.
        메모리 관리: 콜백 호출 후 `completion`을 `nil`로 설정하여 메모리 누수 방지.
        서비스 탐색 시작: 연결된 `peripheral`에 대한 서비스 탐색을 시작합니다.

 - Parameters
 
    `central`: 주변장치에 연결된 `CBCentralManager` 인스턴스.
    `peripheral`: 연결된 `CBPeripheral` 장치.




### func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)

 - Description
 
    이 메소드는 `CBCentralManager`가 주변장치에 연결을 시도했으나 실패했을 때 호출됩니다. 실패한 장치의 이름과 발생한 오류의 설명을 출력합니다. 연결 실패를 나타내는 콜백 함수 `completion`을 `false`로 호출하여 연결 실패 상태를 알립니다. 콜백 호출 후 `completion`은 `nil`로 설정되어 메모리 누수를 방지합니다.
    
    - 주요기능
        연결 실패 로깅: 연결에 실패한 장치의 이름과 오류 정보를 로그로 출력합니다.
        연결 실패 콜백 호출: `completion` 클로저를 `false`로 호출하여 연결 실패를 알립니다.
        메모리 관리: 콜백 호출 후 `completion`을 `nil`로 설정하여 메모리 누수 방지.

 - Parameters

    `central`: 연결 실패한 `CBCentralManager` 인스턴스.
    `peripheral`: 연결에 실패한 `CBPeripheral` 장치.
    `error`: 연결 실패와 관련된 오류 정보. `Error?` 타입입니다.




### func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)

 - Description
 
    이 메소드는 `CBCentralManager`와 주변장치 간의 연결이 끊어졌을 때 호출됩니다. 연결이 오류로 인해 끊어진 경우, 해당 오류의 설명과 함께 끊어진 장치의 이름을 출력합니다. 오류가 없는 정상적인 연결 해제 상황에서는 단순히 장치의 이름과 함께 연결 해제 사실만을 로그로 출력합니다. 이 메소드는 연결 상태의 변경을 추적하고, 오류 발생 시 문제를 진단하는 데 유용합니다.
    
    - 주요기능
        연결 해제 로깅: 연결이 끊어진 장치의 이름과 함께 연결 해제 상황을 로그로 출력합니다.
        오류 처리: 연결 해제가 오류로 인한 경우, 해당 오류의 상세 정보를 출력합니다.

 - Parameters

    `central`: 연결이 끊어진 `CBCentralManager` 인스턴스.
    `peripheral`: 연결이 끊어진 `CBPeripheral` 장치.
    `error`: 연결 해제와 관련된 오류 정보. `Error?` 타입입니다.




### func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any])

 - Description
 
    이 메소드는 `CBCentralManager`의 상태가 복원될 때 호출됩니다. 앱이 백그라운드 상태에서 다시 활성화될 때, 이 메소드는 저장된 상태 정보를 이용해 중앙 관리자의 상태를 복원합니다. `dict` 매개변수를 통해 복원된 데이터에 접근할 수 있으며, 특히 `CBCentralManagerRestoredStatePeripheralsKey`를 키로 사용하여 복원된 `CBPeripheral` 객체들의 배열을 얻을 수 있습니다. 이 배열에 있는 각 주변장치에 대해 필요한 처리를 수행할 수 있습니다. 예를 들어, 복원된 주변장치를 `discoveredPeripheral` 변수에 저장하는 작업을 할 수 있습니다.
    
    - 주요기능
        복원된 주변장치 처리: `dict`에서 `CBCentralManagerRestoredStatePeripheralsKey`를 키로 사용하여 복원된 주변장치들을 얻고, 이를 처리합니다.
        상태 복원: 앱의 상태 복원 시 필요한 주변장치 정보를 복원하고 관리합니다.

 - Parameters

    `central`: 상태가 복원되는 `CBCentralManager` 인스턴스.
    `dict`: 복원된 상태 데이터를 포함하는 딕셔너리. `[String : Any]` 타입입니다.




### func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)

 - Description
 
    이 메소드는 `CBPeripheral` 객체가 서비스를 발견했을 때 호출됩니다. 먼저, 서비스 탐색 중 발생할 수 있는 오류를 확인하고, 오류가 있다면 해당 오류의 설명을 출력한 다음 메소드를 종료합니다. 오류가 없는 경우, `peripheral.services`를 검사하여 발견된 서비스가 있는지 확인합니다. 발견된 각 서비스에 대해서는, 특정 UUID를 포함하는 원하는 서비스인지 확인합니다. 원하는 서비스를 찾으면, 그에 대한 추가 작업을 수행할 수 있습니다. 예를 들어, 해당 서비스의 특성을 탐색하는 것입니다. 원하는 서비스가 아니더라도, 탐색을 계속 진행할 수 있습니다.
    
    - 주요기능
        오류 처리: 서비스 탐색 중 발생한 오류가 있는지 확인하고, 있다면 처리합니다.
        서비스 탐색: 발견된 서비스를 확인하고, 특정 UUID를 포함하는 서비스를 찾습니다.
        추가 작업 수행: 원하는 서비스를 찾았을 때 추가적인 작업을 수행합니다, 예를 들어 해당 서비스의 특성을 탐색합니다.

 - Parameters
 
    `peripheral`: 서비스를 발견한 `CBPeripheral` 객체.
    `error`: 서비스 탐색과 관련된 오류 정보. `Error?` 타입입니다.




### func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)

 - Description
 
    이 메소드는 `CBPeripheral` 객체가 특정 `CBService`에 대한 특성을 발견했을 때 호출됩니다. 먼저, 특성 발견 중 발생할 수 있는 오류를 확인합니다. 오류가 없으면, 발견된 특성을 순회하면서 각 특성에 대한 추가 작업을 수행합니다. 이 작업에는 특성의 값을 읽거나, 특정 특성에 대한 알림을 설정하는 것이 포함될 수 있습니다. 예를 들어, 특정 UUID를 가진 특성을 찾아 해당 특성의 값을 읽거나, 특성이 알림 기능을 지원하는 경우 이를 활성화하여 실시간으로 특성의 변경을 감지할 수 있습니다.

    - 주요기능
        오류 확인: 특성 탐색 중 발생한 오류가 있는지 확인합니다.
        특성 처리: 발견된 특성을 순회하면서 필요한 작업을 수행합니다. 예를 들어, 특성의 값을 읽거나, 특성에 대한 알림을 설정합니다.
        실시간 감지: 특성이 알림 기능을 지원하는 경우, 이를 활성화하여 특성 값의 변화를 실시간으로 감지합니다.

 - Parameters
 
    `peripheral`: 특성을 발견한 `CBPeripheral` 객체.
    `service`: 특성이 발견된 `CBService` 객체.
    `error`: 특성 탐색과 관련된 오류 정보. `Error?` 타입입니다.




### func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)

 - Description

    이 메소드는 `CBPeripheral`의 특정 `CBCharacteristic` 값이 업데이트되었을 때 호출됩니다. 주로 특성의 값이 읽혀지거나 알림으로 인해 변경된 경우에 이 메소드가 호출됩니다. 먼저, 특성 값을 읽는 과정에서 발생한 오류를 확인합니다. 오류가 없는 경우, 업데이트된 특성 값(`characteristic.value`)을 사용하여 필요한 작업을 수행합니다. 예를 들어, 데이터를 문자열 또는 다른 형식으로 변환하여 처리할 수 있습니다. 이 메소드는 Bluetooth 통신에서 중요한 데이터 처리를 위한 핵심적인 부분입니다.
    
    - 주요기능
        오류 확인: 특성 값 읽기 중 발생한 오류가 있는지 확인합니다.
        데이터 처리: 특성의 업데이트된 값을 가져와서 필요한 변환 및 처리를 수행합니다.
        결과 로깅: 읽은 값의 내용을 로그로 출력합니다.

 - Parameters
 
    `peripheral`: 특성의 값을 업데이트한 `CBPeripheral` 객체.
    `characteristic`: 값이 업데이트된 `CBCharacteristic` 객체.
    `error`: 값 업데이트와 관련된 오류 정보. `Error?` 타입입니다.




### func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)

 - Description
 
    이 메소드는 `CBPeripheral`의 특정 `CBCharacteristic`에 대한 알림 상태가 변경되었을 때 호출됩니다. 주로 `setNotifyValue(_:for:)` 메소드를 통해 특성에 대한 알림을 설정하거나 해제한 후에 이 메소드가 실행됩니다. 메소드는 먼저 알림 상태 변경 중 발생한 오류를 확인합니다. 오류가 없는 경우, `characteristic.isNotifying` 속성을 확인하여 특성에 대한 알림이 시작되었는지, 아니면 중단되었는지를 판단합니다. 알림이 시작되었을 경우 관련 메시지를 출력하고, 알림이 중단되었을 경우 연결을 해제하는 것을 고려할 수 있습니다. 이는 `cancelPeripheralConnection` 메소드를 통해 수행됩니다. 이 메소드는 Bluetooth 통신에서 중요한 알림 상태 관리와 연결 관리에 사용됩니다.
    
    - 주요기능
        오류 처리: 알림 상태 변경 중 발생한 오류가 있는지 확인합니다.
        알림 상태 확인: `characteristic.isNotifying`을 통해 알림이 활성화되었는지 또는 중단되었는지 확인합니다.
        연결 관리: 필요한 경우 알림 중단 시 `CBPeripheral`과의 연결을 해제합니다.

 - Parameters
 
    `peripheral`: 알림 상태가 변경된 `CBPeripheral` 객체.
    `characteristic`: 알림 상태가 변경된 `CBCharacteristic` 객체.
    `error`: 알림 상태 변경과 관련된 오류 정보. `Error?` 타입입니다.




### func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)

 - Description

    이 메소드는 `Bluetooth Low Energy (BLE)` 장치의 특정 `CBCharacteristic`에 값을 쓴 후 호출됩니다. 메소드는 먼저 쓰기 작업 중 발생할 수 있는 오류를 확인하고, 오류가 있을 경우 해당 오류의 설명을 출력합니다. 오류가 없는 경우, 쓰기 작업이 성공적으로 완료되었음을 나타내는 메시지를 출력합니다. 이 메소드는 BLE 통신에서 데이터 쓰기 프로세스의 완료와 오류 처리에 중요한 역할을 합니다. 중요한 점은 쓰기 가능한 특성을 정확하게 식별하고, 적절한 형식의 데이터를 올바른 쓰기 타입(`withResponse` 또는 `withoutResponse`)으로 전송하는 것입니다.

    - 주요기능
        오류 처리: 쓰기 작업 중 발생한 오류를 확인하고 처리합니다.
        작업 완료 메시지: 쓰기 작업이 성공적으로 완료되었음을 로그로 출력합니다.
        데이터 전송 확인: 쓰기 작업의 결과를 확인하여 데이터가 올바르게 전송되었는지 확인합니다.

 - Parameters

    `peripheral`: 쓰기 작업이 수행된 `CBPeripheral` 객체.
    `characteristic`: 쓰기 작업이 수행된 `CBCharacteristic` 객체.
    `error`: 쓰기 작업과 관련된 오류 정보. `Error?` 타입입니다.






### func writeValue(toCharacteristic characteristic: CBCharacteristic, onPeripheral peripheral: CBPeripheral, value: Data)

 - Description
 
    이 메소드는 `CBPeripheral`의 특정 `CBCharacteristic`에 값을 쓰는 기능을 수행합니다. 특성의 속성을 확인하여 쓰기 작업을 지원하는지 여부를 결정합니다. 특성이 `.write` 속성을 포함하고 있으면, `withResponse` 타입의 쓰기를 수행하여 장치로부터 응답을 받습니다. 반면, 특성이 `.writeWithoutResponse` 속성을 포함하고 있다면, `withoutResponse` 타입의 쓰기를 수행하여 응답 없이 값을 전송합니다. 이 메소드는 Bluetooth 통신에서 데이터 전송 과정의 중요한 부분으로, 다양한 특성에 대해 값을 쓸 때 사용됩니다.

    - 주요기능
        쓰기 가능 여부 확인: 특성이 쓰기를 지원하는지 확인합니다.
        쓰기 작업 수행: 쓰기 가능한 경우, 적절한 타입(`withResponse` 또는 `withoutResponse`)으로 쓰기 작업을 수행합니다.
        데이터 전송: 주어진 `value` 데이터를 특성에 전송합니다.

 - Parameters
 
    `characteristic`: 값을 쓸 `CBCharacteristic` 객체.
    `peripheral`: 특성이 속한 `CBPeripheral` 객체.
    `value`: 특성에 쓸 데이터. `Data` 타입입니다.




***




## ViewController

 - Description

    앱 실행시 초기화면
     
    
    #### 주요 구성요소
    
        `let bluetoothManager = BluetoothLEManager.shared`: 싱글턴 인스턴스를 불러옵니다. BLEManager 파일의 BluetoothLEManager를 사용합니다.
        `var nameLabel: UILabel!`:  
        `var identifierLabel: UILabel!`: 




***




### override func viewDidLoad()

 - setupLabels(): nameLabel 및 identifierLabel을 초기화하고 설정합니다.
 - 배경색 설정: 뷰의 배경색을 흰색으로 변경합니다.
 - touchUpScanButton(): 블루투스 장치를 스캔하기 시작하는 함수일 수 있습니다.
 - touchUpClassicButton(): 블루투스 스캔 프로세스를 중단하는 함수로 추정됩니다.
 - sendData(): 연결된 블루투스 장치에 데이터를 보내거나 수동 업데이트를 수행하는 메소드일 수 있습니다.
 - 프린트 문: 디버깅이나 표시 목적으로 콘솔에 간단히 출력합니다.





### @objc func BLEButton(_ sender: UIButton)

 - Description
 
    `BLEButton` 함수는 사용자가 `BLE(Bluetooth Low Energy)` 버튼을 클릭했을 때 호출되는 이벤트 핸들러입니다. 이 함수는 `ShowBluetoothModal`이라는 모달 뷰 컨트롤러를 생성하고 화면에 표시합니다. 모달 뷰가 닫힐 때, `dismissCompletion` 클로저가 설정되어 있으며, 이 클로저 내에서 `updatePeripheralData()` 메소드를 호출하여 주변장치 데이터를 업데이트하는 작업을 수행합니다. 또한, 주석 처리된 부분에서는 `BluetoothLEManager`를 통해 블루투스 스캔을 시작하는 코드가 포함되어 있음을 확인할 수 있습니다.

 - Parameters

    `sender`: 이벤트를 발생시킨 `UIButton` 객체입니다. 이는 사용자가 누른 버튼을 참조합니다.




### @objc func classic(_ sender: UIButton)

 - Description
 
    `classic` 함수는 사용자가 클래식 블루투스 버튼을 클릭했을 때 호출되는 이벤트 핸들러입니다. 이 함수는 `BluetoothClassicController`라는 뷰 컨트롤러를 생성하고, 이를 모달 형태로 화면에 표시합니다. 주석 처리된 코드 부분을 보면, 블루투스 스캐닝을 중지하는 `bluetoothManager.stopScanning()` 메소드 호출이 있음을 알 수 있습니다. 이는 클래식 블루투스 모드로 전환하기 전에 기존의 `BLE` 스캐닝을 중지할 수 있는 옵션을 제공합니다.

 - Parameters
 
    `sender`: 이벤트를 발생시킨 `UIButton` 객체입니다. 이는 사용자가 누른 버튼을 참조합니다.




### func touchUpScanButton()

 - Description
 
    `touchUpScanButton` 함수는 사용자 인터페이스에 버튼을 추가하고 설정합니다. 이 함수는 기본적인 시스템 스타일(`.system`)의 `UIButton`을 생성하고, "BLE"라는 제목을 설정합니다. 버튼의 배경색은 검정색으로, 제목 색상은 흰색으로 지정됩니다. 버튼의 위치와 크기는 `CGRect`를 사용하여 (x: 100, y: 100, width: 150, height: 50)로 설정됩니다. 이 버튼에는 `@selector(BLEButton)`를 사용하여 `BLEButton` 함수를 터치 이벤트(`.touchUpInside`)에 연결합니다. 이렇게 설정된 버튼은 뷰에 추가되어 사용자가 상호작용할 수 있습니다.





### func touchUpClassicButton()

 - Description
 
    `touchUpClassicButton` 함수는 사용자 인터페이스에 '클래식' 버튼을 추가하고 구성하는 역할을 합니다. 이 함수는 `.system` 스타일의 `UIButton`을 생성하고, 버튼의 제목을 "Classic"으로 설정합니다. 버튼의 배경색은 검정색이며, 제목의 색상은 흰색입니다. 버튼의 위치와 크기는 `CGRect`를 이용하여 (x: 100, y: 250, width: 150, height: 50)로 정의됩니다. 또한, `@selector(classic)`를 사용하여 `classic` 함수를 버튼의 터치 이벤트(`.touchUpInside`)에 연결합니다. 설정이 완료된 버튼은 뷰에 추가되어 사용자가 상호작용할 수 있습니다.





### sendData()

 - Description
 
    `sendData` 함수는 사용자 인터페이스에 데이터 전송을 위한 버튼을 추가하고 구성합니다. 이 함수는 `.system `스타일의 `UIButton`을 생성하고, 버튼의 제목을 "Cc"로 설정합니다. 버튼의 배경색은 검정색이며, 제목 색상은 흰색입니다. 버튼의 위치와 크기는 `CGRect`를 사용하여 (x: 100, y: 300, width: 50, height: 50)로 지정됩니다. 이 버튼에는 `@selector(updateData)`를 사용하여 `updateData` 함수를 터치 이벤트(`.touchUpInside`)에 연결합니다. 설정이 완료된 버튼은 뷰에 추가되어 사용자가 상호작용할 수 있습니다.




### private func setupLabels()

 - Description
 
    `setupLabels` 함수는 두 개의 `UILabel`, `nameLabel`과 `identifierLabel`을 초기화하고 레이아웃을 설정합니다. `nameLabel`은 빨간색 배경에 검정색 텍스트로 설정되며, `CGRect`를 사용하여 위치와 크기를 지정합니다 (x: 40, y: 400, width: 300, height: 30). `identifierLabel`은 초록색 배경에 검정색 텍스트로 설정되며, 위치와 크기는 `CGRect`를 사용하여 (x: 40, y: 440, width: 300, height: 30)로 설정됩니다. 두 레이블의 초기 텍스트는 빈 문자열("")로 설정됩니다. 이 레이블들은 뷰에 추가되어 화면에 표시됩니다. 함수의 마지막에는 "레이블 세팅"이라는 메시지가 콘솔에 출력됩니다.





### private func updatePeripheralData()

 - Description
 
    `updatePeripheralData` 함수는 연결된 블루투스 주변장치의 데이터를 업데이트하고, 이를 사용자 인터페이스에 반영합니다. 함수는 먼저 `BluetoothLEManager`의 `connectedPeripheral` 속성을 사용하여 주변장치의 이름과 식별번호를 콘솔에 출력합니다. 이때, 주변장치의 이름이나 식별번호가 없는 경우를 고려하여 옵셔널 체이닝과 `nil` 병합 연산자(??)를 사용하여 기본값을 제공합니다. 메인 스레드에서 비동기적으로 레이블(`nameLabel`과 `identifierLabel`)의 텍스트를 업데이트하여, 연결된 주변장치의 이름과 식별번호를 사용자 인터페이스에 표시합니다.




***




## ShowBluetoothModal

 - Description

    `ShowBluetoothModal` 클래스는 `UIViewController`를 상속받으며, `UITableViewDelegate` 및 `UITableViewDataSource` 프로토콜을 준수합니다. 이 클래스는 블루투스 장치 목록을 표시하는 테이블 뷰를 관리하는 역할을 합니다. `BluetoothLEManager.shared`를 사용하여 블루투스 관련 기능을 수행하며, `tableView` 변수를 통해 장치 목록을 표시합니다. `selectedIndex` 변수는 사용자가 선택한 테이블 뷰 셀의 인덱스를 저장하며, `dismissCompletion` 클로저는 화면이 닫힐 때 호출됩니다. 이 클로저를 통해 다른 뷰 컨트롤러와의 상호작용이나 필요한 작업을 처리할 수 있습니다.

    #### 주요 구성요소
    
        `let bluetoothManager`: 싱글턴 인스턴스 `BluetoothLEManager` 를 사용하기 위한 선언
        `var tableView`: 블루투스 장치 목록을 표기 하기 위한 테이블 뷰 선언
        `var selectedIndex`: 선택한 인덱스 번호를 저장하기 위한 변수선언
        `var dismissCompletion`: 화면이 dismiss 되었을때 호출될 클로저





### func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int

 - Description
 
    이 메소드는 `UITableViewDataSource` 프로토콜의 일부로서, 테이블 뷰의 특정 섹션에 표시될 행의 수를 결정합니다. `bluetoothManager.discoveredPeripherals.count`를 반환함으로써, `BluetoothLEManager`에 의해 발견된 주변장치들의 수만큼 행을 테이블 뷰에 생성하도록 지시합니다. 즉, 발견된 각 주변장치에 대해 테이블 뷰에 하나의 행이 할당됩니다.

 - Parameters
 
    `tableView`: 행의 수를 요청하는 `UITableView` 인스턴스입니다.
    `section`: 행의 수를 결정하려는 테이블 뷰의 섹션 인덱스입니다.





### func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

 - Description

    `cellForRowAt` 메소드는 `UITableViewDataSource` 프로토콜의 일부로서, 지정된 `indexPath`에 해당하는 테이블 뷰 셀을 생성하고 반환합니다. 이 메소드는 먼저 `dequeueReusableCell(withIdentifier:for:)` 메소드를 사용하여 재사용 가능한 셀을 가져옵니다. 셀의 식별자는 "BluetoothCell"로 지정됩니다. 그 후, `bluetoothManager.discoveredPeripherals` 배열에서 해당 `indexPath.row`에 위치한 주변장치를 가져와 셀에 표시합니다. 셀의 텍스트 레이블에는 주변장치의 이름이 표시되며, 이름이 없는 경우 식별자의 UUID 문자열이 표시됩니다. 마지막으로 구성된 셀을 반환합니다.

 - Parameters

    `tableView`: 셀을 요청하는 `UITableView` 인스턴스입니다.
    `indexPath`: 셀의 위치를 나타내는 `IndexPath` 객체입니다. `indexPath.row`는 테이블 뷰의 행 인덱스를 나타냅니다.






### func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)

 - Description

    `didSelectRowAt` 메소드는 사용자가 테이블 뷰의 특정 행을 선택했을 때 호출됩니다. 이 메소드는 `selectedIndex`를 사용자가 선택한 행의 인덱스(`indexPath.row`)로 설정하고, 이 인덱스를 콘솔에 출력합니다. 그 후, `bluetoothConnect` 클로저를 호출하여 선택된 주변장치에 연결을 시도합니다. 연결이 성공하면, 화면을 닫고(`dismiss(animated:completion:)`), `dismissCompletion` 클로저를 호출하여 추가 작업을 수행합니다. 연결에 실패한 경우, "연결오류" 메시지를 출력하고 함수를 종료합니다.

 - Parameters

    `tableView`: 행 선택 이벤트가 발생한 `UITableView` 인스턴스입니다.
    `indexPath`: 선택된 행의 위치를 나타내는 `IndexPath` 객체입니다. `indexPath.row`는 선택된 행의 인덱스를 나타냅니다.





### func bluetoothConnect(completion: @escaping (Bool) -> Void)

 - Description

    `bluetoothConnect` 함수는 선택된 블루투스 주변장치에 연결을 시도하는 기능을 수행합니다. 이 함수는 `selectedIndex`를 확인하여 현재 선택된 주변장치가 있는지 검사합니다. 선택된 장치가 없으면, `completion` 클로저에 `false`를 전달하고 함수를 종료합니다. 선택된 장치가 있으면, `bluetoothManager.discoveredPeripherals` 배열에서 해당 인덱스의 주변장치를 가져와 연결을 시도합니다. 연결 시도 전에 `bluetoothManager.completion` 프로퍼티에 `completion` 클로저를 설정하여, 연결 결과가 나타나면 적절한 처리를 할 수 있도록 합니다. 연결의 성공 또는 실패는 `CBCentralManagerDelegate`의 메서드에서 처리되며, 해당 메서드에서 `completion` 클로저가 호출됩니다.

 - Parameters

    `completion`: 연결의 성공 여부를 나타내는 `Bool` 값을 전달하는 클로저입니다. 연결이 성공하면 `true`, 실패하면 `false`를 반환합니다.


