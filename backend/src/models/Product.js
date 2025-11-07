const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  title: { type: String, required: true },
  price: { type: Number, required: true },
  image: { type: String },
  description: { type: String },
});

module.exports = mongoose.model('Product', productSchema);