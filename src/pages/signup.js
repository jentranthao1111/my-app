import React, { useState } from 'react';
import './css/signup.css'; // Ensure this file exists for styling

const SignUp = ({ setPage }) => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // Handle Form Submission
  const handleSubmit = (e) => {
    //DO SOMETHING
  };

  // Handle Login Redirect
  const handleLogin = () => {
    setPage('login'); // Go back to login page (if using state-based navigation)
  };

  return (
    <div className="signup-container">
      <h2>Sign Up</h2>
      <form className="signup-form" onSubmit={handleSubmit}>
        <label>Username:</label>
        <input
          type="text"
          placeholder="Enter username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
        />

        <label>Email:</label>
        <input
          type="email"
          placeholder="Enter email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />

        <label>Password:</label>
        <input
          type="password"
          placeholder="Enter password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />

        <label>Confirm Password:</label>
        <input
          type="password"
          placeholder="Confirm password"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          required
        />

        <button type="submit" className="signup-btn">Register</button>

        <p>
          Already have an account?{' '}
          <button type="button" onClick={handleLogin} className="login-link">
            Login
          </button>
        </p>
      </form>
    </div>
  );
};

export default SignUp;