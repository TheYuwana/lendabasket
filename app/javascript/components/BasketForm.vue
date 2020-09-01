<template>
  <div class="basket-form">
    <h3>Investment Basket</h3>

    <template v-if="selectedOffers.length == 0">
      <p>No offers selected</p>
    </template>

    <template v-if="selectedOffers.length > 0">
      <!-- SELECTED -->
      <div class="basket-form-offers" v-if="formStep === FormSteps.SELECTED">
        <p>You have selected the following offers:</p>
        <MiniOffer
          v-for="offer in selectedOffers"
          :key="offer.id"
          :id="offer.id"
          :name="offer.name"
          :price="offer.funding_target.cents"
          :interest="offer.interest"
          :maturity="offer.maturity_in_months"
          :inverstors="offer.number_of_investors"
        />
        <div class="basket-form-buttons">
          <LendaButton v-on:button-event="goToInvestment()" label="lets invest" />
        </div>
      </div>

      <!-- INVESTMENT -->
      <div class="basket-form-investment" v-if="formStep === FormSteps.INVESTMENT">
        <p>How much would you like to invest?</p>
        <OfferInvestment
          :ref="offer.name"
          v-for="offer in selectedOffers"
          :key="offer.id"
          :id="offer.id"
          :name="offer.name"
          :maxInvestment="offer.maxInvestment"
          v-model="offer.investmentAmount"
        />
        <p :class="messageClasses()">{{ statusMessage }}</p>
        <p>Total: &euro; {{ totalInvestment }}</p>
        <div class="basket-form-buttons">
          <LendaButton v-on:button-event="goToStep(FormSteps.SELECTED)" type="back" label="back" />
          <LendaButton v-on:button-event="goToPayment()" label="confirm" />
        </div>
      </div>

      <!-- PAYMENT -->
      <div class="basket-form-payment" v-if="formStep === FormSteps.PAYMENT">
        <p>Select a payment option.</p>

        <select v-model="selectedPaymentMethod">
          <option disabled value>Please select one</option>
          <option v-for="(paymentOption, index) in paymentOptions" :key="index">{{ paymentOption }}</option>
        </select>

        <p :class="messageClasses()">{{ statusMessage }}</p>
        <p>Total: &euro; {{ totalInvestment }}</p>

        <div class="basket-form-buttons">
          <LendaButton v-on:button-event="goToInvestment()" type="back" label="back" />
          <LendaButton v-on:button-event="confirmPayment()" label="pay" />
        </div>
      </div>

      <!-- CONFIRMED -->
      <div class="basket-form-payment" v-if="formStep === FormSteps.CONFIRMED">
        <p>Order Confirmation</p>

        <p :class="messageClasses()">{{ statusMessage }}</p>

        <div class="basket-form-buttons">
          <LendaButton
            v-if="confirmationStatus === 'success'"
            v-on:button-event="closeBasket()"
            label="close"
          />

          <LendaButton
            v-if="confirmationStatus === 'error'"
            v-on:button-event="goToStep(FormSteps.PAYMENT)"
            type="back"
            label="back"
          />
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import RequestHandler from "../RequestHandler";
import MiniOffer from "./MiniOffer";
import OfferInvestment from "./OfferInvestment";
import LendaButton from "./LendaButton";
import { mapState } from "vuex";

