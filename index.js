const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser')
const uuid = require('uuid').v4
const fileUpload = require('express-fileupload')
const fs = require('fs')

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

app.use(bodyParser.json())
app.use(fileUpload());
app.use(cors())

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

        try{
            if(result.length > 0){
                res.status(200)
                res.send(result);
            }else{
                res.status(204)
                res.send(result);
            }
        }catch(er){
            
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

app.post('/registrate', (req,res)=>{
    console.log(req.files);
    console.log("|||||||||||||||||||||||");
    console.log(req.body);

    let newUser = req.body;
    const { image } = req.files;
    
    connection.query(`insert into Users(phone_number,password,user_name,gender,city,birth_date,about,height,weight) values("${newUser.login}","${newUser.password}","${newUser.name}","${newUser.gender}",${newUser.city},"${newUser.birthDate}","${newUser.about}",${newUser.height},${newUser.weight})`, (err,result,fields)=>{
        console.log(err);
        console.log(result);
        
        let response = {
            err,
            result,
        }
        let uniqImgId = uuid();
        image.mv(__dirname + '/photos/' + uniqImgId + "." + image.name.split(".")[image.name.split(".").length-1]);
        connection.query(`insert into ProfilePhotos(file_path,on_avatar,id_user) values ("${'/photos/' + uniqImgId + "." + image.name.split(".")[image.name.split(".").length-1]}",1,${result.insertId})`)
        console.log(__dirname + '/photos/' + uniqImgId + "." + image.name.split(".")[image.name.split(".").length-1]);
        // res.send(response);
        res.sendStatus(200);
    })
})

app.get('/getCities', (req,res)=>{
    connection.query("select * from Cities", (err,result,fields)=>{
        // console.log(err);
        // console.log(result);

        let response = {
            err,
            result,
        }
        res.send(response);
    })
})

app.get('/getAvailableProfile', (req,res)=>{

    console.log(req.query)
    connection.query(`SELECT * FROM users WHERE id_user NOT IN (SELECT id_viewed FROM watchedprofiles WHERE id_viewing = ${req.query['currentUserId']}) and users.id_user !=${req.query['currentUserId']} and users.gender = "${req.query['lookFor']}" limit 1`,
     (err,result,fields)=>{
        // console.log(err);
        console.log(result);

        let response = {
            err,
            result,
        }
        res.send(response);
    })
})

app.post('/sendPhoto',(req,res)=>{
    console.log(req.files);
    console.log("|||||||||||||||||||||||");
    console.log(req.body);
    res.sendStatus(200)
})

app.get('/getUserPhotos',(req,res)=>{

})

app.get('/getUserAvatar/:id', (req,res)=>{
    console.log(req.params);
    connection.query(`SELECT file_path FROM ProfilePhotos WHERE id_user = ${req.params['id']} AND on_avatar = 1`,
    (err,result,fields)=>{
       // console.log(err);
       console.log(result);
       try{
           res.sendFile(__dirname+`${result[0].file_path}`)
       }catch(er){
        res.send("#")
       }
        // fs.readFile(`.${result[0].file_path}`, (err, img)=>{
        // })
       let response = {
           err,
           result,
       }
    //    res.send(response);
   })
})

app.post('/markAsViewed',(req,res)=>{
    console.log(req.body);
    connection.query(`insert into WatchedProfiles(id_viewed, id_viewing) values (${req.body['id_viewed']},${req.body['id_viewing']})`, 
    (err,result,field)=>{
        res.send({
            err,
            result,
        })

    })
})
app.listen(3050);
