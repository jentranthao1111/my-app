import React, { useState } from 'react';
import './App.css';
import Navbar from './component/Navbar';
import MainPageUser from './pages/mainpageuser';
import Login from './pages/login';
import MainPageEmployee from './pages/mainpageemployee';
import SignUp from './pages/signup';
import BookingPage from './pages/booking';
import HotelRoom from './pages/hotelroom';
import HotelSearch from './pages/hotelsearch';




function App() {
  const [page, setPage] = useState('login'); 
  const [selectedHotelId, setSelectedHotelId] = useState(null);

  return (
    <div className="App">
      <Navbar />
      
      <div className="content">
        {page === 'login' && <Login setPage={setPage} />}
        {page === 'signup' && <SignUp setPage={setPage} />} 
        {page === 'mainpageuser' && <MainPageUser setPage={setPage} />}
        {page === 'mainpageemployee' && <MainPageEmployee setPage={setPage} setSelectedHotelId={setSelectedHotelId} />}
        {page === 'booking' && <BookingPage setPage={setPage} />}
        {page === 'hotelroom' && <HotelRoom setPage={setPage} hotelId={selectedHotelId} />}
        {page === 'hotelsearch' && <HotelSearch setPage={setPage} setSelectedHotelId={setSelectedHotelId} />}
      </div>
    </div>
  );
}

export default App;
