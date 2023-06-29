/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');

const { projectId, mnemonic } = require('./secret.json');

module.exports = {
    solidity:{
       version: "0.6.12",
       settings: {          
            optimizer: {
              enabled: true,
              runs: 200
            },
            evmVersion: "byzantium"
       }
    },
    networks: {
        mainnet: {
          url: `https://mainnet.infura.io/v3/${projectId}`,
          accounts: {mnemonic: mnemonic},
          network_id: 1,
        },
        rinkeby: {
            url: `https://rinkeby.infura.io/v3/${projectId}`,
            accounts: {mnemonic: mnemonic},
            network_id: 4
        },
        loot: {
            url: `https://loot-mainnet.calderachain.xyz/http`,
            accounts: {mnemonic: mnemonic},
            network_id: 5151706
        },
        loottest: {
            url: `https://loot.calderachain.xyz/http`,
            accounts: {mnemonic: mnemonic},
            network_id: 9088912
        }
  },
};
