interface Product {
    id: string;
    name: string;
    category: string;
    description: string;
    price_cents: number;
    inventory_count: number;
  }
  
  interface ProductsResponse {
    products: Product[];
    pagination: {
      page: number;
      limit: number;
      total_count: number;
    };
  }
  
  const API_URL = "http://localhost:3000";
  
  async function verifyProducts(): Promise<void> {
    const response = await fetch(`${API_URL}/products`);
  
    if (!response.ok) {
      throw new Error(`Products endpoint failed: ${response.status}`);
    }
  
    const data: ProductsResponse = await response.json();
  
    if (!Array.isArray(data.products)) {
      throw new Error("Expected products to be an array");
    }
  
    console.log(`✓ Products endpoint passed (${data.products.length} products)`);
  }
  
  async function main(): Promise<void> {
    try {
      await verifyProducts();
      console.log("✓ All API checks passed!");
    } catch (error) {
      console.error("✗ API verification failed:", error);
      process.exitCode = 1;
    }
  }
  
  main();