import Web3 from 'web3';

let web3;

// const web3 = new Web3(window.web3.currentProvider);
if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  //We are in the browser and metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  // we are on the browser or the usier in not running meta mask
  // const provider = new Web3.providers.HttpProvider('https://rinkeby.infura.io/2RpzfS8Dgjn0Naimu4Os');
  // web3 = new Web3(provider);
}

export default web3;
