import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import { config } from "dotenv";
import expensesRouter from "./router/expenses.js";
import connectDB from "./config/db.js";

config();

const app = express();
const PORT = process.env.PORT || 3000;

// NOTE: GAGAL KONEKSI KE DATABASE GARA GARA IP NYA GAK ADA DI WHITE LIST ATAU MEMEMANG SINYALNYA LAGI JELEK
connectDB();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.json({ message: "selamat datang di Aplikasi pencatatan pengeluaran" });
});

app.use("/expense", expensesRouter);

app.listen(PORT, () => {
  console.log(`server berjalan di port ${PORT}`);
});
