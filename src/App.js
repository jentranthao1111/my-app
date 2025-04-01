import React, { useState } from 'react';
import './App.css';
import Navbar from './component/Navbar';
import MainPageUser from './pages/mainpageuser';
import Login from './pages/login';
import MainPageEmployee from './pages/mainpageemployee';
import SignUp from './pages/signup';

function App() {
  const [page, setPage] = useState('login'); // Initial page state is 'login'

  return (
    <div className="App">
      <Navbar />
      
      <div className="content">
        {/* Conditionally render pages based on the page state */}
        {page === 'login' && <Login setPage={setPage} />}
        {page === 'signup' && <SignUp setPage={setPage} />} {/* Pass setPage to SignUp */}
        {page === 'mainpageuser' && <MainPageUser />}
        {page === 'mainpageemployee' && <MainPageEmployee />}
      </div>
    </div>
  );
}

export default App;
