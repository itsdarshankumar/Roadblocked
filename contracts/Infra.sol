// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./Ride.sol";

contract Infra {
    //// define roles ////
    enum roles {
        rider,
        driver
    }

    //// define current status ////
    enum currentStatus {
        free,
        busy
    }
    //// Inits ////
    bytes32 constant NULL = "";
    address[] driversArray;
    //// define rider struct ////
    struct riderStruct {
        bytes32 name;
        bytes32 contact;
        bytes32 email;
        roles role;
        address payable riderAddr;
        address[] rides;
    }
    //// define driver struct ////
    struct driverStruct {
        bytes32 name;
        bytes32 contact;
        bytes32 email;
        bytes32 carNo;
        roles role;
        currentStatus status;
        address payable driverAddr;
        address[] rides;
    }

    //// Events ////
    event RiderRegister(address indexed _address, bytes32 name);
    event DriverRegister(address indexed _address, bytes32 name);
    event requestDriverEvent(
        address payable _riderAddr,
        address payable _driverAddr,
        address rideAddr
    );

    //// Constructor ////
    constructor() {}

    //// Modifiers ////
    modifier onlyRider(address payable _riderAddr) {
        require(_riderAddr == msg.sender, "Cannot register rider");
        _;
    }
    modifier onlyDriver(address payable _driverAddr) {
        require(_driverAddr == msg.sender, "Cannot register driver");
        _;
    }

    //// Mappings ////
    mapping(address => riderStruct) public ridersMapping;
    mapping(address => driverStruct) public driversMapping;

    //// Register Rider ////
    function registerRider(
        bytes32 _name,
        bytes32 _contact,
        bytes32 _email,
        uint _role,
        address payable _riderAddr
    ) external onlyRider(_riderAddr) {
        ridersMapping[_riderAddr].name = _name;
        ridersMapping[_riderAddr].contact = _contact;
        ridersMapping[_riderAddr].email = _email;
        ridersMapping[_riderAddr].role = roles(_role);
        ridersMapping[_riderAddr].riderAddr = _riderAddr;

        emit RiderRegister(_riderAddr, _name);
    }

    //// Register Driver ////
    function registerDriver(
        bytes32 _name,
        bytes32 _contact,
        bytes32 _email,
        bytes32 _carNo,
        uint _role,
        address payable _driverAddr
    ) external onlyDriver(_driverAddr) {
        driversMapping[_driverAddr].name = _name;
        driversMapping[_driverAddr].contact = _contact;
        driversMapping[_driverAddr].email = _email;
        driversMapping[_driverAddr].carNo = _carNo;
        driversMapping[_driverAddr].status = currentStatus(0);
        driversMapping[_driverAddr].role = roles(_role);
        driversMapping[_driverAddr].driverAddr = _driverAddr;

        emit DriverRegister(_driverAddr, _name);
    }

    function getRiderInfo(address payable _riderAddr)
        external
        view
        returns (riderStruct memory _riderStruct)
    {
        return ridersMapping[_riderAddr];
    }

    function cancelRide(address payable _riderAddr) public returns (bool) {
        uint len = ridersMapping[_riderAddr].rides.length;
        delete ridersMapping[_riderAddr].rides[len - 1];
        return true;
    }

    function getDriverInfo(address payable _driverAddr)
        external
        view
        returns (driverStruct memory _driverStruct)
    {
        return driversMapping[_driverAddr];
    }

    function updateDriverStatus(address payable _driverAddr, uint _status)
        external
    {
        driversMapping[_driverAddr].status = currentStatus(_status);
    }

    function updateRideInformation(address _driverAddr, address _rideAddr)
        external
    {
        ridersMapping[_driverAddr].rides.push(_rideAddr);
    }

    function requestRide(
        address payable _riderAddr,
        string[] memory _fromAddr,
        string[] memory _toAddr,
        bytes32 _amount
    ) public returns (address) {
        Ride ride = new Ride(
            _riderAddr,
            payable(address(0)),
            _fromAddr,
            _toAddr,
            _amount
        );
        ridersMapping[_riderAddr].rides.push(address(ride));

        return address(ride);
    }

    function returnDriversAvailable() external view returns (address[] memory) {
        return driversArray;
    }

    function requestDriver(
        address payable _riderAddr,
        address payable _driverAddr,
        address _rideAddr
    ) external {
        emit requestDriverEvent(_riderAddr, _driverAddr, _rideAddr);
    }
}
