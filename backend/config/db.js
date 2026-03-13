import mongoose from "mongoose";
// import { config } from "dotenv";

// config();

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log("berhasil terhubung ke database");
  } catch (err) {
    console.log("gagal terhubung ke database", err);
    process.exit(1);
  }
};

export default connectDB;
