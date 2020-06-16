// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import { DatePicker, Button, Layout, Menu, Breadcrumb, Icon, Form, Input, Row, Col, Radio, Modal } from 'ant-design-vue'
import axios from "axios";

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

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App},
  template: '<App/>'
})
