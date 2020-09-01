import Vue from 'vue';

// Event bus for communicating between vanilla and Vue
/**
 * Available events:
 * 
 * - AddToBasket
 * - RemovedFromBasket
 */
window.Event = new class {
    constructor() {
        this.vue = new Vue();
    }

    fire(event, data = null) {
        this.vue.$emit(event, data);
    }

    listen(event, callback) {
        this.vue.$on(event, callback);
    }

    remove(event, callback) {
        this.vue.$off(event, callback);
    }
}

let cards = document.getElementsByClassName("card-basket-button");

for (let i = 0; i < cards.length; i++) {
    cards[i].addEventListener("click", (event) => {

        if (cards[i].innerText == "Remove from basket") {
            cards[i].className = "card-basket-button";
            cards[i].innerText = "Add to basket";
        } else {
            event.target.className = `${event.target.className} card-basket-button-remove`
            cards[i].innerText = "Remove from basket";
        }

        Event.fire("AddToBasket", event.target.dataset.offerId);
    });
}

Event.listen("RemovedFromBasket", (offerId) => {
    for (let i = 0; i < cards.length; i++) {
        if (offerId == cards[i].dataset.offerId) {
            cards[i].className = "card-basket-button";
            cards[i].innerText = "Add to basket";
            break;
        }
    }
});