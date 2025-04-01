let cities = []; // Declare `cities` globally so both `fetchCities` and `filterSuggestions` can access it.
let selectedCity = ''; // Store the selected city here
let findbtn = document.getElementById('findbtn');
let citiesLoaded = false; // Flag to track if cities have been loaded

async function fetchHotels() {
    try {
        if (!selectedCity) {
            console.log("No city selected!");
            return;
        }

        console.log("Fetching hotels for city:", selectedCity);
        const response = await fetch(`http://localhost:5001/api/hotels?city=${selectedCity}`);

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const hotels = await response.json();
        console.log("Fetched hotels:", hotels);
        displayHotels(hotels);

    } catch (error) {
        console.error("Error fetching hotels:", error);
    }
}


// Filter suggestions based on input
function filterSuggestions() {
    if (!citiesLoaded) {
        return; 
    }

    let input = document.getElementById("searchInput").value.toLowerCase();
    let suggestionsBox = document.getElementById("suggestions");
    suggestionsBox.innerHTML = "";

    if (input === "") {
        suggestionsBox.style.display = "none";
        return;
    }

    let filteredCities = cities.filter(city => city.toLowerCase().includes(input));

    if (filteredCities.length === 0) {
        suggestionsBox.style.display = "none";
        return;
    }

    filteredCities.forEach(city => {
        let li = document.createElement("li");
        li.textContent = city;
        li.classList.add("px-3", "py-2", "hover:bg-gray-200", "cursor-pointer", "rounded-lg");

        li.onclick = function () {
            selectedCity = city; // Set the selected city
            document.getElementById("searchInput").value = city;
            suggestionsBox.style.display = "none";
            
            // After selecting city, fetch the hotels
            fetchHotels();
        };
        suggestionsBox.appendChild(li);
    });

    suggestionsBox.style.display = "block";
    suggestionsBox.classList.add("border", "rounded-lg", "mt-1", "shadow-md", "absolute", "bg-white", "w-full");
}

async function fetchHotelsByCity(city) {
    console.log(`Fetching hotels for city: ${city}`);
    
    try {
        const response = await fetch(`http://localhost:5001/api/hotels?city=${city}`); // Pass city in query param
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const hotels = await response.json();
        console.log("Fetched hotels:", hotels);
        displayHotels(hotels); // Update the table with fetched hotels
    } catch (error) {
        console.error("Error fetching hotels:", error);
    }
}

function displayHotels(hotels) {
        const tableBody = document.getElementById('hotelTableBody');
        tableBody.innerHTML = ""; // Clear previous results
    
        if (hotels.length === 0) {
            tableBody.innerHTML = "<tr><td colspan='4' class='text-center text-gray-500'>No hotels found for this city.</td></tr>";
            return;
        }
    
        hotels.forEach(hotel => {
            let row = document.createElement("tr");
            row.classList.add("border", "border-gray-300");

            // <a href="hotel_room.html?name=${encodeURIComponent(hotel.hotel_name)}" class="text-blue-500 hover:underline">
                    //     ${hotel.hotel_name}
                    // </a>

            row.innerHTML = `
                <td class="border border-gray-300 px-4 py-2">
                    
                    <a href="hotel_room.html? id=${encodeURIComponent(hotel.hotel_name)}" class="text-blue-500 hover:underline">
                        ${hotel.hotel_name}
                    </a>
                </td>
                
                <td class="border border-gray-300 px-4 py-2">${hotel.address}</td>
                <td class="border border-gray-300 px-4 py-2">${hotel.category}</td>
                <td class="border border-gray-300 px-4 py-2">${hotel.email || "N/A"}</td>
            `;
    
            tableBody.appendChild(row);
        });
    }
    

document.addEventListener("DOMContentLoaded", function () {
    // Fetch cities from the backend
    async function fetchCities() {
        try {
            const response = await fetch("http://localhost:5001/api/cities");

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            // Remove duplicates by using a Set
            cities = [...new Set(data.map(item => item.city))]; // Extract city names and remove duplicates
            console.log("Fetched Cities:", cities); // Debugging

            citiesLoaded = true; // Set flag to true once cities are loaded
        } catch (error) {
            console.error("Error fetching cities:", error);
        }
    }

    // Fetch cities when the page loads
    fetchCities();
});

// Restrict Check-out Date
document.getElementById("checkInDate").addEventListener("change", function() {
    let checkIn = new Date(this.value);
    let checkOutInput = document.getElementById("checkOutDate");

    if (checkOutInput.value && new Date(checkOutInput.value) <= checkIn) {
        checkOutInput.value = "";
    }
    
    checkOutInput.min = this.value;
});

// Function to set default dates
function setDefaultDates() {
    let today = new Date();
    let checkInDate = document.getElementById("checkInDate");
    let checkOutDate = document.getElementById("checkOutDate");

    // Format YYYY-MM-DD
    let todayStr = today.toISOString().split("T")[0];
    let twoDaysLater = new Date();
    twoDaysLater.setDate(today.getDate() + 2);
    let twoDaysLaterStr = twoDaysLater.toISOString().split("T")[0];

    // Set default values
    checkInDate.value = todayStr;
    checkOutDate.value = twoDaysLaterStr;

    // Restrict minimum selectable dates
    checkInDate.min = todayStr;
    checkOutDate.min = twoDaysLaterStr;
}

// Restrict Check-out Date when Check-in is changed
document.getElementById("checkInDate").addEventListener("change", function() {
    let checkIn = new Date(this.value);
    let checkOutInput = document.getElementById("checkOutDate");

    let minCheckOut = new Date(checkIn);
    minCheckOut.setDate(checkIn.getDate() + 1);
    let minCheckOutStr = minCheckOut.toISOString().split("T")[0];

    checkOutInput.value = minCheckOutStr;
    checkOutInput.min = minCheckOutStr;
});

// Add Event Listener to the "Find" button
findbtn.addEventListener('click', function () {
    // Call fetchHotels when the "Find" button is clicked
    fetchHotels();
});

// Run function on page load
window.onload = setDefaultDates;
