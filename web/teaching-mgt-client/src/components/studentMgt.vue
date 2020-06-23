<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加学生"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_student"
      @cancel="on_modal_cancel"
      okText="添加"
      cancelText="取消"
    >
      <span style="color:red">新用户默认密码为工号/学号</span>
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newstudent"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="学号" prop="user_no">
            <a-input v-model="form.user_no" />
          </a-form-model-item>
          <a-form-model-item label="姓名" prop="user_name">
            <a-input v-model="form.user_name" />
          </a-form-model-item>
          <a-form-model-item label="性别" prop="user_sex">
            <a-radio-group v-model="form.user_sex">
              <a-radio value="男">男</a-radio>
              <a-radio value="女">女</a-radio>
            </a-radio-group>
          </a-form-model-item>
          <a-form-model-item label="入学日期" prop="enter_date">
            <a-date-picker v-model="form.enter_date" placeholder="请选择入学日期"></a-date-picker>
          </a-form-model-item>
          <a-form-model-item label="班级" prop="user_class">
            <a-select v-model="form.user_class" placeholder="请选择班级">
              <a-select-option
                v-for="i_class in classes"
                :key="i_class.class_no"
                :value="i_class.class_no"
              >{{i_class.class_name}}</a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="院系" prop="user_depart">
            <a-select v-model="form.user_depart" placeholder="请选择院系">
              <a-select-option
                v-for="depart in departs"
                :key="depart.depart_no"
                :value="depart.depart_no"
              >{{depart.depart_name}}</a-select-option>
            </a-select>
          </a-form-model-item>
        </a-form-model>
      </a-card>
    </a-modal>
    <a-col>
      <a-button type="primary" @click="show_modal">添加学生</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table
        :columns="Columns"
        :data-source="students_info"
        :loading="loading"
        style="margin-top: 24px"
      >
        <template
          v-for="col in ['userno', 'username', 'usersex', 'enterdate', 'class', 'teacher', 'department']"
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
    title: "性别",
    dataIndex: "usersex",
    key: "usersex",
    scopedSlots: { customRender: "usersex" }
  },
  {
    title: "入学时间",
    dataIndex: "enter_date",
    key: "enterdate",
    scopedSlots: { customRender: "enterdate" }
  },
  {
    title: "班级",
    dataIndex: "class_name",
    key: "class",
    scopedSlots: { customRender: "class" }
  },
  {
    title: "班主任",
    dataIndex: "teach_name",
    key: "teacher",
    scopedSlots: { customRender: "teacher" }
  },
  {
    title: "院系",
    dataIndex: "departname",
    key: "department",
    scopedSlots: { customRender: "department" }
  },
  {
    title: "编辑",
    dataIndex: "edit",
    key: "edit",
    scopedSlots: { customRender: "edit" }
  }
];
export default {
  name: "studentMgt",
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
    let checkUserno = (rule, value, callback) => {
      if (!value) {
        return callback(new Error("请输入工号"));
      }
      if (value.length != 7 && Number.isInteger(value)) {
        callback(new Error("工号必须为7位数字"));
      } else {
        callback();
      }
    };
    let checkUsername = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入姓名"));
      } else {
        callback();
      }
    };
    let checkUserphone = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入联系方式"));
      } else {
        callback();
      }
    };
    return {
      students_info: [],
      editingKey: "",
      Columns,
      loading: false,
      data_loading: false,
      modal: {
        visible: false,
        confirmLoading: false
      },
      departs: [],
      classes: [],
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        user_no: "",
        user_name: "",
        user_sex: "男",
        user_class: "",
        user_depart: "",
        enter_date: ""
      },
      rules: {
        user_no: [
          { required: true, message: "请输入学号", trigger: "change" },
          { validator: checkUserno, trigger: "change" }
        ],
        user_name: [
          { required: true, message: "请输入姓名", trigger: "change" },
          { validator: checkUsername, trigger: "change" }
        ],
        user_depart: [
          { required: true, message: "请选择院系", trigger: "change" }
        ],
        user_class: [
          { required: true, message: "请选择班级", trigger: "change" }
        ],
        enter_date: [
          { required: true, message: "请选择入学日期", trigger: "change"}
        ]
      }
    };
  },
  mounted() {
    this.get_students_info();
    this.get_departs();
    this.get_classes();
  },
  methods: {
    get_classes() {
      this.$axios
        .post("/getclassinfo", {
          class_no: "%"
        })
        .then(responce => {
          this.classes = responce.data;
          // console.log(this.classes)
        })
        .catch(err => {
          console.log("获取班级信息失败");
        });
    },
    flush_data() {
      this.data_loading = true;
      this.$axios
        .post("/getstudentsinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.students_info = responce.data;
          for (let i = 0; i < this.students_info.length; i += 1) {
            this.students_info[i].key = i.toString();
          }
          this.cacheData = this.students_info.map(item => ({ ...item }));
          this.data_loading = false;
        })
        .catch(err => {
          this.data_loading = false;
          console.log(err);
        });
    },
    get_departs() {
      this.$axios
        .post("/getdepartmentinfo", {
          depart_no: "%"
        })
        .then(responce => {
          this.departs = responce.data;
          // console.log(this.departs)
        })
        .catch(err => {
          console.log("获取部门信息失败");
        });
    },
    show_modal() {
      this.modal.visible = true;
    },
    add_new_student() {
      console.log(this.form)
      this.modal.confirmLoading = true;
      this.$refs.newstudent.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addnewstudent", {
              user_no: this.form.user_no,
              user_name: this.form.user_name,
              user_sex: this.form.user_sex,
              user_class: this.form.user_class,
              user_depart: this.form.user_depart,
              enter_date: this.form.enter_date.format("YYYY-MM-DD")
            })
            .then(responce => {
              Modal.success({ title: "提示", content: "新用户添加成功" });
              this.modal.confirmLoading = false;
              this.modal.visible = false;
            })
            .catch(err => {
              Modal.error({ title: "提示", content: "新用户添加失败" });
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
      this.$refs.newstudent.resetFields();
    },
    get_students_info() {
      this.loading = true;
      this.$axios
        .post("/getstudentsinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.students_info = responce.data;
          for (let i = 0; i < this.students_info.length; i += 1) {
            this.students_info[i].key = i.toString();
          }
          this.cacheData = this.students_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
          console.log(err);
        });
    },
    handleChange(value, key, column) {
      const newData = [...this.students_info];
      const target = newData.filter(item => key === item.key)[0];
      if (target) {
        target[column] = value;
        this.students_info = newData;
      }
    },
    edit(key) {
      const newData = [...this.students_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.students_info = newData;
      }
    },
    save(key) {
      const newData = [...this.students_info];
      const newCacheData = [...this.cacheData];
      const target = newData.filter(item => key === item.key)[0];
      const targetCache = newCacheData.filter(item => key === item.key)[0];
      if (target && targetCache) {
        delete target.editable;
        this.students_info = newData;
        Object.assign(targetCache, target);
        this.cacheData = newCacheData;
      }
      this.editingKey = "";
    },
    cancel(key) {
      const newData = [...this.students_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = "";
      if (target) {
        Object.assign(
          target,
          this.cacheData.filter(item => key === item.key)[0]
        );
        delete target.editable;
        this.students_info = newData;
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

