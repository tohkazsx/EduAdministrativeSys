<template>
  <a-layout style="position:fixed; width: 100%; height: 100%;">
    <a-layout-header class="header">
      <a-row>
        <a-col :span="6">
          <a-button @click="toHomeView" ghost type="link">
            <h1 style="font-size: 28px; font-weight: bolder; color: white">教务管理系统</h1>
          </a-button>
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
          ref="menuSider"
          theme="dark"
          mode="inline"
          :style="{ height: '100%', borderRight: 0, color: 'white' }"
          @select="itemSelected"
        >
          <a-sub-menu key="sub2" v-if="userrole != 'student'">
            <span slot="title">
              <a-icon type="usergroup-add" />人员管理
            </span>
            <a-menu-item key="admin-mgt" v-if="userrole == 'admin'">管理员管理</a-menu-item>
            <a-menu-item key="teacher-mgt" v-if="userrole == 'admin'">教师管理</a-menu-item>
            <a-menu-item key="student-mgt" v-if="userrole != 'student'">学生管理</a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub3" v-if="userrole == 'admin'">
            <span slot="title">
              <a-icon type="solution" />组织管理
            </span>
            <a-menu-item key="depart-mgt">系别管理</a-menu-item>
            <a-menu-item key="class-mgt">班级管理</a-menu-item>
          </a-sub-menu>
          <a-sub-menu key="sub4">
            <span slot="title">
              <a-icon type="profile" />教学信息管理
            </span>
            <a-menu-item key="course-mgt" v-if="userrole == 'admin'">课程管理</a-menu-item>
            <a-menu-item key="student-course-mgt">学生课程</a-menu-item>
            <a-menu-item key="student-score">学生成绩</a-menu-item>
            <a-menu-item key="teacher-score" v-if="userrole != 'student'">教师成绩</a-menu-item>
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
          <init-page v-if="currentContent == 'init-page'" :userrole="userrole" :userinfo="userinfo"></init-page>
          <admin-mgt v-if="currentContent == 'admin-mgt'" :userrole="userrole" :userinfo="userinfo"></admin-mgt>
          <student-mgt
            v-if="currentContent == 'student-mgt'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></student-mgt>
          <teacher-mgt
            v-if="currentContent == 'teacher-mgt'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></teacher-mgt>
          <depart-mgt
            v-if="currentContent == 'depart-mgt'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></depart-mgt>
          <class-mgt v-if="currentContent == 'class-mgt'" :userrole="userrole" :userinfo="userinfo"></class-mgt>
          <course-mgt
            v-if="currentContent == 'course-mgt'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></course-mgt>
          <student-course-mgt
            v-if="currentContent == 'student-course-mgt'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></student-course-mgt>
          <student-score
            v-if="currentContent == 'student-score'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></student-score>
          <teacher-score
            v-if="currentContent == 'teacher-score'"
            :userrole="userrole"
            :userinfo="userinfo"
          ></teacher-score>
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
import InitPage from "./initPage";
import AdminMgt from "./adminMgt";
import StudentMgt from "./studentMgt";
import TeacherMgt from "./teacherMgt";
import DepartMgt from "./departMgt";
import ClassMgt from "./classMgt";
import CourseMgt from "./courceMgt";
import StudentCourseMgt from "./studentCourseMgt";
import StudentScore from "./studentScore";
import TeacherScore from "./teacherScore";

export default {
  components: {
    TeacherMgt,
    StudentMgt,
    AdminMgt,
    InitPage,
    DepartMgt,
    ClassMgt,
    CourseMgt,
    StudentCourseMgt,
    StudentScore,
    TeacherScore
  },
  data() {
    return {
      collapsed: false,
      username: this.$store.state.name,
      userno: this.$route.query.user,
      userrole: this.$route.query.role,
      userinfo: {},
      headerPrompt: "教务管理",
      currentContent: "init-page"
    };
  },
  mounted() {
    this.getUserInfo();
  },
  methods: {
    itemSelected(selected) {
      // console.log(selected)
      this.headerPrompt = selected.item.$el.innerText;
      this.currentContent = selected.key;
      // console.log(this.currentContent)
    },
    getUserInfo() {
      this.$axios
        .post("/getuserinfo", {
          user_no: this.userno,
          user_role: this.userrole
        })
        .then(responce => {
          this.userinfo = responce.data;
        })
        .catch(err => {
          console.log(err);
        });
    },
    toHomeView() {
      this.$refs.menuSider.setOpenKeys([]);
      this.headerPrompt = "教务管理";
      this.currentContent = "init-page";
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
