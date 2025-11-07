// backend/src/server.js
// ---- POLYFILL FOR undici (File/Blob) ----
globalThis.File = class File extends Blob {
  constructor(bits, name, options = {}) {
    super(bits, options);
    this.name = name;
    this.lastModified = options.lastModified || Date.now();
  }
};
globalThis.Blob = class Blob {
  constructor(bits = [], options = {}) {
    this.size = bits.reduce((s, b) => s + (b?.length || 0), 0);
    this.type = options.type || '';
  }
};
// -----------------------------------------

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();


app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/products', require('./routes/products'));
app.use('/api/cart', require('./routes/cart'));
app.use('/api/orders', require('./routes/orders'));

// MongoDB
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB connected');
  } catch (e) {
    console.error('MongoDB error:', e);
    process.exit(1);
  }
};
connectDB();

// 404
app.use('*', (req, res) => res.status(404).json({ message: 'Route not found' }));

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Server error' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));