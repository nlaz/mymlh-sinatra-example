# MyMLH Sinatra Example
A simple example application that uses Sinatra and HTTParty to authenticate users for MyMLH.  

## Setup

These are the steps to get the app up and running:

###  Step 1. Clone this repository
Make a local copy of this project and move into the directory. This project requires Ruby and RubyGems. If you don't have Ruby installed yet, you can find [installation instructions here](https://www.digitalocean.com/community/tutorials/how-to-install-and-get-started-with-sinatra-on-your-system-or-vps).
```
  $ git clone git@github.com:nlaz/mymlh-sinatra-example.git 
  $ cd mymlh-sinatra-example  
```

### Step 2. Create an app on MyMLH
Head over to [http://my.mlh.io/](http://my.mlh.io/) and register a new application. You'll need to specify a callback url, which should be something like:  
```
  http://localhost:8000/authcallback/mlh
```  
We will set the port to `8000` when running the server, but you will want to update this if you use a different port or if you're hosting your app somewhere besides your local machine.

### Step 3. Set environment variables and run the server
You will need to create a `.env` file that stores the application secrets. You can rename the `sample.env` to `.env` and add your secrets there.  
You can now run your server with the following command:  
```
  $ rackup -p 8000
```

## Credit
This sample is built off of the [Flask OAuth Example](https://github.com/miguelgrinberg/flask-oauth-example) by Miguel Grinberg and retains his MIT License.