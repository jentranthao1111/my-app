import React, { useState } from 'react';
import './css/booking.css'; 

const BookingForm = ({ onSubmit }) => {
  const [checkInDate, setCheckInDate] = useState('');
  const [checkOutDate, setCheckOutDate] = useState('');
  const [roomId, setRoomId] = useState('');
  const [hotelId, setHotelId] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    const bookingData = { checkInDate, checkOutDate, roomId, hotelId };
    onSubmit(bookingData); 
  };

  return (
    <div className="booking-container">
      <h2>Book a Room</h2>

      
      <form className="booking-form" onSubmit={handleSubmit}>

      <label>Room ID:</label>
        <input type="number" value={roomId} onChange={(e) => setRoomId(e.target.value)} required />

        <label>Hotel ID:</label>
        <input type="number" value={hotelId} onChange={(e) => setHotelId(e.target.value)} required />
        
        <label>Check-in Date:</label>
        <input type="date" value={checkInDate} onChange={(e) => setCheckInDate(e.target.value)} required />

        <label>Check-out Date:</label>
        <input type="date" value={checkOutDate} onChange={(e) => setCheckOutDate(e.target.value)} required />



        <button type="submit" className="booking-btn">Submit</button>
      </form>
    </div>
  );
};

export default BookingForm;
