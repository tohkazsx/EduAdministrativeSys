<template>
  <a-layout style="position:fixed; width: 100%; height: 100%;">
    <a-layout-header class="header">
      <a-row>
        <a-col :span="6">
          <h1 style="font-size: 28px; font-weight: bolder; color: white">教务管理系统</h1>
        </a-col>
        <a-col :span="3" :offset="11">
          <h3 style="color: white">欢迎您，{{ username }} ！</h3>
        </a-col>
        <a-col :span="2">
          <h3 v-if="userrole === 'admin'" style="color: white">
            <a-icon type="user" />&nbsp;管理员
          </h3>
          <h3 v-else-if="userrole === 'teacher'" style="color: white">
            <a-icon type="user" />&nbsp;教师
          </h3>
          <h3 v-else style="color: white">
            <a-icon type="user" />&nbsp;学生
          </h3>
        </a-col>
        <a-col :span="2">
          <router-link to="/login" style="color: white">
            <a-icon type="logout" />&nbsp;退出登录
          </router-link>
        </a-col>
      </a-row>
    </a-layout-header>
    <a-layout>
      <a-layout-sider width="200" class="side-bar">
        <a-menu
          theme="dark"
          mode="inline"
          :style="{ height: '100%', borderRight: 0, color: 'white' }"
          @select="itemSelected"
        >
          <a-sub-menu key="sub1" v-if="userrole != 'student'">
            <span slot="title">
              <a-icon type="usergroup-add" />人员管理
            </span>
            <a-menu-item key="1" v-if="userrole == 'admin'">管理员管理</a-menu-item>
            <a-menu-item key="2" v-if="userrole == 'admin'">教师管理</a-menu-item>
            <a-menu-item key="3" v-if="userrole != 'student'">学生管理</a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub2" v-if="userrole == 'admin'">
            <span slot="title">
              <a-icon type="solution" />组织管理
            </span>
            <a-menu-item key="5">系别管理</a-menu-item>
            <a-menu-item key="6">班级管理</a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub3">
            <span slot="title">
              <a-icon type="profile" />教学信息管理
            </span>
            <a-menu-item key="9" v-if="userrole == 'admin'">课程管理</a-menu-item>
            <a-menu-item key="9">学生课程</a-menu-item>
            <a-menu-item key="9">学生选课</a-menu-item>
            <a-menu-item key="10">学生成绩</a-menu-item>
            <a-menu-item key="11" v-if="userrole != 'student'">教师成绩</a-menu-item>
          </a-sub-menu>
        </a-menu>
      </a-layout-sider>
      <a-layout style="padding: 0 0px 24px 0">
        <a-layout-header style="background-color: white; color: black">
          <h2 style="font-weight: 600;">{{headerPrompt}}</h2>
        </a-layout-header>

        <a-layout-content
          :style="{ background: '#fff', padding: '24px', margin: '16px 24px 0 24px', minHeight: '280px' }"
        >
          <keep-alive>
            <component :is="currentContent"></component>
          </keep-alive>
        </a-layout-content>
        <a-layout-footer style="text-align: center">
          数据库课设 @2020 Create By Aliver. Contact Me
          <a-tag color="blue">aliver_len@qq.com</a-tag>
        </a-layout-footer>
      </a-layout>
    </a-layout>
  </a-layout>
</template>
<script>

  import initPage from './initPage'

export default {
  comments: {
    initPage,
  },
  data() {
    return {
      collapsed: false,
      username: this.$store.state.name,
      userno: this.$route.query.user,
      userrole: this.$route.query.role,
      headerPrompt: "教务管理",
      currentContent: initPage
    };
  },
  methods : {
    itemSelected(selected) {
      // console.log(selected)
      this.header_prompt = selected.item.$el.innerText
    }
  }
};
</script>

<style>
.header {
  background-color: #2358e3;
  color: white;
}
.side-bar {
  color: white;
  background-color: #343345;
}
</style>
