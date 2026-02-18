const request = require('supertest');
const mongoose = require('mongoose');
const { connectTestDB, clearCollections } = require('./testHelpers');
const User = require('../models/User');
const bcrypt = require('bcrypt');
const app = require('../app');

const ADMIN_USER = { name: 'Admin', email: 'admin@iitmandi.ac.in', password: 'AdminPass123!' };
const NORMAL_USER = { name: 'Student', email: 'student@iitmandi.ac.in', password: 'Pass123!' };

let adminToken = '';
let normalToken = '';
let buySellItemId = '';
let lostFoundItemId = '';

beforeAll(async () => {
    await connectTestDB();

    // Create admin directly in DB (role: 'admin' cannot be set via register endpoint)
    const salt = await bcrypt.genSalt(10);
    await User.create({
        name: ADMIN_USER.name,
        email: ADMIN_USER.email,
        password: await bcrypt.hash(ADMIN_USER.password, salt),
        role: 'admin',
    });
    const r1 = await request(app).post('/api/auth/login').send({ email: ADMIN_USER.email, password: ADMIN_USER.password });
    adminToken = r1.body.token;

    // Register normal user
    await request(app).post('/api/auth/register').send(NORMAL_USER);
    const r2 = await request(app).post('/api/auth/login').send({ email: NORMAL_USER.email, password: NORMAL_USER.password });
    normalToken = r2.body.token;

    // Create a buy-sell item and lost-found item as normal user
    const bs = await request(app)
        .post('/api/buy-sell')
        .set('Authorization', `Bearer ${normalToken}`)
        .send({ name: 'Test Item', productDescription: 'Desc', soldBy: NORMAL_USER.email, maxPrice: 100, minPrice: 50, phoneNo: '1234567890' });
    buySellItemId = bs.body._id;

    const lf = await request(app)
        .post('/api/lost-found')
        .set('Authorization', `Bearer ${normalToken}`)
        .send({ name: 'Lost Keys', description: 'Car keys', lostOrFound: 'Lost', from: NORMAL_USER.email, phoneNo: '1234567890' });
    lostFoundItemId = lf.body._id;
});

afterAll(async () => {
    await clearCollections('users', 'buysellitems', 'lostfounditems', 'carouselimages', 'notifications');
});

// ─── ADMIN ROUTE ACCESS CONTROL ──────────────────────────────────────────────
describe('Admin route access control', () => {
    it('should reject unauthenticated access to admin content routes (401)', async () => {
        const res = await request(app).get('/api/admin/content/buy-sell');
        expect(res.statusCode).toBe(401);
    });

    it('should reject normal user from admin content routes (403)', async () => {
        const res = await request(app)
            .get('/api/admin/content/buy-sell')
            .set('Authorization', `Bearer ${normalToken}`);
        expect(res.statusCode).toBe(403);
    });

    it('should allow admin to access admin content routes (200)', async () => {
        const res = await request(app)
            .get('/api/admin/content/buy-sell')
            .set('Authorization', `Bearer ${adminToken}`);
        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('items');
    });
});

// ─── ADMIN CONTENT MODERATION ────────────────────────────────────────────────
describe('Admin content moderation', () => {
    it('admin can delete any buy-sell listing', async () => {
        const res = await request(app)
            .delete(`/api/admin/content/buy-sell/${buySellItemId}`)
            .set('Authorization', `Bearer ${adminToken}`);
        expect(res.statusCode).toBe(200);
    });

    it('admin can delete any lost-found item', async () => {
        const res = await request(app)
            .delete(`/api/admin/content/lost-found/${lostFoundItemId}`)
            .set('Authorization', `Bearer ${adminToken}`);
        expect(res.statusCode).toBe(200);
    });

    it('normal user cannot delete via admin content route (403)', async () => {
        // Create a fresh item to try deleting
        const bs = await request(app)
            .post('/api/buy-sell')
            .set('Authorization', `Bearer ${normalToken}`)
            .send({ name: 'Another Item', productDescription: 'Desc', soldBy: NORMAL_USER.email, maxPrice: 100, minPrice: 50, phoneNo: '1234567890' });
        const newId = bs.body._id;

        const res = await request(app)
            .delete(`/api/admin/content/buy-sell/${newId}`)
            .set('Authorization', `Bearer ${normalToken}`);
        expect(res.statusCode).toBe(403);
    });
});

// ─── ADMIN CAROUSEL MANAGEMENT ───────────────────────────────────────────────
describe('Admin carousel management', () => {
    it('GET carousel images is public (no auth required)', async () => {
        const res = await request(app).get('/api/admin/carousel');
        expect(res.statusCode).toBe(200);
    });

    it('normal user cannot POST to carousel admin route (403)', async () => {
        const res = await request(app)
            .post('/api/admin/carousel')
            .set('Authorization', `Bearer ${normalToken}`)
            .send({ title: 'Test', imageUrl: 'http://test.com/img.jpg', order: 1 });
        expect(res.statusCode).toBe(403);
    });

    it('admin can POST to carousel admin route (201)', async () => {
        const res = await request(app)
            .post('/api/admin/carousel')
            .set('Authorization', `Bearer ${adminToken}`)
            .send({ title: 'Test Slide', imageUrl: 'http://test.com/img.jpg', order: 1 });
        expect(res.statusCode).toBe(201);
    });
});

// ─── ADMIN MESS MENU ─────────────────────────────────────────────────────────
describe('Admin mess menu management', () => {
    it('GET mess menu is public (no auth required)', async () => {
        const res = await request(app).get('/api/admin/mess-menu');
        expect(res.statusCode).toBe(200);
    });

    it('admin can GET mess menu', async () => {
        const res = await request(app)
            .get('/api/admin/mess-menu')
            .set('Authorization', `Bearer ${adminToken}`);
        expect(res.statusCode).toBe(200);
    });

    it('normal user cannot bulk-update mess menu (403)', async () => {
        const res = await request(app)
            .post('/api/admin/mess-menu/bulk')
            .set('Authorization', `Bearer ${normalToken}`)
            .send([]);
        expect(res.statusCode).toBe(403);
    });
});
// ─── NOTIFICATION SECURITY ───────────────────────────────────────────────────
describe('Notification security', () => {
    it('GET notifications is public (200)', async () => {
        const res = await request(app).get('/api/notifications');
        expect(res.statusCode).toBe(200);
    });

    it('normal user cannot POST notifications (403)', async () => {
        const res = await request(app)
            .post('/api/notifications')
            .set('Authorization', `Bearer ${normalToken}`)
            .send({ title: 'Hack', description: 'Unauthorized', by: 'Student' });
        expect(res.statusCode).toBe(403);
    });

    it('admin can POST notifications (201)', async () => {
        const res = await request(app)
            .post('/api/notifications')
            .set('Authorization', `Bearer ${adminToken}`)
            .send({ title: 'Maintenance', description: 'Server down at 2AM', by: 'Admin' });
        expect(res.statusCode).toBe(201);
        expect(res.body).toHaveProperty('title', 'Maintenance');
    });
});
