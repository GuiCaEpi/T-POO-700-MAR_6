const { defineConfig } = require('@vue/cli-service')
module.exports = {
  devServer: {
    host: '0.0.0.0', // Allow binding to all IPs
    port: 8081,
    allowedHosts: 'all', // Allow all hosts to connect
  },
};