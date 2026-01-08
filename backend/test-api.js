// Quick test script to verify backend endpoints
import axios from 'axios';

const BASE_URL = 'http://localhost:5000';

async function testBackend() {
    console.log('🧪 Testing Backend API...\n');

    try {
        // Test 1: Server is running
        console.log('1️⃣ Testing if server is running...');
        const healthCheck = await axios.get(`${BASE_URL}/auth/login`, {
            validateStatus: () => true
        });
        console.log(`✅ Server is running (status: ${healthCheck.status})\n`);

        // Test 2: Signup
        console.log('2️⃣ Testing signup...');
        const signupData = {
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123'
        };
        
        try {
            await axios.post(`${BASE_URL}/auth/signup`, signupData);
            console.log('✅ Signup successful\n');
        } catch (err) {
            if (err.response?.data?.error?.includes('already exists')) {
                console.log('ℹ️ User already exists (that\'s okay)\n');
            } else {
                throw err;
            }
        }

        // Test 3: Login
        console.log('3️⃣ Testing login...');
        const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
            email: signupData.email,
            password: signupData.password
        });
        const token = loginResponse.data.token;
        console.log(`✅ Login successful. Token: ${token.substring(0, 20)}...\n`);

        // Test 4: Get /user/me
        console.log('4️⃣ Testing /user/me endpoint...');
        const meResponse = await axios.get(`${BASE_URL}/user/me`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        console.log('✅ /user/me response:');
        console.log(JSON.stringify(meResponse.data, null, 2));
        console.log();

        // Test 5: Save profile
        console.log('5️⃣ Testing profile save...');
        const profileData = {
            age: 25,
            gender: 'male',
            height: 175,
            weight: 70,
            goal: 'Build Muscle',
            bodyType: 'Athletic'
        };
        
        await axios.post(`${BASE_URL}/user/profile`, profileData, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        console.log('✅ Profile saved successfully\n');

        // Test 6: Verify profile was saved
        console.log('6️⃣ Verifying profile was saved...');
        const meResponse2 = await axios.get(`${BASE_URL}/user/me`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        console.log('✅ Updated user data:');
        console.log(JSON.stringify(meResponse2.data, null, 2));

        console.log('\n✅ All tests passed!');

    } catch (error) {
        console.error('\n❌ Test failed:');
        console.error('Error:', error.response?.data || error.message);
        console.error('Status:', error.response?.status);
    }
}

testBackend();
