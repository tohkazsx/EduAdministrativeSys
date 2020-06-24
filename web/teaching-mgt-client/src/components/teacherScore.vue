<template>
  <a-row>
    <a-col>
      <a-button type="primary" @click="get_teach_cousre_info" :loading="loading">刷新</a-button>
      <a-table :columns="Columns" :data-source="course_info" :loading="loading" style="margin-top:24px">
        <template
          v-for="col in ['userno','username','course_no', 'course_name', 'course_date', 'sc_score']"
          :slot="col"
          slot-scope="text, record"
        >
          <div :key="col">
            <a-input
              v-if="record.editable"
              style="margin: -5px 0"
              :value="text"
              @change="e => handleChange(e.target.value, record.key, col)"
            />
            <template v-else>{{ text }}</template>
          </div>
        </template>
      </a-table>
    </a-col>
  </a-row>
</template>

<script>
import { Modal } from "ant-design-vue";
const Columns = [
  {
    title: "工号",
    dataIndex: "userno",
    key: "userno",
    scopedSlots: { customRender: "userno" }
  },
  {
    title: "姓名",
    dataIndex: "username",
    key: "username",
    scopedSlots: { customRender: "username" }
  },
  {
    title: "课号",
    dataIndex: "course_no",
    key: "course_no",
    scopedSlots: { customRender: "course_no" }
  },
  {
    title: "课程",
    dataIndex: "course_name",
    key: "course_name",
    scopedSlots: { customRender: "course_name" }
  },
  {
    title: "课程学期",
    dataIndex: "course_date",
    key: "course_date",
    scopedSlots: { customRender: "course_date" }
  },
  {
    title: "最高分",
    dataIndex: "max_score",
    key: "max_score",
    scopedSlots: { customRender: "max_score" }
  },
  {
    title: "最低分",
    dataIndex: "min_score",
    key: "min_score",
    scopedSlots: { customRender: "min_score" }
  },
  {
    title: "平均分",
    dataIndex: "avg_score",
    key: "avg_score",
    scopedSlots: { customRender: "avg_score" }
  }
];
export default {
  name: "teacherScore",
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
      course_info: [],
      editingKey: "",
      Columns,
      loading: false
    };
  },
  mounted() {
    this.get_teach_cousre_info();
  },
  methods: {
    get_teach_cousre_info() {
      this.loading = true;
      this.$axios
        .post("/getteachcourse", {
          user_no: this.userrole == "admin" ? "%" : this.userinfo.userno
        })
        .then(responce => {
          this.course_info = responce.data;
          console.log(this.course_info)
          for (let i = 0; i < this.course_info.length; i += 1) {
            this.course_info[i].key = i.toString();
          }
          this.cacheData = this.course_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
          this.loading = false;
          console.log(err);
        });
    },
    handleChange(value, key, column) {
      const newData = [...this.course_info];
      const target = newData.filter(item => key === item.key)[0];
      if (target) {
        target[column] = value;
        this.course_info = newData;
      }
    },
    edit(key) {
      const newData = [...this.course_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.course_info = newData;
      }
    },
    save(key) {
      const newData = [...this.course_info];
      const newCacheData = [...this.cacheData];
      const target = newData.filter(item => key === item.key)[0];
      const targetCache = newCacheData.filter(item => key === item.key)[0];
      if (target && targetCache) {
        delete target.editable;
        this.course_info = newData;
        Object.assign(targetCache, target);
        this.cacheData = newCacheData;
      }
      this.editingKey = "";
    },
    cancel(key) {
      const newData = [...this.course_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = "";
      if (target) {
        Object.assign(
          target,
          this.cacheData.filter(item => key === item.key)[0]
        );
        delete target.editable;
        this.course_info = newData;
      }
    }
  }
};
</script>

<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
</style>
