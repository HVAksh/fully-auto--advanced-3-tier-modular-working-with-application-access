// app_files/index.js
const transactionService = require('./TransactionService');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 4000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

// Health Checking
app.get('/health', (req, res) => {
  res.json({ message: 'This is the health check' });
});

// ADD TRANSACTION
app.post('/transaction', (req, res) => {
  try {
    console.log(req.body);
    console.log(req.body.amount);
    console.log(req.body.desc);
    const status = transactionService.addTransaction(req.body.amount, req.body.desc);
    if (status === 200) {
      res.status(200).json({ message: 'Added transaction successfully' });
    } else {
      res.status(500).json({ message: 'Failed to add transaction', error: 'Unexpected status code' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Something went wrong', error: err.message });
  }
});

// GET ALL TRANSACTIONS
app.get('/transaction', (req, res) => {
  try {
    transactionService.getAllTransactions((results) => {
      const transactionList = results.map((row) => ({
        id: row.id,
        amount: row.amount,
        description: row.description,
      }));
      console.log('Transaction list:', transactionList);
      res.status(200).json({ result: transactionList });
    });
  } catch (err) {
    res.status(500).json({ message: 'Could not get all transactions', error: err.message });
  }
});

// DELETE ALL TRANSACTIONS
app.delete('/transaction', (req, res) => {
  try {
    transactionService.deleteAllTransactions(() => {
      res.status(200).json({ message: 'Delete function execution finished' });
    });
  } catch (err) {
    res.status(500).json({ message: 'Deleting all transactions may have failed', error: err.message });
  }
});

// DELETE ONE TRANSACTION
app.delete('/transaction/:id', (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json({ message: 'Transaction ID is required' });
    }
    transactionService.deleteTransactionById(id, () => {
      res.status(200).json({ message: `Transaction with id ${id} seemingly deleted` });
    });
  } catch (err) {
    res.status(500).json({ message: 'Error deleting transaction', error: err.message });
  }
});

// GET SINGLE TRANSACTION
app.get('/transaction/:id', (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json({ message: 'Transaction ID is required' });
    }
    transactionService.findTransactionById(id, (result) => {
      if (!result || result.length === 0) {
        return res.status(404).json({ message: 'Transaction not found' });
      }
      const { id: transactionId, amount, desc } = result[0];
      res.status(200).json({ id: transactionId, amount, desc });
    });
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving transaction', error: err.message });
  }
});

app.listen(port, () => {
  console.log(`AB3 backend app listening at http://localhost:${port}`);
});