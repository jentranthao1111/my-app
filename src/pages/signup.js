import React, { useState } from 'react';
import './css/signup.css'; 

const SignUp = ({ setPage }) => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // Handle Form Submission
  const handleSubmit = async (e) => {
    e.preventDefault();
  
    if (password !== confirmPassword) {
      alert("Passwords do not match!");
      return;
    }
  
    try {
      const response = await fetch('http://localhost:5001/api/customer', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          full_name: username,
          email: email,
          password: password,
          address: 'N/A'
        }),
      });
  
      const data = await response.json();
      console.log("Server response:", data);
  
      if (response.ok) {
        alert("Customer registered successfully!");
        setPage('mainpageuser');
      } else {
        alert("Registration failed: " + (data.message || JSON.stringify(data)));
      }
    } catch (error) {
      console.error("Network or server error:", error);
      alert("An error occurred. Check console for details.");
    }
  };

  // Handle Login Redirect
  const handleLoginRedirect = () => {
    setPage('login'); // Go back to login page 
  };
  

  return (
    <div className="signup-container">
      <h2>Sign Up</h2>
      <form className="signup-form" onSubmit={handleSubmit}>
        <label>Username:</label>
        <input
          type="text"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          placeholder="Enter username"
          required
        />

        <label>Email:</label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Enter email"
          required
        />

        <label>Password:</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Enter password"
          required
        />

        <label>Confirm Password:</label>
        <input
          type="password"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          placeholder="Confirm password"
          required
        />

        <button type="submit" className="signup-btn">Register</button>

        <p>
          Already have an account? 
          <button type="button" onClick={handleLoginRedirect}>Login</button> {/* Use handleLoginRedirect */}
        </p>
      </form>
    </div>
  );
};

export default SignUp;
