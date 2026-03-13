import Expense from "../model/expense.js";

export const getAllExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find().sort({ date: -1 });

    if (expenses.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Belum ada data pengeluaran",
        data: [],
      });
    }

    res.status(200).json({
      success: true,
      count: expenses.length,
      data: expenses,
    });
  } catch (err) {
    res.status(500).json({ message: "gagal mendapatkan data", error: err });
  }
};

// sdadca
export const getTotalExpenses = async (req, res) => {
  try {
    const result = await Expense.aggregate([
      {
        $group: {
          _id: null,
          total: { $sum: "$amount" },
        },
      },
    ]);

    const total = result.length > 0 ? result[0].total : 0;
    res.status(200).json({
      message: "berhasil menghitung total expense",
      data: total,
    });
  } catch (err) {
    res
      .status(500)
      .json({ message: "gagal menghitung total expense", error: err });
  }
};

export const getExpensesByKategori = async (req, res) => {
  try {
    const { category } = req.params;
    const expenseByCategory = await Expense.find({ category }).sort({
      date: -1,
    });
    if (!expenseByCategory) {
      return res.status(404).json({
        message: "data tidak ditemukan",
      });
    }

    res.status(200).json({
      message: "berhasil mengambil data by kategori",
      success: true,
      data: expenseByCategory,
    });
  } catch (err) {
    res.status(500).json({
      message: "gagal mengambil data berdasarkan kategori",
      error: err,
    });
  }
};
export const getExpensesById = async (req, res) => {
  try {
    const expenseById = await Expense.findById(req.params.id).sort({
      date: -1,
    });
    if (!expenseById) {
      return res.status(404).json({ message: "data tidak ditemukan" });
    }
    res.status(200).json({
      message: "berhasil mendapat data",
      success: true,
      data: expenseById,
    });
  } catch (err) {
    res
      .status(500)
      .json({ message: "gagal mendapat data berdasarkan id", error: err });
  }
};
export const createExpenses = async (req, res) => {
  try {
    const { title, amount, category, date, description } = req.body;

    const newExpense = await Expense.create({
      title: title,
      amount: amount,
      category: category,
      date: date,
      description: description,
    });

    res.status(201).json({
      success: true,
      message: "berhasil menambah data",
      data: newExpense,
    });
  } catch (err) {
    res
      .status(400)
      .json({ message: "gagal menambah data", error: err.message });
  }
};

export const deleteExpenses = async (req, res) => {
  try {
    const { id } = req.params.id;
    const deletedExpense = await Expense.findByIdAndDelete(id);

    if (!deletedExpense) {
      return res.status(404).json({
        message: "data tidak ditemukan",
      });
    }

    res.status(200).json({
      success: true,
      message: "berhasil menghapus data",
      data: deletedExpense,
    });
  } catch (err) {
    res.status(500).json({
      message: "gagal menghapus data",
      error: err,
    });
  }
};

export const updateExpenses = async (req, res) => {
  try {
    const updatedExpense = await Expense.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      },
    );

    if (!updatedExpense) {
      return res.status(404).json({ message: "data tidak ditemukan" });
    }

    res.status(201).json({
      success: true,
      message: "berhasil mengupdate data",
      data: updatedExpense,
    });
  } catch (err) {
    res.status(500).json({ message: "gagal mengupdate data", error: err });
  }
};
