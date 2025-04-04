import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPageEmployee = ({ setPage, setSelectedHotelId }) => {
  const [bookings, setBookings] = useState([]);
  const [localHotelId, setLocalHotelId] = useState(null);
  const [customerId, setCustomerId] = useState(localStorage.getItem('cust_id') || '');
  const employeeID = localStorage.getItem('ssn_sid');

  useEffect(() => {
    if (employeeID) {
      fetchHotelID(employeeID);
    }
  }, [employeeID]);

  useEffect(() => {
    if (localHotelId) {
      fetchBookings(localHotelId);
    }
  }, [localHotelId]);

  const fetchHotelID = async (empID) => {
    try {
      const response = await axios.get(`http://localhost:5001/api/employee/hotel_fid/${empID}`);
      const fetchedId = response.data.hotel_id;
      setLocalHotelId(fetchedId);
      setSelectedHotelId(fetchedId);
    } catch (err) {
      console.error("Error fetching hotel ID:", err);
    }
  };

  const fetchBookings = async (hotelID) => {
    try {
      const response = await axios.get(`http://localhost:5001/api/booking/hotel_id/${hotelID}`);
      setBookings(response.data);
    } catch (err) {
      console.error("Error fetching bookings:", err);
    }
  };

  const handleRent = async (booking) => {
    try {
      const response = await axios.post(`http://localhost:5001/api/renting`, {
        startdate: booking.checkindate,
        enddate: booking.checkoutdate,
        status: "Ongoing",
        payment: booking.total_payment,
        employ_sid: localStorage.getItem("ssn_sid"),
        cust_id: booking.cust_id,
        room_id: booking.room_id,
        hotel_id: booking.hotel_id,
      });

      if (response.status === 200) {
        await axios.put(`http://localhost:5001/api/booking/${booking.booking_id}/confirm`);
        alert("Booking successfully converted to renting and confirmed!");
        fetchBookings(localHotelId);
      } else {
        alert("Unexpected response from server while renting.");
      }
    } catch (error) {
      console.error("Error renting booking:", error.response?.data || error);
      alert("Failed to rent booking. Please try again.");
    }
  };

  const handleCancel = async (bookingId) => {
    if (!window.confirm("Are you sure you want to cancel this booking?")) return;

    try {
      const response = await fetch(`http://localhost:5001/api/booking/${bookingId}`, {
        method: 'DELETE',
      });

      const data = await response.json();
      if (response.ok) {
        alert("Booking deleted");
        fetchBookings(localHotelId);
      } else {
        alert("Failed to delete booking: " + data.message);
      }
    } catch (error) {
      console.error("Error deleting booking", error);
      alert("An error occurred while deleting the booking.");
    }
  };

  const handleGoToRooms = () => {
    setPage('hotelroom');
  };

  const handleSaveCustomerId = async () => {
    if (customerId.trim() === '') {
      alert('Customer ID cannot be empty');
      return;
    }

    try {
      const response = await axios.get(`http://localhost:5001/api/customer/cust_id/${customerId}`);
      if (response.data.exists) {
        localStorage.setItem('cust_id', customerId);
        alert(`Customer ID ${customerId} saved`);
      } else {
        alert(`Customer ID ${customerId} does not exist in the system`);
      }
    } catch (error) {
      console.error("Error checking customer ID:", error);
      alert("Failed to validate customer ID.");
    }
  };

  return (
    <div className="main-page">
      <h1>Employee Booking Portal</h1>
      <h2>Book For Customer</h2>

      <div className="top-bar" style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.5rem' }}>
        <input
          type="text"
          value={customerId}
          onChange={(e) => setCustomerId(e.target.value)}
          placeholder="Enter Customer ID"
          className="customer-id-field"
          style={{ padding: '0.5rem', borderRadius: '4px' }}
        />
        <button onClick={handleSaveCustomerId}>Save Customer ID</button>
        <button onClick={handleGoToRooms} className="go-to-rooms-button" disabled={!localHotelId}>
          Go to Hotel Rooms
        </button>
      </div>

      <h2>Manage Bookings</h2>
      <div className="booking-list">
        {localHotelId ? (
          bookings.length > 0 ? (
            <ul>
              {bookings.map(booking => (
                <li key={booking.booking_id} className="booking-item">
                  <span>
                    {`Customer ID: ${booking.cust_id} | Hotel: ${booking.hotel_name} | Dates: ${booking.checkindate?.substring(0, 10)} - ${booking.checkoutdate?.substring(0, 10)}`}
                  </span>
                  <button className="rent-button" onClick={() => handleRent(booking)}>Rent</button>
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
    </div>
  );
};

export default MainPageEmployee;
