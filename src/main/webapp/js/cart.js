function removeItem(cartId) {
    // Send POST request to remove item from cart
    console.log(`Removing item with ID: ${cartId}`);
    // Add your AJAX or form submission logic here
}

function changeText(dynamicId, itemPrice) {
    // Get the new quantity value
    let quantity = document.getElementById(`textInput${dynamicId}`).value;
    let subtotal = itemPrice * quantity;
    document.getElementById(`subPrice${dynamicId}`).innerText = `Rs.${subtotal}.00`;
    // Optionally, update the total cart value
}
