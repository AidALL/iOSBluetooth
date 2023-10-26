# iOSBluetooth


## Studying How to Use Bluetooth in iOS
 
- 2023/10/23    corebluetooth 프레임워크를 이용한 bluetooth 사용 프로젝트 시작\r
- 2023/10/25    corebluetooth 프레임워크만으로는 너무 제한적이라 ExternalAccessory 프레임워크도 병행해서 사용하려 했으나 ExternalAccessory 프레임워크도 MFi인증이 되어있는 기기를 사용해야 해서 제한적인것은 마찬가지\r
                파일 이름 변경했다가 꼬여서 pull 해서 다시 받음 뭔가가 이상해진거 같은데 해결법을 모르겠음... 파일경로가 바뀌면 메소드가 상속을 받지 못한다\r
                BLE로 블루투스 연결을 하긴 했는데 실제로 구현할 기능을 위해서는 실제 블루투스 모듈을 받아와야 가능할거 같다.\r
- 2023/10/26    BLE통신으로 받아온 데이터를 모달창이 닫히면서 Label에 정보를 나타내는 기능 구현이 didSet, viewWillApear에서 문제가 생겨서 클로저를 구현해서 정상적으로 작동되는것을 확인\r
                peripheral 함수 didDiscoverServices callback이 안불러지는 현상 발견해서 해결함 if문을 잘못 설정해서 탈출해버린게 문제였던듯?\r
                
 
#### - This Project was Tested on iPhone 12 Pro
