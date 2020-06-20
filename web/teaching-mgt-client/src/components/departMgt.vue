<template>
    <a-table :columns="Columns" :data-source="department_info">
      <template
        v-for="col in ['depart_name', 'depart_num', 'teach_name']"
        :slot="col"
        slot-scope="text, record, index"
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
      <template slot="edit" slot-scope="text, record, index">
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
</template>

<script>
const Columns = [
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
      Columns
      // cacheData
    };
  },
  mounted() {
    this.get_department_info();
  },
  methods: {
    get_department_info() {
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