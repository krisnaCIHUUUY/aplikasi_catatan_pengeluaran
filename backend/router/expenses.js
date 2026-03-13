import express from "express";
import {
  createExpenses,
  deleteExpenses,
  getAllExpenses,
  getExpensesById,
  getExpensesByKategori,
  getTotalExpenses,
  updateExpenses,
} from "../controller/expensesController.js";

const expensesRouter = express.Router();

// SEMUA PENGELUARAN
expensesRouter.get("/", getAllExpenses);
// TOTAL PENGELUARAN
expensesRouter.get("/total", getTotalExpenses);
// PENGELUARAN BY KATEGORI
expensesRouter.get("/category/:category", getExpensesByKategori);
// PENGELUARAN BY ID
expensesRouter.get("/:id", getExpensesById);
// CREATE PENGELUARAN
expensesRouter.post("/", createExpenses);
// UPDATE PENGELUARAN
expensesRouter.put("/:id", updateExpenses);
// DELETE PENGELUARAN
expensesRouter.delete("/:id", deleteExpenses);

export default expensesRouter;
