<template>
  <a-layout style="position:fixed; width: 100%; height: 100%;">
    <a-layout-header class="header">
      <a-row>
        <a-col :span="6">
          <h1 style="font-size: 28px; font-weight: bolder; color: white">教务管理系统</h1>
        </a-col>
        <a-col :span="2" :offset="12">
          <h3 style="color: white">欢迎，{{ username }} ！</h3>
        </a-col>
        <a-col :span="2">
          <h3 v-if="userrole === 'admin'" style="color: white"><a-icon type="user"/> 管理员</h3>
          <h3 v-else-if="userrole === 'teacher'" style="color: white"><a-icon type="user"/> 教师</h3>
          <h3 v-else style="color: white"><a-icon type="user"/> 学生</h3>
        </a-col>
        <a-col :span="2">
          <a-icon type="logout"></a-icon>
          <router-link to="/login" style="color: white">退出登录</router-link>
        </a-col>
      </a-row>
    </a-layout-header>
    <a-layout>
      <a-layout-sider width="200" class="side-bar">
        <a-menu
          theme="dark"
          mode="inline"
          :default-selected-keys="['1']"
          :default-open-keys="['sub1']"
          :style="{ height: '100%', borderRight: 0, color: 'white' }"
        >
          <a-sub-menu key="sub1">
            <span slot="title"><a-icon type="user"/>subnav 1</span>
            <a-menu-item key="1">
              option1
            </a-menu-item>
            <a-menu-item key="2">
              option2
            </a-menu-item>
            <a-menu-item key="3">
              option3
            </a-menu-item>
            <a-menu-item key="4">
              option4
            </a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub2">
            <span slot="title"><a-icon type="laptop"/>subnav 2</span>
            <a-menu-item key="5">
              option5
            </a-menu-item>
            <a-menu-item key="6">
              option6
            </a-menu-item>
            <a-menu-item key="7">
              option7
            </a-menu-item>
            <a-menu-item key="8">
              option8
            </a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub3">
            <span slot="title"><a-icon type="notification"/>subnav 3</span>
            <a-menu-item key="9">
              option9
            </a-menu-item>
            <a-menu-item key="10">
              option10
            </a-menu-item>
            <a-menu-item key="11">
              option11
            </a-menu-item>
            <a-menu-item key="12">
              option12
            </a-menu-item>
          </a-sub-menu>
        </a-menu>
      </a-layout-sider>
      <a-layout style="padding: 0 0px 24px 0">
        <a-layout-header style="background-color: white; color: black">
          <h2 style="font-weight: 600;">成绩管理</h2>
        </a-layout-header>

        <a-layout-content
          :style="{ background: '#fff', padding: '24px', margin: '16px 24px 0 24px', minHeight: '280px' }"
        >
          Content
        </a-layout-content>
        <a-layout-footer style="text-align: center">
          <a-tag>数据库课设 @2020 Create By Aliver. Contact Me
            <a-tag color="blue">aliver_len@qq.com</a-tag>
          </a-tag>
        </a-layout-footer>
      </a-layout>
    </a-layout>
  </a-layout>
</template>
<script>
  export default {
    data() {
      return {
        collapsed: false,
        username: this.$route.query.user,
        userrole: this.$route.query.role
      }
    },
  }
</script>

<style>
  .header {
    background-color: #2358E3;
    color: white;
  }
  .side-bar {
    color: white;
    background-color: #343345;
  }
</style>
