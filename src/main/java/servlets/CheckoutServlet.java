package servlets;

import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

public class CheckoutServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// Initialize your Stripe secret key
    private static final String STRIPE_SECRET_KEY = "sk_test_51R7IsZFKBuG4KLiqTfZQ1WKUE5C7wlFOrWHg813Nv5uTr3SSTU2BqaUkMbmgh13saKHsinK0TWA5xdCwwtLcxQzs00udJJUKfa";

    // Set up your Stripe configuration
    public void init() {
        Stripe.apiKey = STRIPE_SECRET_KEY;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the cart total and the user ID from the session
        Double cartTotal = (Double) request.getSession().getAttribute("cart_total");
        if (cartTotal == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        long amount = Math.round(cartTotal * 100);  // Convert total to cents
        
        try {
            // Create a Stripe Checkout session
            SessionCreateParams params = SessionCreateParams.builder()
                    .setPaymentMethodTypes(Arrays.asList("card"))  // Correct usage of Arrays.asList
                    .setLineItems(Arrays.asList(
                            SessionCreateParams.LineItem.builder()
                                    .setPriceData(
                                            SessionCreateParams.LineItem.PriceData.builder()
                                                    .setCurrency("usd")
                                                    .setUnitAmount(amount)
                                                    .build()
                                    )
                                    .setQuantity(1L)
                                    .build()
                    ))
                    .setMode(SessionCreateParams.Mode.PAYMENT)
                    .setSuccessUrl("http://localhost:8080/success.jsp")  // Redirect on success
                    .setCancelUrl("http://localhost:8080/cancel.jsp")    // Redirect on cancellation
                    .build();

            // Create session using Stripe's API
            Session session = Session.create(params);

            // Send the session URL to the client
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"id\": \"" + session.getId() + "\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Payment processing error");
        }
    }
}
