const urlParams = new URLSearchParams(window.location.search);
const hotelName = urlParams.get("name"); // Get hotel name from the URL
console.log("Extracted Hotel Name:", hotelName); 
async function fetchHotelDetails() {

    if (!hotelName) {
        console.error("Hotel name not provided in the URL.");
        return;
    }

    try {
        // Fetch the hotel details and its rooms using the hotel name
        const response = await fetch(`http://localhost:5001/api/hotels/${encodeURIComponent(hotelName)}`);
        //const response = await fetch(`http://localhost:5001/api/hotel/?name=${encodeURIComponent(hotelName)}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const hotelData = await response.json();
        document.getElementById('hotelName').textContent = hotelData.hotel_name;
        displayRooms(hotelData.rooms); // Call function to display rooms
    } catch (error) {
        console.error("Error fetching hotel details:", error);
    }
}

function displayRooms(rooms) {
    const roomTable = document.getElementById("roomTable");
    roomTable.innerHTML = ""; // Clear any previous results

    if (!rooms || rooms.length === 0) {
        roomTable.innerHTML = "<p>No rooms available for this hotel.</p>";
        return;
    }

    const table = document.createElement("table");
    table.classList.add("w-full", "text-left", "border-collapse", "border", "border-gray-300");

    const thead = document.createElement("thead");
    thead.innerHTML = `
        <tr class="bg-gray-200">
            <th class="border border-gray-300 px-4 py-2">Room View</th>
            <th class="border border-gray-300 px-4 py-2">Price</th>
            <th class="border border-gray-300 px-4 py-2">Amenity</th>
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
        `;
        tbody.appendChild(row);
    });

    table.appendChild(tbody);
    roomTable.appendChild(table);
}

fetchHotelDetails(); // Fetch the hotel details when the page loads
