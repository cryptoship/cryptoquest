const path = require('path');
const fs = require('fs');
const solc = require('solc');

const inboxPath = path.resolve(__dirname, 'contracts', 'CryptoQuest.sol');

const source = fs.readFileSync(inboxPath, 'utf8');

const solcOutputs = solc.compile(source, 1);

if (solcOutputs && solcOutputs.errors) {
    var errors = [];
    for (var i = 0; i < solcOutputs.errors.length; i++) {
        if (solcOutputs.errors[i].includes(': Warning:')) {
            continue;
        }        
        errors.push(solcOutputs.errors[i]);
    }
    if (errors.length > 0) {
        console.log("Compile failed");
        for (var j = 0; j < errors.length; j++) {
            console.log(errors[j]);
        }
        process.exit(-1);
    }
}

module.exports = solcOutputs.contracts[':CryptoQuest'];