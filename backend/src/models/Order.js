const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  items: [{
    productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
    qty: Number,
    price: Number,
  }],
  total: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Order', orderSchema);