// pragma solidity >=0.4.25 <0.6.0;
pragma solidity 0.4.24;

contract SimpleStorage {

    uint storedData;
    event SetEvent(uint x);

    constructor() public {
		storedData = 1;
	}

    
    function set(uint x) public {
        storedData = x;
        emit SetEvent(x);
    }
    function get() public view returns (uint retVal) {
        return storedData;
    }
}