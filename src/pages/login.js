import React, { useState } from 'react';
import './css/login.css';

const Login = ({ setPage }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const handleSubmit = (e) => {
    //DO SOMETHING
  };

  return (
    <div className="login-container">
      <h2>Login</h2>
      <form className="login-form">
        <label>Username:</label>
        <input type="text" placeholder="Enter your username" value={username} onChange={(e) => setUsername(e.target.value)} />

        <label>Password:</label>
        <input type="password" placeholder="Enter your password" value={password} onChange={(e) => setPassword(e.target.value)} />

        <form className="login-form" onSubmit={handleSubmit}>
         <button type="submit" className="login-btn">Login</button>
        </form>
        <p>
          Don't have an account?{' '}
          <button type="button" onClick={() => setPage('register')} className="signup-link">
            Sign Up
          </button>
        </p>
      </form>
    </div>
  );
};

export default Login;