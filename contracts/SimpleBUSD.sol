pragma solidity 0.4.24;

import "chainlink/contracts/ChainlinkClient.sol";

//docs -  https://docs.chain.link/docs/request-and-receive-data

contract SimpleBUSD is ChainlinkClient {

    mapping (address => uint) depositAmounts;
    mapping (address => uint) liquidationPrices;
    uint256 currentPrice = 100;
    uint256 chainlinkPrice = 80;
    address public owner;

    address public chainlinkOracleAddres = 0xA3Ce768F041d136E8d57fD24372E5fB510b797ec;
    bytes32 public chainlinkHttpGetJobId = "96bf1a27492142b095a8ada21631ebd0";
    uint256 public chainlinkTestPayment = 1;

    event DepositEvent(address account, uint amount);

    constructor() public {
        setChainlinkToken(tx.origin);
        // setPublicChainlinkToken();
    }
    // constructor(address _link) public {
    //     // Set the address for the LINK token for the network.
    //     if(_link == address(0)) {
    //     // Useful for deploying to public networks.
    //     setPublicChainlinkToken();
    //     } else {
    //     // Useful if you're deploying to a local network.
    //     setChainlinkToken(_link);
    //     }
    // }

    
    function deposit(uint256 amount) public {
        depositAmounts[msg.sender] += amount;
        liquidationPrices[msg.sender] = currentPrice / uint256(2);
        emit DepositEvent(msg.sender, amount);
    }

    function liquided(address addr) public view returns(bool liquidated) {
        return liquidationPrices[addr] > chainlinkPrice;
    }

    function getDepositAmount(address addr) public view returns(uint256) {
        return depositAmounts[addr];
    }

    function getLiquidationPrice(address addr) public view returns(uint256) {
        return liquidationPrices[addr];
    }

    function getVersion() public view returns(uint256) {
        return 1;
    }
    /**
    ** Start Chainlink Funcitons
    */

    // Creates a Chainlink request with the uint256 multiplier job
    function requestEthereumPrice() 
        public
        onlyOwner
    {
        requestEthereumPrice(chainlinkOracleAddres, chainlinkHttpGetJobId, chainlinkTestPayment);
    }

    // Creates a Chainlink request with the uint256 multiplier job
    function requestEthereumPrice(address _oracle, bytes32 _jobId, uint256 _payment) 
        public
        onlyOwner
    {
        // newRequest takes a JobID, a callback address, and callback function as input
        Chainlink.Request memory req = buildChainlinkRequest(_jobId, this, this.fulfill.selector);
        // Adds a URL with the key "get" to the request parameters
        req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD");
        // Uses input param (dot-delimited string) as the "path" in the request parameters
        req.add("path", "USD");
        // Adds an integer with the key "times" to the request parameters
        req.addInt("times", 100);
        // Sends the request with the amount of payment specified to the oracle
        sendChainlinkRequestTo(_oracle, req, _payment);
    }

    // fulfill receives a uint256 data type
    function fulfill(bytes32 _requestId, uint256 _price)
        public
        // Use recordChainlinkFulfillment to ensure only the requesting oracle can fulfill
        recordChainlinkFulfillment(_requestId)
    {
        currentPrice = _price;
    }
    
    // withdrawLink allows the owner to withdraw any extra LINK on the contract
    function withdrawLink()
        public
        onlyOwner
    {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}