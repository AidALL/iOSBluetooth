# iOSBluetooth


## Studying How to Use Bluetooth in iOS
 
- 2023/10/23    corebluetooth 프레임워크를 이용한 bluetooth 사용 프로젝트 시작<br/>
- 2023/10/25    corebluetooth 프레임워크만으로는 너무 제한적이라 ExternalAccessory 프레임워크도 병행해서 사용하려 했으나 ExternalAccessory 프레임워크도 MFi인증이 되어있는 기기를 사용해야 해서 제한적인것은 마찬가지<br/>
                파일 이름 변경했다가 꼬여서 pull 해서 다시 받음 뭔가가 이상해진거 같은데 해결법을 모르겠음... 파일경로가 바뀌면 메소드가 상속을 받지 못한다<br/>
                BLE로 블루투스 연결을 하긴 했는데 실제로 구현할 기능을 위해서는 실제 블루투스 모듈을 받아와야 가능할거 같다.<br/>
- 2023/10/26    BLE통신으로 받아온 데이터를 모달창이 닫히면서 Label에 정보를 나타내는 기능 구현이 didSet, viewWillApear에서 문제가 생겨서 클로저를 구현해서 정상적으로 작동되는것을 확인<br/>
                peripheral 함수 didDiscoverServices callback이 안불러지는 현상 발견해서 해결함 if문을 잘못 설정해서 탈출해버린게 문제였던듯?<br/>
- 2023/10/27    통신으로 통해 특성값에 정보를 보내기 직전까지 작업을 하였으나 막상 수신할만한 기기의 부재로 일단 작업 일시정지. 현재 jetson을 통한 BLE 통신관련 디벨롭을 진행하면서 다시 코드 작성예정<br/>
 
#### - This Project was Tested on iPhone 12 Pro
