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

  const selectRoom = (roomId, hotelId) => {
    // Save booking data to localStorage
    localStorage.setItem("selectedRoomId", roomId);
    localStorage.setItem("selectedHotelId", hotelId);
    localStorage.setItem("checkInDate", checkInDate);
    localStorage.setItem("checkOutDate", checkOutDate);

    console.log("Room selected:", roomId, hotelId);

    setPage('booking');
  };

  return (
    <div className="bg-white shadow-lg rounded-lg p-6 w-full max-w-5xl mx-auto">
      <h2 className="text-2xl font-semibold text-gray-700 mb-2">{hotelName}</h2>
      <p className="mb-4">Check-in: {checkInDate} | Check-out: {checkOutDate}</p>

      {rooms.length === 0 ? (
        <p className="text-gray-500 italic">No rooms available for this hotel.</p>
      ) : (
        <table className="w-full text-left border-collapse border border-gray-300">
          <thead>
            <tr className="bg-gray-200">
              <th className="border border-gray-300 px-4 py-2">Room View</th>
              <th className="border border-gray-300 px-4 py-2">Price</th>
              <th className="border border-gray-300 px-4 py-2">Amenity</th>
              <th className="border border-gray-300 px-4 py-2 text-center">Booking</th>
            </tr>
          </thead>
          <tbody>
            {rooms.map((room) => (
              <tr key={room.room_id} className="border border-gray-300">
                <td className="border px-4 py-2">{room.view}</td>
                <td className="border px-4 py-2">${room.price}</td>
                <td className="border px-4 py-2">{room.amenity}</td>
                <td className="border bg-gray-500 px-4 py-2 text-center">
                  <button
                    onClick={() => selectRoom(room.room_id, hotelId)}
                    className="bg-gray-500 text-white py-2 px-4 rounded-lg hover:bg-gray-900"
                  >
                    Select
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <button
        onClick={() => setPage('hotelsearch')}
        className="mt-6 w-full bg-gray-500 text-white py-2 rounded-lg hover:bg-gray-600"
      >
        Back to Hotels
      </button>
    </div>
  );
};

export default HotelRooms;
