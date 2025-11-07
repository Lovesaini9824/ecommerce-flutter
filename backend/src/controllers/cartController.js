const Cart = require('../models/Cart');

const getCart = async (req, res) => {
  let cart = await Cart.findOne({ userId: req.user._id }).populate('items.productId');
  if (!cart) {
    cart = await Cart.create({ userId: req.user._id, items: [] });
  }
  res.json(cart);
};

const addToCart = async (req, res) => {
  const { productId, qty = 1 } = req.body;
  let cart = await Cart.findOne({ userId: req.user._id });
  if (!cart) cart = await Cart.create({ userId: req.user._id, items: [] });

  const existing = cart.items.find(i => i.productId.toString() === productId);
  if (existing) existing.qty += qty;
  else cart.items.push({ productId, qty });

  await cart.save();
  await cart.populate('items.productId');
  res.json(cart);
};

module.exports = { getCart, addToCart };