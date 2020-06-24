<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加班级"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_class"
      @cancel="on_modal_cancel"
      okText="添加"
      cancelText="取消"
    >
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newclass"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="编号" prop="class_no">
            <a-input v-model="form.class_no" />
          </a-form-model-item>
          <a-form-model-item label="班级" prop="class_name">
            <a-input v-model="form.class_name" />
          </a-form-model-item>
          <a-form-model-item label="年级" prop="class_term">
            <a-input v-model="form.class_term" placeholder="请输入年级(例: 2019)" />
          </a-form-model-item>
          <a-form-model-item label="班主任" prop="class_teach">
            <a-select v-model="form.class_teach" placeholder="请选择系主任">
              <a-select-option
                v-for="teacher in teachers"
                :key="teacher.userno"
                :value="teacher.userno"
              >{{`${teacher.username}(${teacher.userno})`}}</a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="院系" prop="class_depart">
            <a-select v-model="form.class_depart" placeholder="请选择院系">
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
      <a-button type="primary" @click="show_modal">添加班级</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table
        :columns="Columns"
        :data-source="class_info"
        :loading="loading"
        style="margin-top: 24px;"
      >
        <template
          v-for="col in ['class_no','userno', 'username', 'usersex', 'userphone', 'departname']"
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
    title: "编号",
    dataIndex: "class_no",
    key: "class_no",
    scopedSlots: { customRender: "class_no" }
  },
  {
    title: "班级",
    dataIndex: "class_name",
    key: "class_name",
    scopedSlots: { customRender: "class_name" }
  },
  {
    title: "班级人数",
    dataIndex: "class_num",
    key: "class_num",
    scopedSlots: { customRender: "class_num" }
  },
  {
    title: "班主任",
    dataIndex: "teach_name",
    key: "teach_name",
    scopedSlots: { customRender: "teach_name" }
  },
  {
    title: "系部",
    dataIndex: "depart_name",
    key: "depart_name",
    scopedSlots: { customRender: "depart_name" }
  },
  {
    title: "年级",
    dataIndex: "class_term",
    key: "class_term",
    scopedSlots: { customRender: "class_term" }
  },
  {
    title: "编辑",
    dataIndex: "edit",
    key: "edit",
    scopedSlots: { customRender: "edit" }
  }
];
export default {
  name: "classMgt",
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
      class_info: [],
      editingKey: "",
      Columns,
      loading: false,
      data_loading: false,
      teachers: [],
      departs: [],
      modal: {
        visible: false,
        confirmLoading: false
      },
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        class_no: "",
        class_name: "",
        class_teach: "",
        class_depart: "",
        class_term: ""
      },
      rules: {
        class_no: [
          { required: true, message: "请输入班级编号", trigger: "change" },
        ],
        class_name: [
          { required: true, message: "请输入班级", trigger: "change" },
        ],
        class_teach: [
          { required: true, message: "请输入班主任", trigger: "change" },
        ],
        class_depart: [
          { required: true, message: "请输入院系", trigger: "change" },
        ],
        class_term: [
          { required: true, message: "请选择年级", trigger: "change" },
        ],
      }
    };
  },
  mounted() {
    this.get_class_info();
    this.get_departs();
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
    flush_data() {
      this.data_loading = true;
      this.$axios
        .post("/getclassinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.class_info = responce.data;
          for (let i = 0; i < this.admins_info.length; i += 1) {
            this.class_info[i].key = i.toString();
          }
          this.cacheData = this.class_info.map(item => ({ ...item }));
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
    add_new_class() {
      console.log(this.form)
      this.modal.confirmLoading = true;
      this.$refs.newclass.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addnewclass", {
              class_no: this.form.class_no,
              class_name: this.form.class_name,
              class_teach: this.form.class_teach,
              class_depart: this.form.class_depart,
              class_term: this.form.class_term
            })
            .then(responce => {
              Modal.success({ title: "提示", content: "新班级添加成功" });
              this.modal.confirmLoading = false;
              this.modal.visible = false;
            })
            .catch(err => {
              Modal.error({ title: "提示", content: "新班级添加失败" });
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
      this.$refs.newclass.resetFields();
    },
    get_class_info() {
      this.loading = false;
      this.$axios
        .post("/getclassinfo", {
          class_no: "%"
        })
        .then(responce => {
          this.class_info = responce.data;
          for (let i = 0; i < this.class_info.length; i += 1) {
            this.class_info[i].key = i.toString();
          }
          this.cacheData = this.class_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
          console.log(err);
        });
    },
    handleChange(value, key, column) {
      const newData = [...this.class_info];
      const target = newData.filter(item => key === item.key)[0];
      if (target) {
        target[column] = value;
        this.class_info = newData;
      }
    },
    edit(key) {
      const newData = [...this.class_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.class_info = newData;
      }
    },
    save(key) {
      const newData = [...this.class_info];
      const newCacheData = [...this.cacheData];
      const target = newData.filter(item => key === item.key)[0];
      const targetCache = newCacheData.filter(item => key === item.key)[0];
      if (target && targetCache) {
        delete target.editable;
        this.class_info = newData;
        Object.assign(targetCache, target);
        this.cacheData = newCacheData;
      }
      this.editingKey = "";
    },
    cancel(key) {
      const newData = [...this.class_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = "";
      if (target) {
        Object.assign(
          target,
          this.cacheData.filter(item => key === item.key)[0]
        );
        delete target.editable;
        this.class_info = newData;
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
