<template>
  <a-row align="middle" class="to-center">
    <a-col :span="8" :offset="8">
      <a-form layout="horizontal" :form="form" @submit="handleSubmit">
        <a-form-item>
          <h1 class="centent-center">账号注册</h1>
        </a-form-item>

        <a-form-item
          :validate-status="userNameError() ? 'error' : ''"
          :help="userNameError() || ''"
        >
          <a-input
            size="large"
            v-decorator="[
          'userName',
          { rules: [{ required: true, message: 'Please input your username!' }] },
        ]"
            placeholder="用户名"
          >
            <a-icon slot="prefix" type="user" style="color:rgba(0,0,0,.25)" />
          </a-input>
        </a-form-item>

        <a-form-item
          :validate-status="passwordError() ? 'error' : ''"
          :help="passwordError() || ''"
        >
          <a-input
            size="large"
            v-decorator="[
          'password',
          { rules: [{ required: true, message: 'Please input your Password!' }] },
        ]"
            type="password"
            placeholder="密码"
          >
            <a-icon slot="prefix" type="lock" style="color:rgba(0,0,0,.25)" />
          </a-input>
        </a-form-item>
        <a-form-item
          :validate-status="passwordError() ? 'error' : ''"
          :help="passwordError() || ''"
        >
          <a-input
            size="large"
            v-decorator="[
          'password',
          { rules: [{ required: true, message: 'Please input your Password!' }] },
        ]"
            type="password"
            placeholder="确认密码"
          >
            <a-icon slot="prefix" type="lock" style="color:rgba(0,0,0,.25)" />
          </a-input>
        </a-form-item>

        <a-form-item>
          <a-input size="large" placeholder="邮箱">
            <a-icon type="mail" slot="prefix" style="color:rgba(0,0,0,.25)" />
          </a-input>
        </a-form-item>

        <a-form-item>
          <a-input size="large" placeholder="姓名">
            <a-icon type="smile" slot="prefix" style="color:rgba(0,0,0,.25)" />
          </a-input>
        </a-form-item>

        <a-form-item class="centent-center">
          <a-radio-group defaultValue="1">
            <a-radio value="1">
              <a-icon type="man" size="large" style="color:rgba(0,0,0,.25)" />&nbsp;男
            </a-radio>
            <a-radio value="2">
              <a-icon type="man" size="large" style="color:rgba(0,0,0,.25)" />&nbsp;女
            </a-radio>
          </a-radio-group>
        </a-form-item>

        <a-form-item>
          <a-row>
            <a-col :span="4" offset="4">
              <a-button size="large" type="primary" html-type="submit">
                <router-link to="/login">登录</router-link>
              </a-button>
            </a-col>
            <a-col :span="4" offset="8">
              <a-button
                type="primary"
                size="large"
                html-type="submit"
                :disabled="hasErrors(form.getFieldsError())"
              >注册</a-button>
            </a-col>
          </a-row>
        </a-form-item>
      </a-form>
    </a-col>
  </a-row>
</template>


<script>
function hasErrors(fieldsError) {
  return Object.keys(fieldsError).some(field => fieldsError[field]);
}
export default {
  data() {
    return {
      hasErrors,
      form: this.$form.createForm(this, { name: "horizontal_login" })
    };
  },
  mounted() {
    this.$nextTick(() => {
      // To disabled submit button at the beginning.
      this.form.validateFields();
    });
  },
  methods: {
    // Only show error after a field is touched.
    userNameError() {
      const { getFieldError, isFieldTouched } = this.form;
      return isFieldTouched("userName") && getFieldError("userName");
    },
    // Only show error after a field is touched.
    passwordError() {
      const { getFieldError, isFieldTouched } = this.form;
      return isFieldTouched("password") && getFieldError("password");
    },
    handleSubmit(e) {
      e.preventDefault();
      this.form.validateFields((err, values) => {
        if (!err) {
          console.log("Received values of form: ", values);
        }
      });
    }
  }
};
</script>

<style scoped>
.to-center {
  overflow: hidden;
  margin-top: 5%;
  /* margin-bottom: 10%; */
  position: fixed;
  height: 100%;
  width: 100%;
}
.centent-center {
  text-align: center;
}
</style>

