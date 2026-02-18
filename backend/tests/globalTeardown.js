const { MongoMemoryServer } = require('mongodb-memory-server');
const fs = require('fs');
const path = require('path');

module.exports = async () => {
    const uriFile = path.join(__dirname, '..', '.jest_mongo_uri');
    if (fs.existsSync(uriFile)) {
        fs.unlinkSync(uriFile);
    }
    if (global.__MONGOD__) {
        await global.__MONGOD__.stop();
    }
};
