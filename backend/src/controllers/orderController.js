// backend/src/controllers/orderController.js
const Order = require('../models/Order');
const Cart = require('../models/Cart');
const Product = require('../models/Product');

const createOrder = async (req, res) => {
  try {
    const { paymentMethod = 'cod', address } = req.body;
    const userId = req.user._id;

    // Validate payment method
    if (!['cod', 'online'].includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method' });
    }

    // Validate address
    if (!address || !address.fullName || !address.phone || !address.addressLine || !address.city || !address.state || !address.pincode) {
      return res.status(400).json({ message: 'Complete delivery address is required' });
    }

    // Validate cart
    const cart = await Cart.findOne({ userId }).populate('items.productId');
    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: 'Your cart is empty' });
    }

    // Build items
    const items = cart.items.map(item => {
      const p = item.productId;
      if (!p) throw new Error('Invalid product in cart');
      return {
        productId: p._id,
        title: p.title,
        price: p.price,
        qty: item.qty,
        image: p.image,
      };
    });

    const total = items.reduce((sum, i) => sum + i.price * i.qty, 0);
    const status = paymentMethod === 'online' ? 'Paid' : 'Pending';

    // Create order
    const order = await Order.create({
      userId,
      items,
      total,
      address: {
        fullName: address.fullName,
        phone: address.phone,
        addressLine: address.addressLine,
        landmark: address.landmark || '',
        city: address.city,
        state: address.state,
        pincode: address.pincode,
      },
      paymentMethod,
      status,
    });

    // Clear cart
    await Cart.findOneAndUpdate({ userId }, { items: [] });

    res.status(201).json({
      message: 'Order placed successfully',
      orderId: order._id,
      paymentMethod,
      status,
    });
  } catch (error) {
    console.error('Order error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

const getMyOrders = async (req, res) => {
  try {
    const userId = req.user._id;
    const orders = await Order.find({ userId })
      .select('-__v')
      .sort({ createdAt: -1 })
      .lean();

    const formatted = orders.map(o => ({
      _id: o._id,
      orderId: o._id.toString().substring(18),
      items: o.items.map(i => ({
        productId: i.productId,
        title: i.title,
        price: i.price,
        qty: i.qty,
        image: i.image,
      })),
      total: o.total,
      status: o.status || 'Pending',
      paymentMethod: o.paymentMethod || 'COD',
      address: o.address,
      createdAt: o.createdAt,
    }));

    res.json(formatted);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch orders' });
  }
};

module.exports = { createOrder, getMyOrders };