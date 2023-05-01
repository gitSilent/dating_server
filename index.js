const express = require('express');
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "dating_db",
    password: "1234"
})

connection.connect((err)=>{
    if(err){
        return console.error("Ошибка: " + err.message)
    }else{
        console.log("Подключение к серверу MySQL успешно установлено");
    }
})

const app = express();


app.get('/', (req,res)=>{
    res.send("Main domain");
})

app.get('/getUsers', (req,res)=>{

    connection.query("select * from Users", (err,result,fields)=>{
        console.log(err);
        console.log(result);

        let response = {
            err,
            result,
        }
        res.send(response);
    })
})



app.patch('/updateWatchedList/:id', (req,res)=>{
    connection.query(`call UpdateWatchedList(${req.params['id']})`, (err,result,fields)=>{
        console.log(err);
        console.log(result);

        let response = {
            err,
            result,
        }
        res.send(response);
    })
})

app.get('/getUserByPhone/:phone', (req,res)=>{

    console.log(req.params)
    // res.send(req.params);
   
    connection.query(`select * from Users WHERE phone_number = ${req.params['phone']}`, (err,result,fields)=>{

        if(result.length > 0){
            res.status(200)
            res.send(result);
        }else{
            res.status(204)
            res.send("Нет записей");
        }

  
    })
})

app.get('/getUserById/:id', (req,res)=>{

    console.log(req.params)
    // res.send(req.params);
   
    connection.query(`select * from Users WHERE id_user = ${req.params['id']}`, (err,result,fields)=>{

        if(result.length > 0){
            res.status(200)
            res.send(result);
        }else{
            res.status(204)
            res.send("Нет записей");
        }

  
    })
})


app.listen(3050);