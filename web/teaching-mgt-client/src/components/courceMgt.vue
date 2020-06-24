<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加课程"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_course"
      @cancel="on_modal_cancel"
      okText="添加"
      cancelText="取消"
    >
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newcourse"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="编号" prop="course_no">
            <a-input v-model="form.course_no" placeholder="请输入课号" />
          </a-form-model-item>
          <a-form-model-item label="课程名" prop="course_name">
            <a-input v-model="form.course_name" />
          </a-form-model-item>
          <a-form-model-item label="学年" prop="course_date">
            <a-input v-model="form.course_date" placeholder="请输入学年(例: 2019)" />
          </a-form-model-item>
          <a-form-model-item label="学期" prop="course_term">
            <a-select v-model="form.course_term" placeholder="请选择学期">
              <a-select-option value="第一学期">第一学期</a-select-option>
              <a-select-option value="第二学期">第二学期</a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="任课老师" prop="teach_no">
            <a-select v-model="form.teach_no" placeholder="请选择任课老师">
              <a-select-option
                v-for="teacher in teachers"
                :key="teacher.userno"
                :value="teacher.userno"
              >{{`${teacher.username}(${teacher.userno})`}}</a-select-option>
            </a-select>
          </a-form-model-item>
        </a-form-model>
      </a-card>
    </a-modal>
    <a-col>
      <a-button type="primary" @click="show_modal">添加课程</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table
        :columns="Columns"
        :data-source="course_info"
        :loading="loading"
        style="margin-top: 24px;"
      >
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
    </a-col>
  </a-row>
</template>

<script>
import { Modal } from "ant-design-vue";
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
      loading: false,
      data_loading: false,
      teachers: [],
      modal: {
        visible: false,
        confirmLoading: false
      },
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        course_no: "",
        course_name: "",
        course_date: "",
        course_term: "",
        teach_no: ""
      },
      rules: {
        course_no: [
          { required: true, message: "请输入课程编号", trigger: "change" }
        ],
        course_name: [
          { required: true, message: "请输入课程名", trigger: "change" }
        ],
        course_date: [
          { required: true, message: "请输入课程开设学年", trigger: "change" }
        ],
        course_term: [
          { required: true, message: "请选择课程开设学期", trigger: "change" }
        ],
        teach_no: [
          { required: true, message: "请选择任课老师", trigger: "change" }
        ]
      }
    };
  },
  mounted() {
    this.get_course_info();
    this.get_teachers();
  },
  methods: {
    get_teachers() {
      this.$axios
        .post("/getteachersinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.teachers = responce.data;
          // console.log(this.teachers)
        })
        .catch(err => {
          console.log(err);
        });
    },
    flush_data() {
      this.data_loading = true;
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
          this.data_loading = false;
        })
        .catch(err => {
          this.data_loading = false;
          console.log(err);
        });
    },
    show_modal() {
      this.modal.visible = true;
    },
    add_new_course() {
      // console.log(this.form);
      this.modal.confirmLoading = true;
      this.$refs.newcourse.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addnewcourse", {
              course_no: this.form.course_no,
              course_name: this.form.course_name,
              course_date: this.form.course_date,
              course_term: this.form.course_term,
              teach_no: this.form.teach_no
            })
            .then(responce => {
              Modal.success({ title: "提示", content: "新课程添加成功" });
              this.modal.confirmLoading = false;
              this.modal.visible = false;
            })
            .catch(err => {
              Modal.error({ title: "提示", content: "新课程添加失败" });
              this.modal.confirmLoading = false;
              console.log(err);
            });
        } else {
          this.modal.confirmLoading = false;
          return false;
        }
      });
    },
    on_modal_cancel() {
      this.modal.visible = false;
      this.$refs.newcourse.resetFields();
    },
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
