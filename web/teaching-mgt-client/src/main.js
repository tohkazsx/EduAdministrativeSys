// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import { DatePicker, Button, Layout, Menu, Breadcrumb, Icon, Form, Input, Row, Col, Radio, Modal } from 'ant-design-vue'
import axios from "axios"
import store from "./router/store"

import './css/global.css'

Vue.config.productionTip = false;
Vue.prototype.$axios = axios;

// axios.defaults.headers.common['Access-Control-Allow-Origin'] = '*';

axios.defaults.baseURL = '/api';

Vue.use(DatePicker);
Vue.use(Button);
Vue.use(Layout);
Vue.use(Menu);
Vue.use(Breadcrumb);
Vue.use(Icon);
Vue.use(Form);
Vue.use(Input);
Vue.use(Row);
Vue.use(Col);
Vue.use(Radio);
Vue.use(Modal);

// 添加路由器拦截
router.beforeEach(async (to, from, next) => {
  if (to.matched.some(record => record.meta.requireAuth)) {
    if (store.state.token) {
      // this.$router.push({path : to.fullPath})
      next()
    } else {
      // next({ path: '/login', query: { redirect: to.fullPath } })
      next({ path: '/login' })
    }
  } else {
    next()
  }
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
