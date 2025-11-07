// backend/src/routes/orders.js
const express = require('express');
const { protect } = require('../middleware/auth');
const { createOrder, getMyOrders } = require('../controllers/orderController');
const router = express.Router();

router.use(protect);
router.post('/', createOrder);
router.get('/my', getMyOrders);

module.exports = router;