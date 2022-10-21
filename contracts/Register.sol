// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Register {
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
}
