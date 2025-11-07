// backend/src/routes/products.js
const express = require('express');
const { fetchProducts } = require('../controllers/productController');
const router = express.Router();

router.get('/', fetchProducts);

module.exports = router;