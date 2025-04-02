import React, { useState } from 'react';
import './App.css';
import Navbar from './component/Navbar';
import MainPageUser from './pages/mainpageuser';
import Login from './pages/login';
import MainPageEmployee from './pages/mainpageemployee';
import SignUp from './pages/signup';
import BookingPage from './pages/booking';


function App() {
  const [page, setPage] = useState('mainpageuser'); // Initial page state is 'login'

  return (
    <div className="App">
      <Navbar />
      
      <div className="content">
        {page === 'login' && <Login setPage={setPage} />}
        {page === 'signup' && <SignUp setPage={setPage} />} 
        {page === 'mainpageuser' && <MainPageUser />}
        {page === 'mainpageemployee' && <MainPageEmployee />}
        {page === 'booking' && <BookingPage setPage={setPage} />}
      </div>
    </div>
  );
}

export default App;
