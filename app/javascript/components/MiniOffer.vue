<template>
  <div class="mini-offer">
    <div class="mini-offer-remove lahi-window-close" v-on:click="removeFromBasket(id)"></div>
    <p class="mini-offer-name">{{ name }}</p>
    <ul class="mini-offer-details">
      <li>
        <i class="lahi-percent"></i>
        {{ interest }}
      </li>
      <li>
        <i class="lahi-euro"></i>
        {{ parsePrice() }}
      </li>
      <li>
        <i class="lahi-calendar"></i>
        {{ maturity }}
      </li>
      <li>
        <i class="lahi-users"></i>
        {{ inverstors }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "MiniOffer",
  components: {},
  props: {
    id: {
      type: Number,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    interest: {
      type: Number,
      required: true,
    },
    maturity: {
      type: Number,
      required: true,
    },
    inverstors: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {};
  },
  methods: {
    removeFromBasket(offerId) {
      this.$store.commit("editBasketItems", offerId);
      Event.fire("RemovedFromBasket", offerId);
    },
    parsePrice() {
      return this.$props.price / 100;
    },
  },
};
</script>

<style scoped lang="scss">
@import "~bootstrap/scss/functions";
@import "../stylesheets/variables.scss";
.mini-offer {
  margin-bottom: 25px;
  border-bottom: 1px solid black;
  padding-bottom: 15px;
  position: relative;

  ul {
    margin: 0px;
    padding: 0px;
    li {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 15px;
      margin: 2px;
      color: white;
      background-color: $teal;
      font-size: 0.8rem;
    }
  }

  &-name {
    margin-bottom: 5px;
    font-weight: bold;
    width: 320px;
  }

  &-remove {
    position: absolute;
    top: 0px;
    right: 0px;
    cursor: pointer;
  }
}
</style>
