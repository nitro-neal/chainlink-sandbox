const SimpleBUSD = artifacts.require("SimpleBUSD");

contract('SimpleBUSD', (accounts) => {
    it('test simpolebusd', async () => {
        const simpleBUSDInstance = await SimpleBUSD.deployed();

        // Setup 2 accounts.
        const accountOne = accounts[0];
        const accountTwo = accounts[1];


        const amount = 1;
        await simpleBUSDInstance.deposit(amount, { from: accountOne });

        const liquidated = await simpleBUSDInstance.liquided.call(accountOne);
        const depositAmount = (await simpleBUSDInstance.getDepositAmount.call(accountOne)).toNumber();
        const liquidatePrice = (await simpleBUSDInstance.getLiquidationPrice.call(accountOne)).toNumber();

        console.log('~~~~~~~~~~~ ! OUTPUT !')
        console.log(liquidated);
        console.log(depositAmount);
        console.log(liquidatePrice);

        
        // function requestEthereumPrice(address _oracle, bytes32 _jobId, uint256 _payment) 
        // (await simpleBUSDInstance.requestEthereumPrice("0xA3Ce768F041d136E8d57fD24372E5fB510b797ec"))
        //await simpleBUSDInstance.requestEthereumPrice();
        assert.equal(liquidated.valueOf(), false, "Liquidated at wrong time");
    });
});