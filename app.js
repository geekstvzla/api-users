const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config();

app.use(express.json());
app.use(cors());

const usersRouter = require('./routes/users');
app.use('/users', usersRouter);

app.use(express.static(__dirname + '/public'));

app.get('/', (req, res) => {
    res.send('Hello World! '+process.env.DB_PASSWORD+' - '+process.env.API_PUBLIC+' -> '+process.env.DB_SAPE);
});

app.listen(process.env.API_PORT, () => {
    console.log(`API listening on port ${process.env.API_PORT}`);
});
