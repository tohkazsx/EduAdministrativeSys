import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
    state: {
        token : false
    },
    mutations: {
        updateToken(state, token) {
            state.token = token
        }
    }
})

export default store