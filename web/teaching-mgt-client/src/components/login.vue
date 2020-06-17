<template>
  <a-row align="middle" class="to-center">
    <a-col :span="6" :offset="9">
      <a-form layout="horizontal" :form="form" @submit="handleSubmit">
        <a-card style="background-color: rgba(255,255,255,0.1);">
          <a-layout>
            <a-layout-header style="background-color: #3C7ACF">
              <!--        <a-form-item>-->
              <h1 class="centent-center" style="color: white">教务管理系统</h1>
              <!--        </a-form-item>-->
            </a-layout-header>
            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item
                :validate-status="userNameError() ? 'error' : ''"
                :help="userNameError() || ''"
              >
                <a-input
                  size="large"
                  v-decorator="[
          'username',
          { rules: [{ required: true, message: '请输入用户名！' }] },
        ]"
                  placeholder="用户名"
                >
                  <a-icon slot="prefix" type="user" style="color:rgba(0,0,0,.25)"/>
                </a-input>
              </a-form-item>
            </a-layout-header>
            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item
                :validate-status="passwordError() ? 'error' : ''"
                :help="passwordError() || ''"
              >
                <a-input
                  size="large"
                  v-decorator="[
          'password',
          { rules: [{ required: true, message: '请输入密码！' }] },
        ]"
                  type="password"
                  placeholder="密码"
                >
                  <a-icon slot="prefix" type="lock" style="color:rgba(0,0,0,.25)"/>
                </a-input>
              </a-form-item>
            </a-layout-header>
            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item>
                <a-row>
                  <a-col :span="8" offset="8">
                    <a-button
                      block
                      size="large"
                      type="primary"
                      html-type="submit"
                      :disabled="hasErrors(form.getFieldsError())"
                    >登录
                    </a-button>
                  </a-col>
                </a-row>
              </a-form-item>
            </a-layout-header>
          </a-layout>
        </a-card>
      </a-form>
    </a-col>
  </a-row>
</template>

<script>
  import {Modal} from "ant-design-vue";
  // import axios from "axios";
  import md5 from "js-md5";

  export default {
    data() {
      return {
        hasErrors: function (fieldsError) {
          return Object.keys(fieldsError).some(field => fieldsError[field]);
        },
        form: this.$form.createForm(this, {name: "horizontal_login"})
      };
    },
    mounted() {
      this.$nextTick(() => {
        // To disabled submit button at the beginning.
        this.form.validateFields();
        if (this.$route.query.user) {
          this.form.setFieldsValue({username: this.$route.query.user})
        }
      });
    },
    methods: {
      // Only show error after a field is touched.
      userNameError() {
        // 解构赋值: 创建 getFieldError 变量, 将this.form.getFieldError赋值给它
        const {getFieldError, isFieldTouched, getFieldValue} = this.form;
        return (
          isFieldTouched("username") &&
          (getFieldError("username") ||
            this.handleUsername(getFieldValue("username")))
        );
      },
      // Only show error after a field is touched.
      passwordError() {
        const {getFieldError, isFieldTouched, getFieldValue} = this.form;
        return (
          isFieldTouched("password") &&
          (getFieldError("password") ||
            this.handlePassword(getFieldValue("password")))
        );
      },
      handleUsername(username) {
        let pattern = new RegExp("^\\d{7}$");
        return pattern.test(username) ? "" : "用户名必须为7位数字";
      },
      handlePassword(password) {
        return password.length >= 6 ? "" : "密码长度必须不小于6";
      },
      handleSubmit(e) {
        e.preventDefault();
        this.form.validateFields((err, values) => {
          if (!err) {
            this.$axios
              .post("/login", {
                username: values.username,
                password: md5(values.password)
              })
              .then(resp => {
                console.log(resp);
                // var data = JSON.parse(resp.data);
                let data = resp.data;
                if (data.result.toLowerCase() == "User Not Found".toLowerCase()) {
                  this.error("用户不存在!");
                } else if (
                  data.result.toLowerCase() == "Password Error".toLowerCase()
                ) {
                  this.error("密码错误!");
                } else {
                  this.$store.commit('updateToken', true)
                  if (data.first == "true") {
                    this.$router.push({
                      path: "/reset_pass",
                      query: {user: values.username, role: data.result}
                    })
                  } else {
                    this.$store.commit('updateName', data.name)
                    this.$router.push({
                      path: "/main",
                      query: {user: values.username, role: data.result}
                    })
                  }
                }
              })
              .catch(err => {
                console.log(err);
                this.error("登录失败!")
              })
          } else {
            this.error("输入参数错误！");
          }
        });
      },

      error(msg) {
        Modal.error({
          title: "提示：",
          content: msg
        })
      }
    }
  };
</script>

<style scoped>
  .to-center {
    overflow: hidden;
    margin-top: 10%;
    /* margin-bottom: 10%; */
    position: fixed;
    height: 100%;
    width: 100%;
  }

  .centent-center {
    text-align: center;
  }
</style>

