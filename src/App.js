

import React from 'react';
import './App.css';
import Navbar from './component/Navbar'; 
import MainPage from './pages/mainpageuser';
import Login from './pages/login';
import User from './pages/mainpageuser'
import Employee from './pages/mainpageemployee'

function App() {
  return (
    <div className="App">
      <Navbar /> {}
      
      <div className="content">
      <Login /> {}
        
      </div>
    </div>
  );
}

export default App;
