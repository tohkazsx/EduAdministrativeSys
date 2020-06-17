<template>
  <a-layout id="layout-responsive" style="position: fixed; width: 100%; height: 100%">
    <a-layout-sider
      breakpoint="lg"
      collapsed-width="0"
      @collapse="onCollapse"
      @breakpoint="onBreakpoint"
    >
      <div class="logo" style="text-align: center"><h2>教务管理系统</h2></div>
      <a-menu theme="dark" mode="inline" :default-selected-keys="['1']">
        <a-menu-item key="1">
          <a-icon type="user"/>
          <span class="nav-text">nav 1</span>
        </a-menu-item>
        <a-menu-item key="2">
          <a-icon type="video-camera"/>
          <span class="nav-text">nav 2</span>
        </a-menu-item>
        <a-menu-item key="3">
          <a-icon type="upload"/>
          <span class="nav-text">nav 3</span>
        </a-menu-item>
        <a-menu-item key="4">
          <a-icon type="user"/>
          <span class="nav-text">nav 4</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <a-layout-header :style="{ background: '#fff', padding: 0 }">

      </a-layout-header>
      <a-layout-content :style="{ margin: '24px 16px 0' }">
        <div id="content" :style="{ padding: '24px', background: '#fff', minHeight: '360px', height: '100%' }">

        </div>
      </a-layout-content>
      <a-layout-footer style="text-align: center">
        <a-tag>数据库课设 @2020 Create By Aliver. Contact Me
          <a-tag color="blue">aliver_len@qq.com</a-tag>
        </a-tag>
      </a-layout-footer>
    </a-layout>
  </a-layout>
</template>
<script>
  export default {

  }
</script>

<style>
  #layout-responsive .logo {
    height: 32px;
    background: rgba(255, 255, 255, 1);
    margin: 16px;
  }
</style>
