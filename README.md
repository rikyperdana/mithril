# Mithril CRUD Generator

## Quickstart

```
git pull https://github.com/rikyperdana/mithril
cd mithril
meteor npm install --save
meteorn
```

And then check http://localhost:3000 from your browser

## Project Structure

This repo consist several livescript files (both, client, and server). Where each file name explain it's 
purpose. And inside folder/funcs.ls is where lodash and mithril is defined. State is an empty object which 
will behave like a temporary object storage. Our main activity will mostly goes in client.ls

comp object consist of form, table, crud, and menus functions. Which will return an object that can be 
reusable according to fields params passed to them. As an example, if you want to create a CRUD that consist 
of contacts fields (name, phone, mobile), you can pass them to comp.form or comp.table as you can see on 
client.ls

Once the app has run, you can try http://localhost:3000/#!/name,phone,mobile

For each document stored in that single collection, the menus function will retrieve it and create links 
for each unique keys combination it has

## Further Development
You can suggest yours through Issues, or tinker it by yourself by forking this repo
