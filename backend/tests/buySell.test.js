const request = require('supertest');
const mongoose = require('mongoose');
const { connectTestDB, clearCollections } = require('./testHelpers');
const app = require('../app');

const SELLER = { name: 'Seller User', email: 'seller@iitmandi.ac.in', password: 'Pass123!' };
const OTHER = { name: 'Other User', email: 'other@iitmandi.ac.in', password: 'Pass123!' };

let sellerToken = '';
let otherToken = '';
let itemId = '';

beforeAll(async () => {
    await connectTestDB();

    // Register and login seller
    await request(app).post('/api/auth/register').send(SELLER);
    const r1 = await request(app).post('/api/auth/login').send({ email: SELLER.email, password: SELLER.password });
    sellerToken = r1.body.token;

    // Register and login other user
    await request(app).post('/api/auth/register').send(OTHER);
    const r2 = await request(app).post('/api/auth/login').send({ email: OTHER.email, password: OTHER.password });
    otherToken = r2.body.token;
});

afterAll(async () => {
    await clearCollections('users', 'buysellitems');
});

const VALID_ITEM = {
    name: 'Old Laptop',
    productDescription: 'Works fine, selling cheap',
    soldBy: SELLER.email,
    maxPrice: 15000,
    minPrice: 10000,
    phoneNo: '9876543210',
};

// ─── GET ALL ─────────────────────────────────────────────────────────────────
describe('GET /api/buy-sell', () => {
    it('should return empty list publicly (no auth needed)', async () => {
        const res = await request(app).get('/api/buy-sell');
        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);
    });
});

// ─── CREATE ──────────────────────────────────────────────────────────────────
describe('POST /api/buy-sell', () => {
    it('should create a listing when authenticated', async () => {
        const res = await request(app)
            .post('/api/buy-sell')
            .set('Authorization', `Bearer ${sellerToken}`)
            .send(VALID_ITEM);
        expect(res.statusCode).toBe(201);
        expect(res.body.name).toBe(VALID_ITEM.name);
        itemId = res.body._id;
    });

    it('should reject unauthenticated create', async () => {
        const res = await request(app).post('/api/buy-sell').send(VALID_ITEM);
        expect(res.statusCode).toBe(401);
    });

    it('should reject missing required fields', async () => {
        const res = await request(app)
            .post('/api/buy-sell')
            .set('Authorization', `Bearer ${sellerToken}`)
            .send({ name: 'Incomplete Item' });
        expect(res.statusCode).toBe(400);
    });
});

// ─── UPDATE ──────────────────────────────────────────────────────────────────
describe('PUT /api/buy-sell/:id', () => {
    it('should allow owner to update their listing', async () => {
        const res = await request(app)
            .put(`/api/buy-sell/${itemId}`)
            .set('Authorization', `Bearer ${sellerToken}`)
            .send({ name: 'Updated Laptop' });
        expect(res.statusCode).toBe(200);
        expect(res.body.name).toBe('Updated Laptop');
    });

    it('should reject update by non-owner (403)', async () => {
        const res = await request(app)
            .put(`/api/buy-sell/${itemId}`)
            .set('Authorization', `Bearer ${otherToken}`)
            .send({ name: 'Hacked Name' });
        expect(res.statusCode).toBe(403);
    });

    it('should return 404 for non-existent item', async () => {
        const fakeId = new mongoose.Types.ObjectId();
        const res = await request(app)
            .put(`/api/buy-sell/${fakeId}`)
            .set('Authorization', `Bearer ${sellerToken}`)
            .send({ name: 'Ghost' });
        expect(res.statusCode).toBe(404);
    });
});

// ─── DELETE ──────────────────────────────────────────────────────────────────
describe('DELETE /api/buy-sell/:id', () => {
    it('should reject delete by non-owner (403)', async () => {
        const res = await request(app)
            .delete(`/api/buy-sell/${itemId}`)
            .set('Authorization', `Bearer ${otherToken}`);
        expect(res.statusCode).toBe(403);
    });

    it('should allow owner to delete their listing', async () => {
        const res = await request(app)
            .delete(`/api/buy-sell/${itemId}`)
            .set('Authorization', `Bearer ${sellerToken}`);
        expect(res.statusCode).toBe(200);
        expect(res.body.id).toBe(itemId);
    });

    it('should return 404 for already-deleted item', async () => {
        const res = await request(app)
            .delete(`/api/buy-sell/${itemId}`)
            .set('Authorization', `Bearer ${sellerToken}`);
        expect(res.statusCode).toBe(404);
    });
});
