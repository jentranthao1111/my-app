import React from 'react';
import './Navbar.css'; // Make sure you create and import a separate CSS file for styling

export default function Navbar() {
  return (
    <nav className="nav">
      <a href="/" className="site-title">Hotel E-Commerce</a>
      <ul className="nav-links">
        <li>
          <a href="/pricing">Pricing</a>
        </li>
        <li>
          <a href="/suits">Suites</a>
        </li>
      </ul>
    </nav>
  );
}