export default {
  name: "BasketForm",
  components: {
    MiniOffer,
    OfferInvestment,
    LendaButton,
  },
  data() {
    return {
      FormSteps: {
        SELECTED: 1,
        INVESTMENT: 2,
        PAYMENT: 3,
        CONFIRMED: 4,
      },
      formStep: 1,
      selectedOffers: [],
      paymentOptions: [],
      selectedPaymentMethod: "",
      statusMessage: "",
      confirmationStatus: "",
    };
  },
  computed: {
    ...mapState(["basketItems"]),
    totalInvestment() {
      let total = 0;
      for (let i = 0; i < this.selectedOffers.length; i++) {
        if (this.selectedOffers[i].investmentAmount != "") {
          total += parseInt(this.selectedOffers[i].investmentAmount);
        }
      }
      return total;
    },
  },
  watch: {
    basketItems(newValue, oldValue) {
      this.getOffers();
    },
  },
  mounted() {
    this.getOffers();
    this.getPaymentMethods();
  },
  methods: {
    getOffers() {
      if (this.formStep === this.FormSteps.PAYMENT) {
        this.formStep = this.FormSteps.SELECTED;
      }

      RequestHandler.listOffers()
        .then((response) => {
          this.selectedOffers = response.data
            .filter((offer) =>
              this.$store.getters.getBasketItems.includes(offer.id)
            )
            .map((offer) => {
              let maxInvestment =
                (offer.funding_target.cents - offer.confirmed_funding.cents) /
                100;

              return {
                id: offer.id,
                name: offer.name,
                funding_target: offer.funding_target,
                interest: offer.interest,
                maturity_in_months: offer.maturity_in_months,
                number_of_investors: offer.number_of_investors,
                confirmed_funding: offer.confirmed_funding,
                maxInvestment: maxInvestment,
                investmentAmount: 0,
              };
            });
        })
        .catch((error) => {
          // console.log(error);
        });
    },
    getPaymentMethods() {
      RequestHandler.listPaymentOptions()
        .then((response) => {
          this.paymentOptions = response.data;
        })
        .catch((error) => {
          // console.log(error);
        });
    },
    goToStep(toStep) {
      this.setMessage("", "");
      this.formStep = toStep;
    },
    goToInvestment() {
      this.setMessage("", "");
      this.formStep = this.FormSteps.INVESTMENT;
      this.$nextTick(() => {
        for (let i = 0; i < this.selectedOffers.length; i++) {
          if (this.selectedOffers[i].investmentAmount != "") {
            this.$refs[this.selectedOffers[i].name][0].setValue(
              this.selectedOffers[i].investmentAmount
            );
          }
        }
      });
    },
    goToPayment() {
      this.setMessage("", "");
      if (this.selectedOffers.every((offer) => offer.investmentAmount > 0)) {
        this.formStep = this.FormSteps.PAYMENT;
      } else {
        this.setMessage("Please fill an amount of investment", "error");
      }
    },
    confirmPayment() {
      this.setMessage("", "");
      if (this.selectedPaymentMethod != "") {
        this.formStep = this.FormSteps.CONFIRMED;
        RequestHandler.createOrder(
          this.selectedOffers,
          this.selectedPaymentMethod
        )
          .then((response) => {
            if (response.status === 201) {
              this.setMessage("Order succesfully processed!", "success");
            }
          })
          .catch((error) => {
            this.setMessage(error.response.data.errors[0].details, "error");
          });
      } else {
        this.setMessage("Please select a payment option", "error");
      }
    },
    messageClasses() {
      return {
        "basket-form-message": true,
        "basket-form-message-success": this.confirmationStatus === "success",
        "basket-form-message-error": this.confirmationStatus === "error",
      };
    },
    closeBasket() {
      this.$store.commit("resetBasketItems");
      this.$emit("close-basket");
    },
    setMessage(message, type) {
      this.statusMessage = message;
      this.confirmationStatus = type;
    },
  },
};
</script>

<style scoped lang="scss">
@import "~bootstrap/scss/functions";
@import "../stylesheets/variables.scss";
.basket-form {
  padding: 20px;

  select {
    width: 100%;
    margin-bottom: 15px;
    padding: 5px;
  }

  &-buttons {
    display: flex;
    justify-content: flex-end;
    flex-wrap: wrap;
  }

  &-message {
    color: black;
    &-success {
      color: $success;
    }
    &-error {
      color: $danger;
    }
  }
}
</style>
