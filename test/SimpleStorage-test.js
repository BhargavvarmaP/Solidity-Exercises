const {expect} = require('chai');
const {ethers} = require("hardhat");

describe("SimpleStorage",function () {
    before(async function () {
        SimpleStorage = await ethers.getContractFactory("SimpleStorage");
        simplestorage = await SimpleStorage.deploy();
        await simplestorage.deployed();
    });
        
    beforeEach(async function() {
        await simplestorage.setdata(25);
    });
    
    it("Retrieves Info",async function () { 
        expect((await simplestorage.getdata()).toString()).to.equal("25");
    });
    
    it("Should have set and return number",async function() {
        await simplestorage.setdata(80);
        expect((await simplestorage.getdata()).toString()).to.equal("80");
    });

});