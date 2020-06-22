<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加管理员"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_admin"
      @cancel="on_modal_cancel"
      okText="添加"
      cancelText="取消"
    >
      <span style="color:red">新用户默认密码为工号/学号</span>
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newadmin"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="工号" prop="user_no">
            <a-input v-model="form.user_no" />
          </a-form-model-item>
          <a-form-model-item label="姓名" prop="user_name">
            <a-input v-model="form.user_name" />
          </a-form-model-item>
          <a-form-model-item label="联系电话" prop="user_phone">
            <a-input v-model="form.user_phone" />
          </a-form-model-item>
        </a-form-model>
      </a-card>
    </a-modal>
    <a-col>
      <a-button type="primary" @click="show_modal">添加管理员</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-card type="inner" style="margin-top: 24px">
        <a-table :columns="Columns" :data-source="admins_info" :loading="loading">
          <template
            v-for="col in ['userno', 'username', 'userphone']"
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
                <a-popconfirm title="确认取消?" @confirm="() => cancel(record.key)">
                  <a>取消</a>
                </a-popconfirm>
              </span>
              <span v-else>
                <a :disabled="editingKey !== ''" @click="() => edit(record.key)">修改</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-card>
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
    title: "联系方式",
    dataIndex: "userphone",
    key: "userphone",
    scopedSlots: { customRender: "userphone" }
  },
  {
    title: "编辑",
    dataIndex: "edit",
    key: "edit",
    scopedSlots: { customRender: "edit" }
  }
];
export default {
  name: "adminMgt",
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
      admins_info: [],
      editingKey: "",
      Columns,
      data_loading: false,
      loading: false,
      modal: {
        visible: false,
        confirmLoading: false
      },
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        user_no: "",
        user_name: "",
        user_phone: ""
      },
      rules: {
        user_no: [
          { required: true, message: "请输入工号", trigger: "change" },
          { validator: checkUserno, trigger: "change" }
        ],
        user_name: [
          { required: true, message: "请输入姓名", trigger: "change" },
          { validator: checkUsername, trigger: "change" }
        ],
        user_phone: [
          { required: true, message: "请输入联系方式", trigger: "change" },
          { validator: checkUserphone, trigger: "change" }
        ]
      }
    };
  },
  mounted() {
    this.get_admins_info();
  },
  methods: {
    flush_data() {
      this.data_loading = true;
      this.$axios
        .post("/getadminsinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.admins_info = responce.data;
          for (let i = 0; i < this.admins_info.length; i += 1) {
            this.admins_info[i].key = i.toString();
          }
          this.cacheData = this.admins_info.map(item => ({ ...item }));
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
    add_new_admin() {
      this.modal.confirmLoading = true;
      this.$refs.newadmin.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addnewadmin", {
              user_no: this.form.user_no,
              user_name: this.form.user_name,
              user_phone: this.form.user_phone
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
      this.$refs.newadmin.resetFields()
    },
    get_admins_info() {
      this.loading = true;
      this.$axios
        .post("/getadminsinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.admins_info = responce.data;
          for (let i = 0; i < this.admins_info.length; i += 1) {
            this.admins_info[i].key = i.toString();
          }
          this.cacheData = this.admins_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
          console.log(err);
        });
    },
    handleChange(value, key, column) {
      const newData = [...this.admins_info];
      const target = newData.filter(item => key === item.key)[0];
      if (target) {
        target[column] = value;
        this.admins_info = newData;
      }
    },
    edit(key) {
      const newData = [...this.admins_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.admins_info = newData;
      }
    },
    save(key) {
      const newData = [...this.admins_info];
      const newCacheData = [...this.cacheData];
      const target = newData.filter(item => key === item.key)[0];

      const targetCache = newCacheData.filter(item => key === item.key)[0];
      if (target && targetCache) {
        delete target.editable;
        this.admins_info = newData;
        Object.assign(targetCache, target);
        this.cacheData = newCacheData;
      }
      this.editingKey = "";
    },
    cancel(key) {
      const newData = [...this.admins_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = "";
      if (target) {
        Object.assign(
          target,
          this.cacheData.filter(item => key === item.key)[0]
        );
        delete target.editable;
        this.admins_info = newData;
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