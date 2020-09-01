const axios = require('axios');
const baseUrl = "http://localhost:3000";

const RequestHandler = {

    listOffers() {
        return axios(urlBuilder('/offers/list'));
    },

    listPaymentOptions() {
        return axios(urlBuilder('/orders/payment-methods'));
    },

    createOrder(orders, paymentMethod) {

        let investments = {};
        for (let i = 0; i < orders.length; i++) {
            let order = orders[i];
            investments[order.id] = order.investmentAmount;
        }

        return axios({
            url: urlBuilder('/orders'),
            headers: { 'X-CSRF-TOKEN': getCSRFToken() },
            method: 'post',
            data: {
                data: {
                    type: "order",
                    attributes: {
                        currency: "EUR",
                        payment_method: paymentMethod,
                        investments: investments
                    }
                }
            }
        })
    }
}
export default RequestHandler;

function urlBuilder(path) {
    return `${baseUrl}${path}`;
}

function getCSRFToken() {
    const metaTags = document.getElementsByTagName("meta");
    let csrfToken = "";
    for (let i = 0; i < metaTags.length; i++) {
        if (metaTags[i].name === "csrf-token") {
            csrfToken = metaTags[i].content;
            break;
        }
    }
    return csrfToken;
}