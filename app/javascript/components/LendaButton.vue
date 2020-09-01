<template>
  <div class="lenda-button">
    <button :disabled="disabled" v-on:click="buttonClicked()" :class="buttonClasses()">{{ label }}</button>
  </div>
</template>

<script>
export default {
  name: "LendaButton",
  props: {
    label: {
      type: String,
      default: "",
    },
    type: {
      type: String,
      default: "ok",
    },
  },
  data() {
    return {
      inputVvalue: "",
      disabled: false,
    };
  },
  methods: {
    buttonClicked() {
      this.$emit("button-event");
    },
    setDisabled(state) {
      this.disabled = state;
    },
    buttonClasses() {
      const classes = {
        "lenda-button-btn": true,
      };
      /* 
                Options:
                - ok
                - back
            */
      classes[`lenda-button-btn-${this.$props.type}`] = true;
      return classes;
    },
  },
};
</script>

<style lang="scss">
@import "~bootstrap/scss/functions";
@import "../stylesheets/variables.scss";
.lenda-button {
  .lenda-button-btn {
    margin: 5px;
    padding: 5px 20px;
    border-radius: 25px;
    font-size: 1rem;
    border: 0px;
    transition: opacity 0.3s;
    color: white;

    &:disabled {
      opacity: 0.5;
      cursor: not-allowed;
      &:hover {
        opacity: 0.5;
      }
    }

    &-ok {
      background-color: $teal;
    }

    &-back {
      background-color: $coral;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
