const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('Could not connect to MongoDB', err));

// --- SMTP CONFIG ---
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

// --- SCHEMAS ---
const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, enum: ['client', 'doctor'], default: 'client' },
    isVerified: { type: Boolean, default: false },
    verificationCode: String,
    
    // NEW DOCTOR FIELDS
    specialization: { type: String, default: 'General Practitioner' },
    experience: { type: Number, default: 0 },
    rating: { type: Number, default: 4.5 },
    bio: { type: String, default: 'No bio added yet' },
    avatarUrl: { type: String, default: 'https://ui-avatars.com/api/?background=random' }
});

const appointmentSchema = new mongoose.Schema({
    title: String,
    description: String,
    dateTime: Date,
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Patient
    doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Doctor
    patientName: String,
    doctorName: String,
    age: Number,
    physicalPain: String,
    otherInfo: String,
    status: { type: String, enum: ['pending', 'confirmed', 'cancelled', 'done'], default: 'pending' }
});

const User = mongoose.model('User', userSchema);
const Appointment = mongoose.model('Appointment', appointmentSchema);

// --- AUTH ROUTES ---
app.post('/auth/register', async (req, res) => {
    try {
        const { name, email, password, role, specialization } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
        
        const user = new User({ 
            name, 
            email, 
            password: hashedPassword, 
            role, 
            verificationCode,
            specialization: specialization || 'General Practitioner'
        });
        await user.save();

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Verify your Appointment Pro Account',
            text: `Your verification code is: ${verificationCode}`
        };

        transporter.sendMail(mailOptions, (error) => {
            if (error) console.log('Email Error:', error);
        });

        res.status(201).json({ message: 'User registered. Please verify your email.' });
    } catch (err) {
        res.status(400).json({ error: 'Email already exists or invalid data' });
    }
});

app.post('/auth/verify', async (req, res) => {
    const { email, code } = req.body;
    const user = await User.findOne({ email, verificationCode: code });
    if (!user) return res.status(400).json({ error: 'Invalid code' });
    
    user.isVerified = true;
    user.verificationCode = undefined;
    await user.save();
    res.json({ message: 'Email verified successfully' });
});

app.post('/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user || !(await bcrypt.compare(password, user.password))) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        if (!user.isVerified) return res.status(403).json({ error: 'Please verify your email' });

        const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET);
        res.json({ 
            token, 
            user: { 
                id: user._id, 
                name: user.name, 
                email: user.email, 
                role: user.role,
                specialization: user.specialization 
            } 
        });
    } catch (err) {
        res.status(500).json({ error: 'Internal server error' });
    }
});

// --- DOCTOR ROUTES ---
app.get('/doctors', async (req, res) => {
    try {
        const doctors = await User.find({ role: 'doctor', isVerified: true }).select('-password');
        res.json(doctors);
    } catch (err) {
        res.status(500).json({ error: 'Error fetching doctors' });
    }
});

// --- APPOINTMENT ROUTES ---
app.get('/appointments/stats/summary', async (req, res) => {
    try {
        const total = await Appointment.countDocuments();
        const pending = await Appointment.countDocuments({ status: 'pending' });
        const confirmed = await Appointment.countDocuments({ status: 'confirmed' });
        const done = await Appointment.countDocuments({ status: 'done' });
        const cancelled = await Appointment.countDocuments({ status: 'cancelled' });
        
        res.json({ total, pending, confirmed, done, cancelled });
    } catch (err) {
        res.status(500).json({ error: 'Error fetching stats' });
    }
});

app.get('/appointments/:userId', async (req, res) => {
    try {
        const user = await User.findById(req.params.userId);
        let appointments;
        if (user.role === 'doctor') {
            appointments = await Appointment.find({ doctorId: req.params.userId }).populate('userId', 'name email');
        } else {
            appointments = await Appointment.find({ userId: req.params.userId });
        }
        res.json(appointments);
    } catch (err) {
        res.status(500).json({ error: 'Error fetching appointments' });
    }
});

app.patch('/appointments/:id/status', async (req, res) => {
    try {
        const { status } = req.body;
        const appointment = await Appointment.findByIdAndUpdate(req.params.id, { status }, { new: true });
        res.json(appointment);
    } catch (err) {
        res.status(400).json({ error: 'Update failed' });
    }
});

app.post('/appointments', async (req, res) => {
    try {
        const patient = await User.findById(req.body.userId);
        const doctor = await User.findById(req.body.doctorId);
        
        const appointmentData = { 
            ...req.body, 
            patientName: patient.name,
            doctorName: doctor ? doctor.name : 'Unknown Doctor'
        };
        const appointment = new Appointment(appointmentData);
        await appointment.save();
        res.status(201).json(appointment);
    } catch (err) {
        res.status(400).json({ error: 'Could not create appointment' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
