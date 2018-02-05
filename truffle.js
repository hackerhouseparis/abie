module.exports = {
  networks: {
    development: {
      gas: 2900000,
      host: "localhost",
      port: 9545,
      network_id: "*", // Match any network id
    },
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      } 
    }
  }
};
