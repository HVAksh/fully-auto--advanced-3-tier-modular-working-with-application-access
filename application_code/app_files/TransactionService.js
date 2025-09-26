// app_files/TransactionService.js
const dbcreds = require('./DbConfig');
const mysql = require('mysql');

const con = mysql.createConnection({
  host: dbcreds.DB_HOST,
  user: dbcreds.DB_USER,
  password: dbcreds.DB_PWD,
  database: dbcreds.DB_DATABASE,
});

function addTransaction(amount, desc) {
  const query = 'INSERT INTO `transactions` (`amount`, `description`) VALUES (?, ?)';
  con.query(query, [amount, desc], (err, result) => {
    if (err) throw err;
    console.log('Adding to the table should have worked:', result.affectedRows);
  });
  return 200;
}

function getAllTransactions(callback) {
  const query = 'SELECT * FROM transactions';
  con.query(query, (err, result) => {
    if (err) throw err;
    console.log('Getting all transactions...');
    callback(result);
  });
}

function findTransactionById(id, callback) {
  const query = 'SELECT * FROM transactions WHERE id = ?';
  con.query(query, [id], (err, result) => {
    if (err) throw err;
    console.log(`Retrieving transaction with id ${id}`);
    callback(result);
  });
}

function deleteAllTransactions(callback) {
  const query = 'DELETE FROM transactions';
  con.query(query, (err, result) => {
    if (err) throw err;
    console.log('Deleting all transactions...');
    callback(result);
  });
}

function deleteTransactionById(id, callback) {
  const query = 'DELETE FROM transactions WHERE id = ?';
  con.query(query, [id], (err, result) => {
    if (err) throw err;
    console.log(`Deleting transaction with id ${id}`);
    callback(result);
  });
}

module.exports = {
  addTransaction,
  getAllTransactions,
  deleteAllTransactions,
  findTransactionById,
  deleteTransactionById,
};