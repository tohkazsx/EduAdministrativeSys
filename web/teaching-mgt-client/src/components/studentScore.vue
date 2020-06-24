<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="录入成绩"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_stu_score"
      @cancel="on_modal_cancel"
      okText="保存"
      cancelText="取消"
    >
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newstuscore"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="学生" prop="student_no">
            <a-select v-model="form.student_no" placeholder="请选择学生">
              <a-select-option
                v-for="student in students"
                :key="student.userno"
                :value="student.userno"
              >{{`${student.username}(${student.userno})`}}</a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="课程" prop="course_no">
            <a-select v-model="form.course_no" placeholder="请选择课程">
              <a-select-option
                v-for="course in course_info"
                :key="course.course_no"
                :value="course.course_no"
              >{{`${course.course_name}(${course.course_no})`}}</a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="成绩" prop="stu_score">
            <a-input v-model="form.stu_score" placeholder="请输入成绩" />
          </a-form-model-item>
        </a-form-model>
      </a-card>
    </a-modal>
    <a-col>
      <a-button type="primary" @click="show_modal" v-if="userrole != 'student'">录入成绩</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table :columns="Columns" :data-source="course_info" :loading="loading" style="margin-top: 24px">
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
    title: "学号",
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
    title: "分数",
    dataIndex: "sc_socre",
    key: "sc_score",
    scopedSlots: { customRender: "sc_score" }
  },
];
export default {
  name: "studentScore",
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
      loading: false,
      students: [],
      data_loading: false,
      modal: {
        visible: false,
        confirmLoading: false
      },
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        student_no: "",
        course_no: "",
        stu_score: ""
      },
      rules: {
        student_no: [{ required: true, message: "请选择学生" }],
        course_no:  [{ required: true, message: "请选择课程" }],
        stu_score:  [{ required: true, message: "请输入成绩" }],
      }
    };
  },
  mounted() {
    this.get_course_info();
    this.get_students_info();
  },
  methods: {
    flush_data() {
      this.data_loading = true;
      this.$axios
        .post("/getstucourse", {
          user_no: this.userrole != "student" ? "%" : this.userinfo.userno
        })
        .then(responce => {
          this.course_info = responce.data;
          for (let i = 0; i < this.course_info.length; i += 1) {
            this.course_info[i].key = i.toString();
          }
          this.cacheData = this.course_info.map(item => ({ ...item }));
          this.data_loading = false;
          console.log(this.course_info)
        })
        .catch(err => {
          this.data_loading = false;
          console.log(err);
        });
    },
    show_modal() {
      this.modal.visible = true;
    },
    on_modal_cancel() {
      this.modal.visible = false;
      this.$refs.newstuscore.resetFields();
    },
    add_stu_score() {
      this.modal.confirmLoading = true;
      this.$refs.newstuscore.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addstuscore", {
              student_no: this.form.student_no,
              course_no: this.form.course_no,
              score: this.form.stu_score
            })
            .then(responce => {
              Modal.success({ title: "提示", content: "成绩录入成功" });
              this.modal.confirmLoading = false;
              this.modal.visible = false;
            })
            .catch(err => {
              Modal.error({ title: "提示", content: "成绩录入失败" });
              this.modal.confirmLoading = false;
              console.log(err);
            });
        } else {
          this.modal.confirmLoading = false;
          return false;
        }
      });
    },
    get_students_info() {
      this.loading = true;
      this.$axios
        .post("/getstudentsinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.students = responce.data;
          this.loading = false;
        })
        .catch(err => {
          console.log(err);
          this.loading = false;
        });
    },
    get_course_info() {
      this.loading = true;
      this.$axios
        .post("/getstucourse", {
          user_no: this.userrole != "student" ? "%" : this.userinfo.userno
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
