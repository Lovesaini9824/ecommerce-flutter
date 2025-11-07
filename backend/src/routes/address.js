const express = require('express');
const { protect } = require('../middleware/auth');
const { saveAddress, getAddress } = require('../controllers/addressController');
const router = express.Router();

router.use(protect);
router.post('/', saveAddress);
router.get('/', getAddress);

module.exports = router;