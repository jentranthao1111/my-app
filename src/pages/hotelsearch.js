import React, { useState, useEffect } from "react";

const HotelSearch = ({ setPage, setSelectedHotelId }) => {
  const [cities, setCities] = useState([]);
  const [selectedCity, setSelectedCity] = useState("");
  const [hotels, setHotels] = useState([]);
  const [suggestions, setSuggestions] = useState([]);
  const [checkInDate, setCheckInDate] = useState("");
  const [checkOutDate, setCheckOutDate] = useState("");

  useEffect(() => {
    fetchCities();
    setDefaultDates();
  }, []);

  async function fetchCities() {
    try {
      const response = await fetch("http://localhost:5001/api/cities");
      if (!response.ok) throw new Error("Failed to fetch cities");
      const data = await response.json();
      setCities([...new Set(data.map((item) => item.city))]);
    } catch (error) {
      console.error("Error fetching cities:", error);
    }
  }

  async function fetchHotels() {
    if (!selectedCity) {
      alert("Please select a city");
      return;
    }
    try {
      const response = await fetch(`http://localhost:5001/api/hotels?city=${selectedCity}`);
      if (!response.ok) throw new Error("Failed to fetch hotels");
      const data = await response.json();
      setHotels(data);
    } catch (error) {
      console.error("Error fetching hotels:", error);
    }
  }

  const filterSuggestions = (input) => {
    if (!input) return setSuggestions([]);
    const filtered = cities.filter((city) => city.toLowerCase().includes(input.toLowerCase()));
    setSuggestions(filtered);
  };

  const handleHotelClick = (hotel) => {
    if (!checkInDate || !checkOutDate) {
      alert("Please select check-in and check-out dates");
      return;
    }

    localStorage.setItem("checkInDate", checkInDate);
    localStorage.setItem("checkOutDate", checkOutDate);
    setSelectedHotelId(hotel.hotel_id);
    setPage("hotelroom");
  };

  const setDefaultDates = () => {
    let today = new Date().toISOString().split("T")[0];
    let minCheckOut = new Date();
    minCheckOut.setDate(minCheckOut.getDate() + 2);
    let minCheckOutStr = minCheckOut.toISOString().split("T")[0];
    setCheckInDate(today);
    setCheckOutDate(minCheckOutStr);
  };

  return (
    <div className="bg-white shadow-lg rounded-lg p-6 w-full max-w-2xl">
      <h2 className="text-2xl font-semibold text-gray-700 mb-4">Find a Hotel</h2>

      <div className="relative mb-4">
        <input
          type="text"
          placeholder="Where can we take you?"
          className="w-full px-4 py-2 border rounded-lg"
          value={selectedCity}
          onChange={(e) => {
            setSelectedCity(e.target.value);
            filterSuggestions(e.target.value);
          }}
        />
        {suggestions.length > 0 && (
          <ul className="absolute bg-white border rounded-lg mt-1 shadow-md w-full">
            {suggestions.map((city) => (
              <li
                key={city}
                className="px-3 py-2 hover:bg-gray-200 cursor-pointer"
                onClick={() => setSelectedCity(city)}
              >
                {city}
              </li>
            ))}
          </ul>
        )}
      </div>

      <div className="flex space-x-4 mb-4">
        <input type="date" className="w-1/2 border rounded-lg p-2" value={checkInDate} onChange={(e) => setCheckInDate(e.target.value)} />
        <input type="date" className="w-1/2 border rounded-lg p-2" value={checkOutDate} onChange={(e) => setCheckOutDate(e.target.value)} />
      </div>

      <button className="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600" onClick={fetchHotels}>
        Find Hotel
      </button>

      <hr className="my-4" />
      <table className="w-full text-left border-collapse border border-gray-300">
        <thead>
          <tr className="bg-gray-200">
            <th className="border px-4 py-2">Hotel Name</th>
            <th className="border px-4 py-2">Address</th>
          </tr>
        </thead>
        <tbody>
          {hotels.map((hotel) => (
            <tr key={hotel.hotel_id} className="border">
              <td className="border px-4 py-2">
                <button className="text-blue-500 hover:underline" onClick={() => handleHotelClick(hotel)}>
                  {hotel.hotel_name}
                </button>
              </td>
              <td className="border px-4 py-2">{hotel.address}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default HotelSearch;
