<template>
  <a-layout>
    <a-descriptions title="个人信息" bordered size="default" style="background-color: white" layout="vertical">
      <a-descriptions-item :label="noLabel">{{userinfo.userno}}</a-descriptions-item>
      <a-descriptions-item label="姓名">{{userinfo.username}}</a-descriptions-item>
      <a-descriptions-item label="性别" v-if="userrole != 'admin'">{{userinfo.usersex}}</a-descriptions-item>
      <a-descriptions-item label="入学时间" v-if="userrole == 'student'">{{userinfo.enter_date}}</a-descriptions-item>
      <a-descriptions-item label="班级" v-if="userrole == 'student'">{{userinfo.class_name}}</a-descriptions-item>
      <a-descriptions-item label="班主任" v-if="userrole == 'student'">{{userinfo.teach_name + ` (${userinfo.teach_phone})`}}</a-descriptions-item>
      <a-descriptions-item label="院系" v-if="userrole != 'admin'">{{userinfo.departname}}</a-descriptions-item>
      <a-descriptions-item label="联系方式" v-if="userrole != 'student'">{{userinfo.userphone}}</a-descriptions-item>
    </a-descriptions>
  </a-layout>
</template>

<script>
export default {
  props: {
    userrole: {
      type: String,
      require: true
    },
    userinfo: {
      type: Object,
      require: true
    }
  },
  data() {
    return {
      noLabel: this.userrole == "student" ? "学号" : "工号"
    };
  },
  watch: {
    userrole: function(newVal, oldVal) {
      console.log(userinfo)
      this.noLabel = newVal == "student" ? "学号" : "工号";
    }
  }
};
</script>

<style>
.larger-font {
  font-size: 20px;
  font-weight: 600;
}
</style>
