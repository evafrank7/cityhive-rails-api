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

  interface CartItem {
    product_id: string;
    name: string;
    quantity: number;
    unit_price_cents: number;
    total_cents: number;
  }
  
  interface CheckoutQuoteResponse {
    items: CartItem[];
    subtotal_cents: number;
    tax_cents: number;
    total_cents: number;
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


  async function verifyCheckoutQuote(): Promise<void> {
    // Get an available product instead of hardcoding a MongoDB ID.
    const productsResponse = await fetch(`${API_URL}/products`);
    if (!productsResponse.ok) {
      throw new Error(`Products endpoint failed: ${productsResponse.status}`);
    }
  
    const productsData: ProductsResponse = await productsResponse.json();
  
    const product = productsData.products.find(
      (item) => item.inventory_count >= 2
    );
  
    if (!product) {
      throw new Error("No product with sufficient inventory found");
    }
  
    // Request a quote for two units.
    const response = await fetch(`${API_URL}/checkout/quote`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        items: [
          {
            product_id: product.id,
            quantity: 2,
          },
        ],
      }),
    });
  
    if (!response.ok) {
      throw new Error(`Checkout quote failed: ${response.status}`);
    }
  
    const data: CheckoutQuoteResponse = await response.json();
  
    // Calculate the expected totals.
    const expectedSubtotal = product.price_cents * 2;
    const expectedTax = Math.round(expectedSubtotal * 0.08);
    const expectedTotal = expectedSubtotal + expectedTax;
  
    if (
      data.subtotal_cents !== expectedSubtotal ||
      data.tax_cents !== expectedTax ||
      data.total_cents !== expectedTotal
    ) {
      throw new Error("Checkout quote totals do not match expected values");
    }
  
    console.log("✓ Checkout quote endpoint passed");
  }

  async function verifyInvalidCheckout(): Promise<void> {
    const response = await fetch(`${API_URL}/checkout/quote`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        items: [],
      }),
    });
  
    if (response.status !== 400) {
      throw new Error(
        `Expected 400 for empty cart, received ${response.status}`
      );
    }
  
    const data: { error: string } = await response.json();
  
    if (data.error !== "Cart is empty") {
      throw new Error("Unexpected error response for empty cart");
    }
  
    console.log("✓ Invalid checkout handling passed");
  }

  async function verifyProductDetails(): Promise<void> {
    const response = await fetch(`${API_URL}/products`);
  
    if (!response.ok) {
      throw new Error(`Products endpoint failed: ${response.status}`);
    }
  
    const data: ProductsResponse = await response.json();
    const product = data.products[0];
  
    if (!product) {
      throw new Error("No products available for verification");
    }
  
    // Fetch the individual product using its MongoDB ID.
    const detailResponse = await fetch(
      `${API_URL}/products/${product.id}`
    );
  
    if (detailResponse.status !== 200) {
      throw new Error(
        `Expected 200 for product details, received ${detailResponse.status}`
      );
    }
  
    const details: Product = await detailResponse.json();
  
    // Verify the returned product matches the requested product.
    if (
      details.id !== product.id ||
      typeof details.name !== "string" ||
      typeof details.price_cents !== "number" ||
      typeof details.inventory_count !== "number"
    ) {
      throw new Error("Product detail response has invalid fields");
    }
  
    console.log("✓ Product detail endpoint passed");
  }
  
  async function main(): Promise<void> {
    try {
      await verifyProducts();
      await verifyCheckoutQuote();
      await verifyInvalidCheckout();
      await verifyProductDetails();
  
      console.log("✓ All API checks passed!");
    } catch (error) {
      console.error("✗ API verification failed:", error);
      process.exitCode = 1;
    }
  }
  
  main();