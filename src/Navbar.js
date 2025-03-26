// export default function Navbar(){
//     return <nav className="nav">
// <a href="/" className="site-title">Hotel Ecomerce</a>
//     <ul>
//         <li>
//             <a href="/pricing">Pricing</a>
//             <a href="/suits">Suites</a>
//         </li>        
//     </ul>
//     </nav>
// }


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
