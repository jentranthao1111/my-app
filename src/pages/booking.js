import React, { useState } from 'react';
import './css/booking.css'; 

const BookingForm = ({ setPage }) => {
  const [checkInDate, setCheckInDate] = useState(localStorage.getItem('checkInDate') || '');
  const [checkOutDate, setCheckOutDate] = useState(localStorage.getItem('checkOutDate') || '');

  const hotelId = localStorage.getItem('selectedHotelId');
  const roomId = localStorage.getItem('selectedRoomId');

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    const customerId = localStorage.getItem('cust_id');
    console.log("Server response:", customerId);
    if (!customerId) {
      alert("Please log in before making a booking.");
      return;
    }
  
    try {
      const response = await fetch('http://localhost:5001/api/booking', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          checkindate: checkInDate,
          checkoutdate: checkOutDate,
          status: "Pending",
          cust_id: customerId,
          room_id: roomId,
          hotel_id: hotelId
        }),
      });
  
      const data = await response.json();
      console.log("Server response:", data);
  
      if (response.ok) {
        alert("Booking successful!");
  
        // Clear stored info
        localStorage.removeItem('selectedHotelId');
        localStorage.removeItem('selectedRoomId');
        localStorage.removeItem('checkInDate');
        localStorage.removeItem('checkOutDate');
  
        setPage('mainpageuser');
      } else {
        alert("Booking failed: " + (data.message || JSON.stringify(data)));
      }
    } catch (error) {
      console.error("Network or server error:", error);
      alert("An error occurred. Check console for details.");
    }
  };
  

  return (
    <div className="booking-container">
      <h2>Book a Room</h2>

      <form className="booking-form" onSubmit={handleSubmit}>
        <p><strong>Room ID:</strong> {roomId}</p>
        <p><strong>Hotel ID:</strong> {hotelId}</p>

        <label>Check-in Date:</label>
        <input
          type="date"
          value={checkInDate}
          onChange={(e) => setCheckInDate(e.target.value)}
          required
        />

        <label>Check-out Date:</label>
        <input
          type="date"
          value={checkOutDate}
          onChange={(e) => setCheckOutDate(e.target.value)}
          required
        />

        <button type="submit" className="booking-btn">Submit</button>
      </form>
    </div>
  );
};

export default BookingForm;

