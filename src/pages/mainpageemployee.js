import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPageEmployee = ({ setPage }) => {
  const [bookings, setBookings] = useState([]);

  useEffect(() => {
    // Fetch bookings from DB
    axios.get('/api/bookings') // Replace with your real API
      .then(response => setBookings(response.data))
      .catch(error => console.log(error));
  }, []);

  const handleRent = (bookingId) => {
    axios.post(`/api/bookings/${bookingId}/rent`)
      .then(() => {
        alert('Booking rented!');
        return axios.get('/api/bookings');
      })
      .then(response => setBookings(response.data))
      .catch(error => console.error('Error renting:', error));
  };

  const handleCancel = (bookingId) => {
    axios.delete(`/api/bookings/${bookingId}`)
      .then(() => {
        alert('Booking cancelled!');
        return axios.get('/api/bookings');
      })
      .then(response => setBookings(response.data))
      .catch(error => console.error('Error cancelling:', error));
  };

  return (
    <div className="main-page">
      <h1>Employee Booking Portal</h1>

      {/* 🔹 Booking List */}
      <h2>Manage Bookings</h2>
      <div className="booking-list">
        {bookings.length > 0 ? (
          <ul>
            {bookings.map(booking => (
              <li key={booking.id} className="booking-item">
                <span>
                  {`Customer: ${booking.customerName} | Hotel: ${booking.hotelName} | Dates: ${booking.startDate} - ${booking.endDate}`}
                </span>
                <button className="rent-button" onClick={() => handleRent(booking.id)}>Rent</button>
                <button className="cancel-button" onClick={() => handleCancel(booking.id)}>Cancel</button>
              </li>
            ))}
          </ul>
        ) : (
          <p>No bookings available.</p>
        )}
      </div>

      {/*  Label and Navigation Button */}
      <div className="navigate-button-wrapper" style={{ marginTop: '2rem' }}>
        <h2 className="text-xl font-semibold mb-2">Make a Booking</h2>
        <button
          onClick={() => setPage('hotelroom')}
          className="go-to-rooms-button"
        >
          Go to Hotel Rooms
        </button>
      </div>
    </div>
  );
};

export default MainPageEmployee;
