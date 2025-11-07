const Address = require('../models/Address');

const saveAddress = async (req, res) => {
  const { fullName, phone, pincode, city, state, addressLine, landmark } = req.body;
  const userId = req.user._id;

  let address = await Address.findOne({ userId });
  if (address) {
    address.set({ fullName, phone, pincode, city, state, addressLine, landmark, isDefault: true });
  } else {
    address = new Address({ userId, fullName, phone, pincode, city, state, addressLine, landmark, isDefault: true });
  }

  await address.save();
  res.json(address);
};

const getAddress = async (req, res) => {
  const address = await Address.findOne({ userId: req.user._id });
  res.json(address || {});
};

module.exports = { saveAddress, getAddress };