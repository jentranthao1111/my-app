import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPageEmployee = ({ setPage }) => {
  const [bookings, setBookings] = useState([]);
  const [hotelID, setHotelID] = useState(null);
  const employeeID = localStorage.getItem('ssn_sid');

  useEffect(() => {
    if (employeeID) {
      fetchHotelID(employeeID);
    }
  }, [employeeID]);

  useEffect(() => {
    if (hotelID) {
      fetchBookings(hotelID);
    }
  }, [hotelID]);

  const fetchHotelID = async (empID) => {
    try {
      const response = await axios.get(`http://localhost:5001/api/employee/hotel_fid/${empID}`);
      setHotelID(response.data.hotel_id);
      console.log(response);
    } catch (err) {
      console.error("Error fetching hotel ID:", err);
    }
  };

  const fetchBookings = async (hotelIDParam) => {
    try {
      const response = await axios.get(`http://localhost:5001/api/booking/hotel_id/${hotelIDParam}`);
      setBookings(response.data);
    } catch (err) {
      console.error("Error fetching bookings:", err);
    }
  };

  const handleRent = async (bookingId) => {
    try {
      await axios.post(`http://localhost:5001/api/bookings/${bookingId}/rent`);
      alert('Booking rented!');
      fetchBookings(hotelID);
    } catch (error) {
      console.error('Error renting:', error);
      alert('Failed to rent booking.');
    }
  };

  const handleCancel = async (bookingId) => {
    if (!window.confirm("Are you sure you want to cancel this booking?")) return;

    try {
      const response = await fetch(`http://localhost:5001/api/booking/${bookingId}`, {
        method: 'DELETE',
      });

      const data = await response.json();
      console.log("Server response:", data);

      if (response.ok) {
        alert("Booking deleted");
        fetchBookings(hotelID);
      } else {
        alert("Failed to delete booking: " + data.message);
      }
    } catch (error) {
      console.error("Error deleting booking", error);
      alert("An error occurred while deleting the booking.");
    }
  };

  return (
    <div className="main-page">
      <h1>Employee Booking Portal</h1>

      <h2>Manage Bookings</h2>
      <div className="booking-list">
        {hotelID ? (
          bookings.length > 0 ? (
            <ul>
              {bookings.map(booking => (
                <li key={booking.booking_id} className="booking-item">
                  <span>
                    {`Customer ID: ${booking.cust_id} | Hotel: ${booking.hotel_name} | Dates: ${booking.checkindate?.substring(0, 10)} - ${booking.checkoutdate?.substring(0, 10)}`}
                  </span>
                  <button className="rent-button" onClick={() => handleRent(booking.booking_id)}>Rent</button>
                  <button className="cancel-button" onClick={() => handleCancel(booking.booking_id)}>Cancel</button>
                </li>
              ))}
            </ul>
          ) : (
            <p>No bookings available.</p>
          )
        ) : (
          <p>Loading hotel data...</p>
        )}
      </div>

      <div className="navigate-button-wrapper" style={{ marginTop: '2rem' }}>
        <h2 className="text-xl font-semibold mb-2">Make a Booking</h2>
        <button
          onClick={() => setPage('hotelroom')}
          className="go-to-rooms-button"
          disabled={!hotelID}
        >
          Go to Hotel Rooms
        </button>
      </div>
    </div>
  );
};

export default MainPageEmployee;
