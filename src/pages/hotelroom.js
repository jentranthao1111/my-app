import React, { useState, useEffect } from 'react';

const HotelRooms = ({ setPage, hotelId }) => {
  const [rooms, setRooms] = useState([]);
  const [hotelName, setHotelName] = useState('Loading hotel...');
  const checkInDate = localStorage.getItem('checkInDate') || '';
  const checkOutDate = localStorage.getItem('checkOutDate') || '';

  useEffect(() => {
    if (!hotelId) {
      console.error('Hotel ID not provided.');
      return;
    }
    fetchHotelDetails();
  }, [hotelId]);

  const fetchHotelDetails = async () => {
    try {
      const response = await fetch(`http://localhost:5001/api/hotels/${hotelId}/rooms`);
      if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
      
      const data = await response.json();
      setHotelName(data.hotel.hotel_name);
      setRooms(data.rooms);
    } catch (error) {
      console.error('Error fetching hotel details:', error);
    }
  };

  return (
    <div className="bg-white shadow-lg rounded-lg p-6 w-full max-w-3xl mx-auto">
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">{hotelName}</h2>
      <p>Check-in: {checkInDate}</p>
      <p>Check-out: {checkOutDate}</p>

      <button onClick={() => setPage('search')} className="mt-4 w-full bg-gray-500 text-white py-2 rounded-lg hover:bg-gray-600">
        Back to Hotels
      </button>
    </div>
  );
};

export default HotelRooms;
