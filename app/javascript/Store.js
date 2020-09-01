import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        basketItems: []
    },
    getters: {
        getBasketItems: (state) => {
            return state.basketItems;
        }
    },
    mutations: {
        editBasketItems(state, offerId) {
            if (!Number.isInteger(offerId)) {
                offerId = parseInt(offerId)
            }

            if (state.basketItems.includes(offerId)) {
                state.basketItems.splice(state.basketItems.indexOf(offerId), 1);
            } else {
                state.basketItems.push(offerId);
            }
        },
        resetBasketItems(state) {
            state.basketItems = [];
        }
    }
})