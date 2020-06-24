<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加院系"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_depart"
      @cancel="on_modal_cancel"
      okText="添加"
      cancelText="取消"
    >
      <a-card type="inner" style="margin-top: 24px">
        <a-form-model
          ref="newdepart"
          :model="form"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
        >
          <a-form-model-item label="编号" prop="depart_no">
            <a-input v-model="form.depart_no" />
          </a-form-model-item>
          <a-form-model-item label="院系" prop="depart_name">
            <a-input v-model="form.depart_name" />
          </a-form-model-item>
          <a-form-model-item label="系主任" prop="teach_no">
            <a-select v-model="form.teach_no" placeholder="请选择系主任">
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
      <a-button type="primary" @click="show_modal">添加院系</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table
        :columns="Columns"
        :data-source="department_info"
        :loading="loading"
        style="margin-top: 24px"
      >
        <template
          v-for="col in ['depart_no','depart_name', 'depart_num', 'teach_name']"
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
    </a-col>
  </a-row>
</template>

<script>
import { Modal } from "ant-design-vue";
const Columns = [
  {
    title: "编号",
    dataIndex: "depart_no",
    key: "depart_no",
    scopedSlots: { customRender: "depart_no" }
  },
  {
    title: "系部",
    dataIndex: "depart_name",
    key: "depart_name",
    scopedSlots: { customRender: "depart_name" }
  },
  {
    title: "人数",
    dataIndex: "depart_num",
    key: "depart_num",
    scopedSlots: { customRender: "depart_num" }
  },
  {
    title: "系主任",
    dataIndex: "teach_name",
    key: "teach_name",
    scopedSlots: { customRender: "teach_name" }
  },
  {
    title: "编辑",
    dataIndex: "edit",
    key: "edit",
    scopedSlots: { customRender: "edit" }
  }
];
export default {
  name: "departMgt",
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
      department_info: [],
      editingKey: "",
      Columns,
      teachers: [],
      data_loading: false,
      loading: false,
      modal: {
        visible: false,
        confirmLoading: false
      },
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
      form: {
        depart_no: "",
        depart_name: "",
        teach_no: ""
      },
      rules: {
        depart_no: [
          { required: true, message: "请输入院系编号", trigger: "change" },
        ],
        depart_name: [
          { required: true, message: "请输入院系", trigger: "change" },
        ],
        teach_no: [
          { required: true, message: "请输入系主任", trigger: "change" },
        ],
      }
    };
  },
  mounted() {
    this.get_department_info();
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
        .post("/getdepartmentinfo", {
          user_no: "%"
        })
        .then(responce => {
          this.department_info = responce.data;
          for (let i = 0; i < this.admins_info.length; i += 1) {
            this.department_info[i].key = i.toString();
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
    add_new_depart() {
      console.log(this.form)
      this.modal.confirmLoading = true;
      this.$refs.newdepart.validate(valid => {
        if (valid) {
          this.$axios
            .post("/addnewdepart", {
              depart_no: this.form.depart_no,
              depart_name: this.form.depart_name,
              teach_no: this.form.teach_no,
            })
            .then(responce => {
              Modal.success({ title: "提示", content: "新院系添加成功" });
              this.modal.confirmLoading = false;
              this.modal.visible = false;
            })
            .catch(err => {
              Modal.error({ title: "提示", content: "新院系添加失败" });
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
      this.$refs.newdepart.resetFields();
    },
    get_department_info() {
      this.loading = true;
      this.$axios
        .post("/getdepartmentinfo", {
          depart_no: "%"
        })
        .then(responce => {
          this.department_info = responce.data;
          for (let i = 0; i < this.department_info.length; i += 1) {
            this.department_info[i].key = i.toString();
          }
          this.cacheData = this.department_info.map(item => ({ ...item }));
          this.loading = false;
        })
        .catch(err => {
          console.log(err);
        });
    },
    handleChange(value, key, column) {
      const newData = [...this.department_info];
      const target = newData.filter(item => key === item.key)[0];
      if (target) {
        target[column] = value;
        this.department_info = newData;
      }
    },
    edit(key) {
      const newData = [...this.department_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.department_info = newData;
      }
    },
    save(key) {
      const newData = [...this.department_info];
      const newCacheData = [...this.cacheData];
      const target = newData.filter(item => key === item.key)[0];

      const targetCache = newCacheData.filter(item => key === item.key)[0];
      if (target && targetCache) {
        delete target.editable;
        this.department_info = newData;
        Object.assign(targetCache, target);
        this.cacheData = newCacheData;
      }
      this.editingKey = "";
    },
    cancel(key) {
      const newData = [...this.department_info];
      const target = newData.filter(item => key === item.key)[0];
      this.editingKey = "";
      if (target) {
        Object.assign(
          target,
          this.cacheData.filter(item => key === item.key)[0]
        );
        delete target.editable;
        this.department_info = newData;
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