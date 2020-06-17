import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
    state: {
        token: false,
        name: ""
    },
    mutations: {
        updateToken(state, token) {
            state.token = token
        },
        updateName(state, name) {
            state.name = name
        }
    }
})

export default store