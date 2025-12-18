import { useEffect, useState } from 'react'

function App() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    // Replace with your production URL later in CI/CD
    fetch('http://localhost:8000/products')
      .then(res => res.json())
      .then(data => setProducts(data))
      .catch(err => console.error("Error fetching products:", err));
  }, []);

  return (
    <div style={{ padding: '20px', fontFamily: 'sans-serif' }}>
      <h1>My Practice Shop</h1>
      <div style={{ display: 'grid', gap: '10px' }}>
        {products.map(product => (
          <div key={product.id} style={{ border: '1px solid #ccc', padding: '10px' }}>
            <h3>{product.name}</h3>
            <p>${product.price}</p>
            <button>Add to Cart</button>
          </div>
        ))}
      </div>
    </div>
  )
}

export default App