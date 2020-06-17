<template>
  <a-row align="middle" class="to-center">
    <a-col :span="8" :offset="8">
      <a-form layout="horizontal" :form="form" @submit="handleSubmit">
        <a-card style="background-color: rgba(255,255,255,0.1);">
          <a-layout>
            <a-layout-header style="background-color: #3C7ACF">
              <h1 class="centent-center">重置密码</h1>
            </a-layout-header>

            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item
                :validate-status="userNameError() ? 'error' : ''"
                :help="userNameError() || ''"
              >
                <a-input
                  size="large"
                  disabled
                  v-decorator="[
          'username',
        ]"
                  placeholder="用户名"
                >
                  <a-icon slot="prefix" type="user" style="color:rgba(0,0,0,.25)" />
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
          { rules: [{ required: true, message: '请输入新密码' }] },
        ]"
                  type="password"
                  placeholder="新密码"
                >
                  <a-icon slot="prefix" type="lock" style="color:rgba(0,0,0,.25)" />
                </a-input>
              </a-form-item>
            </a-layout-header>
            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item
                :validate-status="confirmPassError() ? 'error' : ''"
                :help="confirmPassError() || ''"
              >
                <a-input
                  size="large"
                  v-decorator="[
          'confirm_pass',
          { rules: [{ required: true, message: '请再次确认密码' }] },
        ]"
                  type="password"
                  placeholder="确认密码"
                >
                  <a-icon slot="prefix" type="lock" style="color:rgba(0,0,0,.25)" />
                </a-input>
              </a-form-item>
            </a-layout-header>
            <a-layout-header style="background-color: #3C7ACF">
              <a-form-item>
                <a-row>
                  <a-col :span="4" offset="10">
                    <a-button size="large" type="primary" html-type="submit">确认重置</a-button>
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
import { Modal } from "ant-design-vue";
import md5 from "js-md5";

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
      const { setFieldsValue } = this.form;
      setFieldsValue({ username: this.$route.query.user });
    });
  },
  methods: {
    userNameError() {
      // 解构赋值: 创建 getFieldError 变量, 将this.form.getFieldError赋值给它
      const { getFieldError, isFieldTouched } = this.form;
      return isFieldTouched("username") && getFieldError("username");
    },
    // Only show error after a field is touched.
    passwordError() {
      const { getFieldError, isFieldTouched, getFieldValue } = this.form;
      return (
        isFieldTouched("password") &&
        (getFieldError("password") ||
          this.handlePassword(
            getFieldValue("username"),
            getFieldValue("password")
          ))
      );
    },
    confirmPassError() {
      const { getFieldError, isFieldTouched, getFieldValue } = this.form;
      return (
        isFieldTouched("confirm_pass") &&
        (getFieldError("confirm_pass") ||
          this.handleConfirmPass(
            getFieldValue("password"),
            getFieldValue("confirm_pass")
          ))
      );
    },
    handlePassword(user, password) {
      return password.length >= 6
        ? password != user
          ? ""
          : "密码不能与用户名相同"
        : "密码长度必须不小于6";
    },
    handleConfirmPass(password, confirm_pass) {
      return password === confirm_pass ? "" : "两次输入密码不一致";
    },
    handleSubmit(e) {
      e.preventDefault();
      this.form.validateFields((err, values) => {
        if (!err) {
          this.$axios
            .post("/resetpass", {
              username: values.username,
              password: md5(values.password)
            })
            .then(responce => {
              this.onResetSucc();
            })
            .catch(err => {
              this.error("重置密码失败：" + err);
            });
        } else {
          this.error("重置密码失败：" + err);
        }
      });
    },
    error(msg) {
      Modal.error({
        title: "提示：",
        content: msg
      });
    },
    onResetSucc() {
      let secondsToGo = 3;
      const modal = Modal.success({
        title: "提示",
        content: `密码修改成功, ${secondsToGo} 秒后跳转到登陆页面`
      });
      const interval = setInterval(() => {
        secondsToGo -= 1;
        modal.update({
          content: `密码修改成功, ${secondsToGo} 秒后跳转到登陆页面`
        });
      }, 1000);
      setTimeout(() => {
        clearInterval(interval);
        modal.destroy();
        this.$router.push({
          path: "/login",
          query: { user: this.$route.query.user, role: this.$route.query.role }
        });
      }, secondsToGo * 1000);
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

