/* eslint no-console: 0 */

import Vue from 'vue'
import App from '../app.vue'
import Vuex from 'vuex'
import Store from '../Store'

Vue.use(Vuex);

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    store: Store,
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)
})

