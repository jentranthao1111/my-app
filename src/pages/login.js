import React, { useState } from 'react';
import './css/login.css';

const Login = ({ setPage }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const handleSubmit = (e, role) => {
    e.preventDefault(); // Prevent default page reload

    if (role === 'user') {
      // authenticate sign in as user
      // if authentication works, then -> setPage('mainpageuser')
    } else if (role === 'employee') {
      // authenticate sign in as employee
      // if authentication works, then -> setPage('mainpageemployee')
    }
  };

  const handleSignUp = () => {
    setPage('signup');
  };
  

  return (
    <div className="login-container">
      <h2>Login</h2>
      <form className="login-form">
        <label>Username:</label>
        <input type="text" placeholder="Enter your email" value={username} onChange={(e) => setUsername(e.target.value)} />

        <label>Password:</label>
        <input type="password" placeholder="Enter your password" value={password} onChange={(e) => setPassword(e.target.value)} />

        <button type="button" onClick={(e) => handleSubmit(e, 'user')} className="login-btn">
          Login
        </button>

        <button type="button" onClick={(e) => handleSubmit(e, 'employee')} className="login-btn">
          Login as Employee
        </button>

        <p>
          Don't have an account?{' '}
          <button type="button" onClick={handleSignUp} className="signup-btn">
            Sign Up
          </button>

        </p>
      </form>
    </div>
  );
};

export default Login;