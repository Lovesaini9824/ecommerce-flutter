const express = require('express');
const { protect } = require('../middleware/auth');
const { getCart, addToCart } = require('../controllers/cartController');
const router = express.Router();

router.use(protect);  // Apply auth to all cart routes

router.get('/', getCart);
router.post('/', addToCart);

module.exports = router;