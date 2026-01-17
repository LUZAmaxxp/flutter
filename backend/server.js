const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('Could not connect to MongoDB', err));

// --- SCHEMAS ---
const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    bio: { type: String, default: 'No bio added yet' },
    avatarUrl: { type: String, default: 'https://ui-avatars.com/api/?background=random' }
});

const appointmentSchema = new mongoose.Schema({
    title: String,
    description: String,
    dateTime: Date,
    userId: String,
    status: { type: String, default: 'pending' }
});

const User = mongoose.model('User', userSchema);
const Appointment = mongoose.model('Appointment', appointmentSchema);

// --- AUTH ROUTES ---
app.post('/auth/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({ name, email, password: hashedPassword });
        await user.save();
        res.status(201).json({ message: 'User registered successfully' });
    } catch (err) {
        res.status(400).json({ error: 'Email already exists or invalid data' });
    }
});

app.post('/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user || !(await bcrypt.compare(password, user.password))) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
        res.json({ token, user: { id: user._id, name: user.name, email: user.email } });
    } catch (err) {
        res.status(500).json({ error: 'Internal server error' });
    }
});

// --- USER ROUTES ---
app.get('/users/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id).select('-password');
        if (!user) return res.status(404).json({ error: 'User not found' });
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: 'Error fetching profile' });
    }
});

// --- APPOINTMENT ROUTES ---
app.get('/appointments', async (req, res) => {
    const appointments = await Appointment.find();
    res.json(appointments);
});

app.post('/appointments', async (req, res) => {
    const appointment = new Appointment(req.body);
    await appointment.save();
    res.status(201).json(appointment);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
