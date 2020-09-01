<template>
  <div class="offer-investment">
    <label :for="generateInputId()">{{ name }}</label>
    <input
      :id="generateInputId()"
      type="number"
      min="0"
      :max="maxInvestment"
      :placeholder="generatePlaceholder()"
      v-model="localValue"
      v-on:input="updateValue($event)"
    />
  </div>
</template>

<script>
export default {
  name: "OfferInvestment",
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
    maxInvestment: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      localValue: "",
    };
  },
  methods: {
    generateInputId() {
      return `offer-investment-id-${this.$props.id}`;
    },
    generatePlaceholder() {
      return `max: ${this.$props.maxInvestment}`;
    },
    updateValue(event) {
      this.localValue = event.target.value;
      if (this.localValue > this.$props.maxInvestment) {
        this.localValue = this.$props.maxInvestment;
      }
      this.$emit("input", this.localValue);
    },
    setValue(val) {
      this.localValue = val;
    },
  },
};
</script>

<style scoped lang="scss">
.offer-investment {
  margin-bottom: 10px;
  border-bottom: 1px solid black;
  padding-bottom: 15px;

  label {
    width: 100%;
    font-weight: bold;
  }

  input {
    width: 100%;
  }
}
</style>
