import React, { useState, useEffect } from 'react';
import './css/mainpage.css';
import axios from 'axios';

const MainPage = () => {
  const [hotelChains, setHotelChains] = useState([]);
  const [hotels, setHotels] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [customers, setCustomers] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');


  return (
    <div>
      {/* Booking Section */}
      <h2>Make a Booking</h2>
      <form>
        <select>
          {hotels.map((hotel) => (
            <option key={hotel.Hotel_ID} value={hotel.Hotel_ID}>
              {hotel.Email}
            </option>
          ))}
        </select>
        <input type="date" placeholder="Check-in Date" />
        <input type="date" placeholder="Check-out Date" />
        <button>Book</button>
      </form>
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
