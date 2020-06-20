<template>
  <a-table :columns="Columns" :data-source="course_info" :loading="loading">
    <template
      v-for="col in ['course_no', 'course_name', 'teach_name', 'course_date', 'course_term']"
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
    <template slot="edit" slot-scope="text, record">
      <div class="editable-row-operations">
        <span v-if="record.editable">
          <a @click="() => save(record.key)">保存</a>
          <a-popconfirm title="Sure to cancel?" @confirm="() => cancel(record.key)">
            <a>取消</a>
          </a-popconfirm>
        </span>
        <span v-else>
          <a :disabled="editingKey !== ''" @click="() => edit(record.key)">修改</a>
        </span>
      </div>
    </template>
  </a-table>
</template>

<script>
const Columns = [
  {
    title: "课号",
    dataIndex: "course_no",
    key: "course_no",
    scopedSlots: { customRender: "course_no" }
  },
  {
    title: "课目",
    dataIndex: "course_name",
    key: "course_name",
    scopedSlots: { customRender: "course_name" }
  },
  {
    title: "任课老师",
    dataIndex: "teach_name",
    key: "teach_name",
    scopedSlots: { customRender: "teach_name" }
  },
  {
    title: "课程学年",
    dataIndex: "course_date",
    key: "course_date",
    scopedSlots: { customRender: "course_date" }
  },
  {
    title: "课程学期",
    dataIndex: "course_term",
    key: "course_term",
    scopedSlots: { customRender: "course_term" }
  },
  {
    title: "编辑",
    dataIndex: "edit",
    key: "edit",
    scopedSlots: { customRender: "edit" }
  }
];
export default {
  name: "courseMgt",
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
    this.get_course_info();
  },
  methods: {
    get_course_info() {
      this.loading = true;
      this.$axios
        .post("/getcourse", {
          user_no: "%"
        })
        .then(responce => {
          this.course_info = responce.data;
          for (let i = 0; i < this.course_info.length; i += 1) {
            this.course_info[i].key = i.toString();
          }
          this.cacheData = this.course_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
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
