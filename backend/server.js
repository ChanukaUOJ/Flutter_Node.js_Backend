const express = require('express');

//app configuration
const app = express();

const port = process.env.port || 3000;

//middleware configuration
app.use(express.json());

//api routes

//define item list
let itemList = [
    {id:1,name:"item1"},
    {id:2,name:"item2"},
    {id:3,name:"item3"},
    {id:4,name:"item4"},
    {id:5,name:"item5"},
    {id:6,name:"item6"},
    {id:7,name:"item7"},
];

//CRUD applications
app.get('/api/v1/items',(req,res)=>{
    return res.json(itemList);
});

app.post('/api/v1/items',(req,res)=>{
    let newItem = {
        id: itemList.length + 1,
        name: req.body.name
    }
    itemList.push(newItem);
    res.send(newItem);
});

app.put('/api/v1/items/:id',(req,res)=>{
    let itemId = +req.params.id;
    let updatedItem = {
        id: itemId,
        name: req.body.name
    };
    let index = itemList.findIndex(item => item.id === itemId);
    if(index !== -1){
        itemList[index] = updatedItem;
        res.json(updatedItem);
    } else {
        res.status(404).send("Not Found");
    }
});

app.delete('/api/v1/items/:id',(req,res)=>{
    let itemId = +req.params.id;
    let index = itemList.findIndex(item => item.id === itemId);

    if(index !== -1){
        let deletedItem = itemList.splice(index,1);
        res.send(deletedItem);
    } else {
        res.status(404).send('Item not found!');
    }
});

//listners configuration
app.listen(port,console.log(`Listen to port ${port}`));