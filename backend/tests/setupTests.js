/**
 * setupTests.js - Runs in each test worker BEFORE tests start.
 * Sets environment variables from the project-local file written by globalSetup.
 */
const fs = require('fs');
const path = require('path');

const uriFile = path.join(__dirname, '..', '.jest_mongo_uri');
if (fs.existsSync(uriFile)) {
    process.env.MONGO_URI = fs.readFileSync(uriFile, 'utf8').trim();
} else {
    console.warn('[setupTests] WARNING: .jest_mongo_uri not found at', uriFile);
}

// Set test JWT secret and environment
process.env.JWT_SECRET = 'test_jwt_secret_key_for_testing_only';
process.env.NODE_ENV = 'test';

console.log('[setupTests] MONGO_URI:', process.env.MONGO_URI ? 'SET' : 'MISSING');
console.log('[setupTests] JWT_SECRET:', process.env.JWT_SECRET ? 'SET' : 'MISSING');
