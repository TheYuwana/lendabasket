<template>
  <div id="app">
    <img
      v-on:click="toggleSidebar()"
      class="shopping-basket-icon"
      src="./images/icons/shopping_basket.svg"
    />
    <div v-if="totalItems > 0" v-on:click="toggleSidebar()" class="shopping-basket-amount">
      <p>{{ totalItems }}</p>
    </div>
    <div :class="sidebarClasses()">
      <BasketForm v-on:close-basket="toggleSidebar()" v-if="sidebarOpen" />
    </div>
  </div>
</template>

<script>
import BasketForm from "./components/BasketForm";
import { mapState } from "vuex";
export default {
  name: "App",
  components: {
    BasketForm,
  },
  data() {
    return {
      sidebarOpen: false,
      hideSideBar: true,
      totalItems: 0,
    };
  },
  computed: {
    ...mapState(["basketItems"]),
  },
  watch: {
    basketItems(newValue, oldValue) {
      this.totalItems = newValue.length;
    },
  },
  mounted() {
    Event.listen("AddToBasket", this.onAddBasket);
  },
  destroyed() {
    Event.remove("AddToBasket", this.onAddBasket);
  },
  methods: {
    onAddBasket(offerId) {
      this.$store.commit("editBasketItems", offerId);
    },
    toggleSidebar() {
      if (this.sidebarOpen) {
        this.sidebarOpen = false;
        setTimeout(() => {
          this.hideSideBar = true;
        }, 200);
      } else {
        this.hideSideBar = false;
        setTimeout(() => {
          this.sidebarOpen = true;
        }, 100);
      }
    },
    sidebarClasses() {
      return {
        "shopping-basket-sidebar": true,
        "shopping-basket-sidebar-open": this.sidebarOpen,
        "shopping-basket-sidebar-hide": this.hideSideBar,
      };
    },
  },
};
</script>

<style scoped lang="scss">
@import "~bootstrap/scss/functions";
@import "./stylesheets/variables.scss";
#app {
  position: fixed;
  top: 0px;
  right: 0px;
  z-index: 2060;

  .shopping-basket-icon {
    width: 35px;
    position: absolute;
    top: 17px;
    right: 20px;

    &:hover {
      cursor: pointer;
    }
  }

  .shopping-basket-amount {
    position: absolute;
    top: 35px;
    right: 42px;
    background-color: $coral;
    border-radius: 25px;
    width: 25px;
    height: 25px;
    text-align: center;
    p {
      color: white;
      padding: 0px;
      margin: 4px 0px 0px 0px;
      font-size: 0.7rem;
    }
  }

  .shopping-basket-sidebar {
    height: calc(100vh - 72px);
    width: 400px;
    background-color: white;
    margin-top: 72px;
    transform: translate(400px, 0px);
    transition: transform 0.2s;
    overflow-y: scroll;

    -webkit-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);
    -moz-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);

    &-open {
      transform: translate(0px, 0px);
    }

    &-hide {
      display: none;
    }
  }
}
</style>
