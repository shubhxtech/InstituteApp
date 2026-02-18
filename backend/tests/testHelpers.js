/**
 * Shared test helpers for database setup/teardown.
 * Each test file imports this to get a consistent connection strategy.
 * 
 * IMPORTANT: This file also sets up environment variables needed for testing.
 * Since Jest's globalSetup runs in a separate process, env vars set there
 * don't propagate to test workers. We read the URI from a temp file instead.
 */
const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');

// ─── Environment Setup ────────────────────────────────────────────────────────
// Read MongoDB URI from the file written by globalSetup
const uriFile = path.join(__dirname, '..', '.jest_mongo_uri');
if (fs.existsSync(uriFile)) {
    process.env.MONGO_URI = fs.readFileSync(uriFile, 'utf8').trim();
}

// Set JWT secret for test environment
if (!process.env.JWT_SECRET) {
    process.env.JWT_SECRET = 'test_jwt_secret_key_for_testing_only';
}
process.env.NODE_ENV = 'test';

// ─── Database Helpers ─────────────────────────────────────────────────────────

/**
 * Connect to the in-memory MongoDB (set by globalSetup).
 * Safe to call multiple times — mongoose handles duplicate connections.
 */
const connectTestDB = async () => {
    if (mongoose.connection.readyState === 0) {
        await mongoose.connect(process.env.MONGO_URI);
    }
};

/**
 * Delete all documents from specific collections.
 * Safer than dropDatabase — doesn't break the connection.
 * @param {...string} collectionNames
 */
const clearCollections = async (...collectionNames) => {
    for (const name of collectionNames) {
        try {
            await mongoose.connection.collection(name).deleteMany({});
        } catch (e) {
            // Collection may not exist yet — that's fine
        }
    }
};

module.exports = { connectTestDB, clearCollections };
