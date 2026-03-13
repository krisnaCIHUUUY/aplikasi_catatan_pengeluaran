import mongoose from "mongoose";

const Expense = new mongoose.Schema(
  {
    title: {
      type: String,
      require: true,
      trim: true,
    },
    amount: {
      type: Number,
      require: true,
      trim: true,
    },
    category: {
      type: String,
      require: true,
      enum: [
        "Makanan & Minuman",
        "Hiburan",
        "Belanja",
        "Transportasi",
        "Lainnya",
      ],
    },
    date: {
      type: Date,
      require: true,
      default: Date.now,
    },
    description: {
      type: String,
      // require: true,
      trim: true,
    },
  },
  {
    timestamps: true,
  },
);

export default mongoose.model("Expense", Expense);
