const SimpleStorage = artifacts.require("SimpleStorage");

contract('SimpleStorage', (accounts) => {
    it('should get 1', async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();
        const value = await simpleStorageInstance.get.call();
    
        assert.equal(value.valueOf(), 1, "get is not 1");
    });
    it('should get 7', async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();
        const setResult = await simpleStorageInstance.set(7)
        // console.log(setResult)
        const value = await simpleStorageInstance.get.call();
    
        assert.equal(value.valueOf(), 7, "get is not 7");
    }); 
});