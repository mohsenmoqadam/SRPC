#!/bin/bash

AppName=$1

mkdir $AppName
cd $AppName
npm init -y
npm install react react-dom --save
npm install webpack webpack-dev-server webpack-cli --save
npm install babel-core babel-loader@^7 babel-preset-env babel-preset-react html-webpack-plugin --save-dev

touch index.html
cat > index.html << EOF
<!DOCTYPE html>
<html lang = "en">
   <head>
      <meta charset = "UTF-8">
      <title>React App</title>
   </head>
   <body>
      <div id = "app"></div>
      <script src = 'index_bundle.js'></script>
   </body>
</html>
EOF

touch App.js
cat > App.js << EOF
import React, { Component } from 'react';
class App extends Component{
   render(){
      return(
         <div>
            The new React project is ready for development.
         </div>
      );
   }
}
export default App;
EOF

touch main.js
cat > main.js << EOF
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App.js';

ReactDOM.render(<App />, document.getElementById('app'));
EOF

touch webpack.config.js
cat > webpack.config.js << EOF
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
   entry: './main.js',
   output: {
      path: path.join(__dirname, '/bundle'),
      filename: 'index_bundle.js'
   },
   devServer: {
      inline: true,
      port: 8080
   },
   module: {
      rules: [
         {
            test: /\.jsx?$/,
            exclude: /node_modules/,
            loader: 'babel-loader',
            query: {
               presets: ['env', 'react']
            }
         }
      ]
   },
   plugins:[
      new HtmlWebpackPlugin({
         template: './index.html'
      })
   ]
}
EOF

touch .babelrc
cat > .babelrc << EOF
{
   "presets":["env", "react"]
}
EOF

touch Makefile

sed 's/"scripts": {/"scripts": {\
    "start": "webpack-dev-server --mode development --open --hot",\
    "build": "webpack --mode production",/g' package.json > tmp.package.json

mv tmp.package.json package.json

npm start
