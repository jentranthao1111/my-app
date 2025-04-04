import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPage = ({ setPage }) => {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const userId = localStorage.getItem('cust_id');

  useEffect(() => {
    fetchBookings();
  }, [userId]);

  const fetchBookings = async () => {
    try {
      const response = await axios.get(`http://localhost:5001/api/booking/cust_id/${userId}`);
      setBookings(response.data);
    } catch (err) {
      console.error(err);
      setError('Failed to load bookings.');
    } finally {
      setLoading(false);
    }
  };

  const cancelBooking = async (bookingId) => {
    if (!window.confirm("Are you sure you want to cancel this booking?")) return;
    console.log("booking to be deleted:", bookingId);
    try {
      const response = await fetch(`http://localhost:5001/api/booking/${bookingId}`, {
        method: 'DELETE',
      });
  
      const data = await response.json();
      console.log("Server response:", data);
  
      if (response.ok) {
        alert("Booking deleted");
        fetchBookings(); // refresh the list of bookings
      } else {
        alert("Failed to delete booking: " + data.message);
      }
    } catch (error) {
      console.error("Error deleting booking", error);
      alert("An error occurred while deleting the booking.");
    }
  };

  const scrollSlider = (direction) => {
    const slider = document.getElementById("booking-slider");
    const scrollAmount = 300;
    if (slider) {
      slider.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
    }
  };

  return (
    <div className="main-page">
      <h1>Your Hotel Bookings</h1>

      {loading && <p>Loading bookings...</p>}
      {error && <p className="error-message">{error}</p>}

      {!loading && bookings.length === 0 && (
        <p>You haven't booked any hotels yet.</p>
      )}

      {bookings.length > 0 && (
        <div className="booking-slider-wrapper">
          <button className="scroll-btn left" onClick={() => scrollSlider(-1)}>&lt;</button>

          <div className="booking-slider" id="booking-slider">
            {bookings.map((booking) => (
              <div key={booking.Booking_ID} className="booking-card">
                <h3>{booking.Hotel_Name || "Hotel #" + booking.hotel_id}</h3>
                <p><strong>Room:</strong> {booking.room_id}</p>
                <p><strong>Check-in:</strong> {new Date(booking.checkindate).toISOString().split("T")[0]}</p>
                <p><strong>Check-out:</strong> {new Date(booking.checkoutdate).toISOString().split("T")[0]}</p>
                <p><strong>Status:</strong> {booking.status}</p>
                <button className="cancel-btn" onClick={() => cancelBooking(booking.Booking_ID)}>
                  Cancel Booking
                </button>
              </div>
            ))}
          </div>

          <button className="scroll-btn right" onClick={() => scrollSlider(1)}>&gt;</button>
        </div>
      )}

      <div className="hotel-search-section">
        <h2>Want to book a new room?</h2>
        <button onClick={() => setPage('hotelsearch')} className="search-hotel-btn">
          Search Hotels
        </button>
      </div>
    </div>
  );
};

export default MainPage;


// import React, { useState } from 'react';
// import './css/mainpage.css';

// export default function MainPage() {
//   const [city, setCity] = useState('');
//   const [checkInDate, setCheckInDate] = useState('');
//   const [checkOutDate, setCheckOutDate] = useState('');
//   const [roomType, setRoomType] = useState('Single');
//   const [hotelChain, setHotelChain] = useState('');
//   const [roomsAvailable, setRoomsAvailable] = useState([]);
//   const [errorMessage, setErrorMessage] = useState('');
  
