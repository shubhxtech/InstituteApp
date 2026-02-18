const request = require('supertest');
const { connectTestDB, clearCollections } = require('./testHelpers');
const app = require('../app');

const TEST_USER = {
    name: 'Test Student',
    email: 'test@iitmandi.ac.in',
    password: 'Password123!',
};

let authToken = '';
let userId = '';

beforeAll(async () => { await connectTestDB(); });

afterAll(async () => {
    await clearCollections('users');
});

// ─── REGISTER ───────────────────────────────────────────────────────────────
describe('POST /api/auth/register', () => {
    it('should register a new user successfully', async () => {
        const res = await request(app).post('/api/auth/register').send(TEST_USER);
        expect(res.statusCode).toBe(201);
        expect(res.body).toHaveProperty('token');
        expect(res.body.email).toBe(TEST_USER.email);
        userId = res.body._id;
    });

    it('should reject duplicate email', async () => {
        const res = await request(app).post('/api/auth/register').send(TEST_USER);
        expect(res.statusCode).toBe(400);
        expect(res.body.message).toMatch(/already exists/i);
    });

    it('should reject missing required fields', async () => {
        const res = await request(app).post('/api/auth/register').send({ email: 'a@b.com' });
        expect(res.statusCode).toBe(400);
    });
});

// ─── LOGIN ───────────────────────────────────────────────────────────────────
describe('POST /api/auth/login', () => {
    it('should login with correct credentials', async () => {
        const res = await request(app).post('/api/auth/login').send({
            email: TEST_USER.email,
            password: TEST_USER.password,
        });
        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('token');
        authToken = res.body.token;
    });

    it('should reject wrong password', async () => {
        const res = await request(app).post('/api/auth/login').send({
            email: TEST_USER.email,
            password: 'WrongPassword',
        });
        expect(res.statusCode).toBe(400);
        expect(res.body.message).toMatch(/invalid credentials/i);
    });

    it('should reject unknown email', async () => {
        const res = await request(app).post('/api/auth/login').send({
            email: 'nobody@iitmandi.ac.in',
            password: 'anything',
        });
        expect(res.statusCode).toBe(400);
    });
});

// ─── GET ME ──────────────────────────────────────────────────────────────────
describe('GET /api/auth/me', () => {
    it('should return user data with valid token', async () => {
        const res = await request(app)
            .get('/api/auth/me')
            .set('Authorization', `Bearer ${authToken}`);
        expect(res.statusCode).toBe(200);
        expect(res.body.email).toBe(TEST_USER.email);
    });

    it('should reject request with no token', async () => {
        const res = await request(app).get('/api/auth/me');
        expect(res.statusCode).toBe(401);
    });

    it('should reject request with invalid token', async () => {
        const res = await request(app)
            .get('/api/auth/me')
            .set('Authorization', 'Bearer invalidtoken123');
        expect(res.statusCode).toBe(401);
    });
});

// ─── CHECK EMAIL ─────────────────────────────────────────────────────────────
describe('POST /api/auth/check-email', () => {
    it('should return exists:true for registered email', async () => {
        const res = await request(app)
            .post('/api/auth/check-email')
            .send({ email: TEST_USER.email });
        expect(res.statusCode).toBe(200);
        expect(res.body.exists).toBe(true);
    });

    it('should return exists:false for unknown email', async () => {
        const res = await request(app)
            .post('/api/auth/check-email')
            .send({ email: 'ghost@iitmandi.ac.in' });
        expect(res.statusCode).toBe(200);
        expect(res.body.exists).toBe(false);
    });
});

// ─── UPDATE PROFILE ──────────────────────────────────────────────────────────
describe('PUT /api/auth/profile', () => {
    it('should update profile when authenticated', async () => {
        const res = await request(app)
            .put('/api/auth/profile')
            .set('Authorization', `Bearer ${authToken}`)
            .send({ name: 'Updated Name', email: TEST_USER.email });
        expect(res.statusCode).toBe(200);
        expect(res.body.name).toBe('Updated Name');
    });

    it('should reject unauthenticated profile update', async () => {
        const res = await request(app)
            .put('/api/auth/profile')
            .send({ name: 'Hacker' });
        expect(res.statusCode).toBe(401);
    });
});

// ─── UPDATE PASSWORD ─────────────────────────────────────────────────────────
describe('PUT /api/auth/password', () => {
    it('should update password for existing user (OTP flow)', async () => {
        const res = await request(app).put('/api/auth/password').send({
            email: TEST_USER.email,
            password: 'NewPassword456!',
        });
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toMatch(/updated/i);
    });

    it('should return 404 for unknown email', async () => {
        const res = await request(app).put('/api/auth/password').send({
            email: 'ghost@iitmandi.ac.in',
            password: 'anything',
        });
        expect(res.statusCode).toBe(404);
    });
});
