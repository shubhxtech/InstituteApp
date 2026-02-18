const { MongoMemoryServer } = require('mongodb-memory-server');
const fs = require('fs');
const path = require('path');

module.exports = async () => {
    const mongod = await MongoMemoryServer.create();
    const uri = mongod.getUri();

    // Write URI to project-local file so test workers can read it
    // (globalSetup runs in a separate process; env vars don't propagate)
    const uriFile = path.join(__dirname, '..', '.jest_mongo_uri');
    fs.writeFileSync(uriFile, uri, 'utf8');

    global.__MONGOD__ = mongod;
};
