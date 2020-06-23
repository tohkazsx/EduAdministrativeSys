<template>
  <a-row>
    <a-modal
      centered
      :maskClosable="false"
      title="添加院系"
      :visible="modal.visible"
      :confirm-loading="modal.confirmLoading"
      @ok="add_new_admin"
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
      <a-button type="primary" @click="show_modal">添加院系</a-button>
      <a-button type="primary" @click="flush_data" :loading="data_loading">刷新</a-button>
      <a-table :columns="Columns" :data-source="department_info" :loading="loading">
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
    };
  },
  mounted() {
    this.get_department_info();
  },
  methods: {
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