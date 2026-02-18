const request = require('supertest');
const mongoose = require('mongoose');
const { connectTestDB, clearCollections } = require('./testHelpers');
const app = require('../app');

const REPORTER = { name: 'Reporter', email: 'reporter@iitmandi.ac.in', password: 'Pass123!' };
const OTHER = { name: 'Other', email: 'other2@iitmandi.ac.in', password: 'Pass123!' };

let reporterToken = '';
let otherToken = '';
let itemId = '';

beforeAll(async () => {
    await connectTestDB();

    await request(app).post('/api/auth/register').send(REPORTER);
    const r1 = await request(app).post('/api/auth/login').send({ email: REPORTER.email, password: REPORTER.password });
    reporterToken = r1.body.token;

    await request(app).post('/api/auth/register').send(OTHER);
    const r2 = await request(app).post('/api/auth/login').send({ email: OTHER.email, password: OTHER.password });
    otherToken = r2.body.token;
});

afterAll(async () => {
    await clearCollections('users', 'lostfounditems');
});

const VALID_ITEM = {
    name: 'Lost Wallet',
    description: 'Black leather wallet, lost near library',
    lostOrFound: 'Lost',
    from: REPORTER.email,
    phoneNo: '9876543210',
};

// ─── GET ALL ─────────────────────────────────────────────────────────────────
describe('GET /api/lost-found', () => {
    it('should return list publicly', async () => {
        const res = await request(app).get('/api/lost-found');
        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);
    });
});

// ─── CREATE ──────────────────────────────────────────────────────────────────
describe('POST /api/lost-found', () => {
    it('should create item when authenticated', async () => {
        const res = await request(app)
            .post('/api/lost-found')
            .set('Authorization', `Bearer ${reporterToken}`)
            .send(VALID_ITEM);
        expect(res.statusCode).toBe(201);
        expect(res.body.name).toBe(VALID_ITEM.name);
        itemId = res.body._id;
    });

    it('should reject unauthenticated create', async () => {
        const res = await request(app).post('/api/lost-found').send(VALID_ITEM);
        expect(res.statusCode).toBe(401);
    });

    it('should reject missing required fields', async () => {
        const res = await request(app)
            .post('/api/lost-found')
            .set('Authorization', `Bearer ${reporterToken}`)
            .send({ name: 'Incomplete' });
        expect(res.statusCode).toBe(400);
    });
});

// ─── UPDATE ──────────────────────────────────────────────────────────────────
describe('PUT /api/lost-found/:id', () => {
    it('should allow authenticated user to update', async () => {
        const res = await request(app)
            .put(`/api/lost-found/${itemId}`)
            .set('Authorization', `Bearer ${reporterToken}`)
            .send({ name: 'Updated Wallet' });
        expect(res.statusCode).toBe(200);
        expect(res.body.name).toBe('Updated Wallet');
    });

    it('should reject unauthenticated update', async () => {
        const res = await request(app)
            .put(`/api/lost-found/${itemId}`)
            .send({ name: 'Hacked' });
        expect(res.statusCode).toBe(401);
    });

    it('should return 404 for non-existent item', async () => {
        const fakeId = new mongoose.Types.ObjectId();
        const res = await request(app)
            .put(`/api/lost-found/${fakeId}`)
            .set('Authorization', `Bearer ${reporterToken}`)
            .send({ name: 'Ghost' });
        expect(res.statusCode).toBe(404);
    });
});

// ─── DELETE ──────────────────────────────────────────────────────────────────
describe('DELETE /api/lost-found/:id', () => {
    it('should allow authenticated user to delete', async () => {
        const res = await request(app)
            .delete(`/api/lost-found/${itemId}`)
            .set('Authorization', `Bearer ${reporterToken}`);
        expect(res.statusCode).toBe(200);
    });

    it('should return 404 for already-deleted item', async () => {
        const res = await request(app)
            .delete(`/api/lost-found/${itemId}`)
            .set('Authorization', `Bearer ${reporterToken}`);
        expect(res.statusCode).toBe(404);
    });
});
