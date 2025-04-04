import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPageEmployee = ({ setPage }) => { // Accept setPage as a prop
  const [customers, setCustomers] = useState([]);
  const [custID, setCustID] = useState('');
  const [hotelID, setHotelID] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');

  useEffect(() => {
    // Fetch customers
    axios.get('/api/customers')
      .then(response => setCustomers(response.data))
      .catch(error => console.log(error));
  }, []);

  const handleBooking = (e) => {
    e.preventDefault();
    if (!custID || !hotelID || !startDate || !endDate) {
      alert('Please fill in all fields.');
      return;
    }

    // Mock submission
    console.log('Booking Details:', { custID, hotelID, startDate, endDate });

    // Reset form
    setCustID('');
    setHotelID('');
    setStartDate('');
    setEndDate('');

    alert('Booking successful!');
  };

  return (
    <div className="main-page">
      <h1>Employee Booking Portal</h1>

      <h2>Make a Booking</h2>
      <form onSubmit={handleBooking} className="booking-form">
        <div className="form-group">
          <label>Customer ID:</label>
          <input
            type="text"
            value={custID}
            onChange={(e) => setCustID(e.target.value)}
            placeholder="Enter Customer ID"
          />
        </div>

        <div className="form-group">
          <label>Hotel ID:</label>
          <input
            type="text"
            value={hotelID}
            onChange={(e) => setHotelID(e.target.value)}
            placeholder="Enter Hotel ID"
          />
        </div>

        <div className="form-group">
          <label>Start Date:</label>
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
          />
        </div>

        <div className="form-group">
          <label>End Date:</label>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
          />
        </div>

        <button type="submit" className="book-button">Book</button>
      </form>

      <div className="book-room-section">
      </div>
    </div>
  );
};

export default MainPageEmployee;
