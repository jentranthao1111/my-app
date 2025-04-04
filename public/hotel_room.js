const urlParams = new URLSearchParams(window.location.search);
const hotelId = urlParams.get("id"); // Get hotel name from the URL
const roomTable = document.getElementById("roomTable");

roomTable.innerHTML = ""; // Clear any previous results

const table = document.createElement("table");
    
console.log("Extracted Hotel id:", hotelId); 

document.addEventListener("DOMContentLoaded", function () {
    document.getElementById('hotelName').textContent = hotelId;
    const checkInDate = localStorage.getItem("checkInDate");
    const checkOutDate = localStorage.getItem("checkOutDate");
    if (checkInDate && checkOutDate) {
        console.log("Check-in:", checkInDate);
        console.log("Check-out:", checkOutDate);

        // Example: Displaying the dates in an HTML element
        document.getElementById("checkInDisplay").textContent = `Check-in: ${checkInDate}`;
        document.getElementById("checkOutDisplay").textContent = `Check-out: ${checkOutDate}`;
    } else {
        console.log("No check-in or check-out date found.");
    }

    if (!hotelId) {
        console.error("Hotel id not provided in the URL.");
        return;
    }

    fetchHotelDetails(hotelId);

});

//const response = await fetch(`http://localhost:5001/api/hotels/${encodeURIComponent(hotelName)}`);
// const response = await fetch(`http://localhost:5001/api/hotel/${(hotelid)}`);
 //await fetch("http://localhost:5001/api/cities");

async function fetchHotelDetails(hotelId) {
   
    console.log("Test hotel room from fetch hotel details.");
    try {
        const response = await fetch(`http://localhost:5001/api/hotels/${hotelId}/rooms`);
   

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        console.log(data);
        document.getElementById('hotelName').textContent = data.hotel.hotel_name;
        displayRooms(data.rooms);
        
    } catch (error) {
        console.error("Error:", error);
        roomTable.innerHTML = `
            <p class='text-red-500'>
                Failed to load rooms. Please try again later.
            </p>
        `;
    }
}

function displayRooms(rooms) {

    if (!rooms || rooms.length === 0) {
        roomTable.innerHTML = "<p>No rooms available for this hotel.</p>";
        return;
    }

    // const table = document.createElement("table");

    table.classList.add("w-full", "text-left", "border-collapse", "border", "border-gray-300");

    const thead = document.createElement("thead");
    thead.innerHTML = `
        <tr class="bg-gray-200">
            <th class="border border-gray-300 px-4 py-2">Room View</th>
            <th class="border border-gray-300 px-4 py-2">Price</th>
            <th class="border border-gray-300 px-4 py-2">Amenity</th>
            <th class="border border-gray-300 px-4 py-2">Booking    </th>
        </tr>
    `;
    table.appendChild(thead);

    const tbody = document.createElement("tbody");
    rooms.forEach(room => {
        const row = document.createElement("tr");
        row.classList.add("border", "border-gray-300");

        row.innerHTML = `
            <td class="border border-gray-300 px-4 py-2">${room.view}</td>
            <td class="border border-gray-300 px-4 py-2">${room.price}</td>
            <td class="border border-gray-300 px-4 py-2">${room.amenity}</td>
            <td class="border border-gray-300 bg-gray-500 px-4 py-2 text-center">
                <button onclick="selectRoom('${room.room_id}', '${room.hotel_id}')" class="select-room-btn bg-gray-500 text-white py-2 rounded-lg hover:bg-gray-900" data-room-id="${room.room_id}">
                    Select
                </button>
            </td>
        `;
        tbody.appendChild(row);
    });

    table.appendChild(tbody);
    roomTable.appendChild(table);
}


function clearPageAndGoBack() {
    localStorage.removeItem("selectedHotelId");
    localStorage.removeItem("checkInDate");
    localStorage.removeItem("checkOutDate");

    localStorage.removeItem("selectedRoomId");

    window.location.href = "hotel.html"; // Change this to your hotel listing page
}


function selectRoom(roomId, hotelId) {
    const checkInDate = localStorage.getItem("checkInDate") || "";
    const checkOutDate = localStorage.getItem("checkOutDate") || "";

    // Save booking data to localStorage
    localStorage.setItem("selectedRoomId", roomId);
    localStorage.setItem("selectedHotelId", hotelId);
    localStorage.setItem("checkInDate", checkInDate);
    localStorage.setItem("checkOutDate", checkOutDate);

    // Redirect to booking page
    window.location.href = "booking.js"; 
}
