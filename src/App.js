

import React from 'react';
import './App.css';
import Navbar from './component/Navbar'; 
import MainPage from './pages/mainpage';
import Login from './pages/login';

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