//   const handleSearch = (e) => {
//     e.preventDefault();
//      // Mock data for Hotel Chains, Hotels, and Rooms
//      const mockData = [
//         {
//           hotelName: 'Ocean Breeze Hotel',
//           hotelChain: 'Ocean Breeze Chain',
//           roomType: 'Single',
//           price: 120,
//           available: 3,
//           amenities: ['TV', 'Air Conditioning', 'Fridge'],
//           capacity: 'Single',
//           view: 'Sea View',
//           extendable: true,
//           damages: 'None',
//           contactEmail: 'oceanbreeze@hotels.com',
//           phoneNumber: '123-456-7890',
//         },
//         {
//           hotelName: 'Mountain Peak Resort',
//           hotelChain: 'Mountain Peaks Chain',
//           roomType: 'Double',
//           price: 180,
//           available: 2,
//           amenities: ['TV', 'Air Conditioning'],
//           capacity: 'Double',
//           view: 'Mountain View',
//           extendable: false,
//           damages: 'Minor damage',
//           contactEmail: 'mountainpeaks@resorts.com',
//           phoneNumber: '987-654-3210',
//         },
//       ];
//     // Validate if check-out date is after check-in date
//     if (new Date(checkOutDate) <= new Date(checkInDate)) {
//       setErrorMessage('Check-out date must be later than check-in date.');
//       return;
//     } else {
//       setErrorMessage('');
//       setRoomsAvailable(mockData);
//     }

   
    
//   };

//   return (
//     <div className="main-page">
//       <div className="hero-section">
//         <h1>Welcome to Hotel E-Commerce</h1>
//         <p>Book your stay in the best hotels with ease. Search for rooms below:</p>
//         <form onSubmit={handleSearch} className="search-form">
//           <div className="form-group">
//             <label htmlFor="city">City:</label>
//             <input
//               type="text"
//               id="city"
//               value={city}
//               onChange={(e) => setCity(e.target.value)}
//               placeholder="Enter city"
//             />
//           </div>
//           <div className="form-group">
//             <label htmlFor="checkInDate">Check-in Date:</label>
//             <input
//               type="date"
//               id="checkInDate"
//               value={checkInDate}
//               onChange={(e) => setCheckInDate(e.target.value)}
//             />
//           </div>
//           <div className="form-group">
//             <label htmlFor="checkOutDate">Check-out Date:</label>
//             <input
//               type="date"
//               id="checkOutDate"
//               value={checkOutDate}
//               onChange={(e) => setCheckOutDate(e.target.value)}
//             />
//           </div>
//           <div className="form-group">
//             <label htmlFor="hotelChain">Hotel Chain:</label>
//             <input
//               type="text"
//               id="hotelChain"
//               value={hotelChain}
//               onChange={(e) => setHotelChain(e.target.value)}
//               placeholder="Enter hotel chain"
//             />
//           </div>
//           <div className="form-group">
//             <label htmlFor="roomType">Room Type:</label>
//             <select
//               id="roomType"
//               value={roomType}
//               onChange={(e) => setRoomType(e.target.value)}
//             >
//               <option value="Single">Single</option>
//               <option value="Double">Double</option>
//               <option value="Suite">Suite</option>
//             </select>
//           </div>
//           <button type="submit">Search Rooms</button>
//         </form>

//         {errorMessage && <p className="error-message">{errorMessage}</p>}
//       </div>

//       <div className="available-rooms">
//         <h2>Available Rooms</h2>
//         {roomsAvailable.length > 0 ? (
//           <ul>
//             {roomsAvailable.map((room, index) => (
//               <li key={index} className="room-item">
//                 <h3>{room.hotelName}</h3>
//                 <p>Hotel Chain: {room.hotelChain}</p>
//                 <p>Room Type: {room.roomType}</p>
//                 <p>Price: ${room.price}</p>
//                 <p>Available Rooms: {room.available}</p>
//                 <p>Amenities: {room.amenities.join(', ')}</p>
//                 <p>Capacity: {room.capacity}</p>
//                 <p>View: {room.view}</p>
//                 <p>Extendable: {room.extendable ? 'Yes' : 'No'}</p>
//                 <p>Damages: {room.damages}</p>
//                 <p>Contact: {room.contactEmail}, {room.phoneNumber}</p>
//                 <button>Book Now</button>
//               </li>
//             ))}
//           </ul>
//         ) : (
//           <p>No rooms available based on your search criteria.</p>
//         )}
//       </div>

//       <footer>
//         <p>&copy; 2025 Hotel E-Commerce. All Rights Reserved.</p>
//       </footer>
//     </div>
//   );
// }
