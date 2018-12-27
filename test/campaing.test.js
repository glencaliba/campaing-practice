const assert = require( 'assert');
const ganache = require( 'ganache-cli');
const Web3 = require ('web3');
const web3 = new Web3( ganache.provider());
const {interface, bytecode } = require('../compile');

let accounts; 
let campaing;



beforeEach( async()=> {
   //Get a list  of all accounts 
   accounts = await web3.eth.getAccounts();

   //Use one of those account to deploy
   // the contract
   campaing = await new web3.eth.Contract(JSON.parse( interface))
    .deploy(
        {data:bytecode,arguments:[300]})
    .send({ gas: '500000' , from: accounts[0] });
});


