import React, { useState } from 'react';
import './css/login.css';

const Login = ({ setPage }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const handleSubmit = async (e, role) => {
    e.preventDefault(); // Prevent default page reload

    if (role === 'user') {
      // authenticate sign in as user
      try {
        const response = await fetch('http://localhost:5000/api/customer/validate', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({email, password}),
        });
    
        const data = await response.json();
        console.log("Server response:", data);
    
        if (data.valid) {
          alert("Customer login successfully!");
          localStorage.setItem("cust_id", data.cust_id);
          setPage('mainpageuser');
        } else {
          alert("Registration failed: " + (data.message || JSON.stringify(data)));
        }
      } catch (error) {
        console.error("Network or server error:", error);
        alert("An error occurred. Check console for details.");
      }


     
    } else if (role === 'employee') {

      try {
        const response = await fetch('http://localhost:5000/api/employee/validate', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({email, password}),
        });
    
        const data = await response.json();
        console.log("Server response:", data);
    
        if (data.valid) {
          alert("Employee login successfully!");
          localStorage.setItem("ssn_sid", data.ss_sid);
          setPage('mainpageemployee');
        } else {
          alert("Registration failed: " + (data.message || JSON.stringify(data)));
        }
      } catch (error) {
        console.error("Network or server error:", error);
        alert("An error occurred. Check console for details.");
      }
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
        <input type="text" placeholder="Enter your email" value={email} onChange={(e) => setEmail(e.target.value)} />

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