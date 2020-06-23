<template>
    <a-table :columns="Columns" :data-source="class_info" :loading="loading">
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
</template>

<script>
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
      loading : false
    };
  },
  mounted() {
    this.get_class_info();
  },
  methods: {
    get_class_info() {
      this.loading = false
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
