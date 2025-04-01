const {Client} = require('pg')

const client = new Client({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "7596",
    database: "ehotel_csi2132_prj"
})


client.connect();
module.exports = client;
// test the connection
client.query(`Select * from public.hotel_chain`, (err,res) => {
    if(!err){
        console.log(res.rows);
    }else{
        console.log(err.message)
    }

    client.end;
})

//test the connection
// client.query(`Select * from public.hotel`, (err,res) => {
//     if(!err){
//         console.log(res.rows);
//     }else{
//         console.log(err.message)
//     }

//     client.end;
// })