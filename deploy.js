const HDWalletProvider = require( 'truffle-hdwallet-provider');
const Web3 = require( 'web3');
const {interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
    'royal shed record goose genuine napkin vault work execute doctor balance spoon',
    'https://rinkeby.infura.io/v3/5658e6e4e08f4ac78ff9490a30ca1e4b'
);
const web3 = new Web3(provider );

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log( 'Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract( JSON.parse( interface))
    .deploy({data:bytecode,arguments:[ 30 ]})
    .send({ gas: '500000', from: accounts[0] });

    console.log( 'Contract deployed to ', result.options.address );

};

deploy();