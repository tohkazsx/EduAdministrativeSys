<template>
  <a-layout>
    <a-layout-header style="background-color: white">教师信息</a-layout-header>
    <a-table :columns="Columns" :data-source="teachers_info">
      <template
        v-for="col in ['userno', 'username', 'usersex', 'userphone']"
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
          <template v-else>
            {{ text }}
          </template>
        </div>
      </template>
      <template slot="operation" slot-scope="text, record, index">
        <div class="editable-row-operations">
        <span v-if="record.editable">
          <a @click="() => save(record.key)">保存</a>
          <a-popconfirm title="Sure to cancel?" @confirm="() => cancel(record.key)">
            <a>取消</a>
          </a-popconfirm>
        </span>
          <span v-else>
          <a :disabled="editingKey !== ''" @click="() => edit(record.key)">编辑</a>
        </span>
        </div>
      </template>
    </a-table>
  </a-layout>
</template>

<script>
  const Columns = [
    {
      title: '工号',
      dataIndex: 'userno',
      key: 'userno'
    },
    {
      title: '姓名',
      dataIndex: 'username',
      key: 'username'
    },
    {
      title: '性别',
      dataIndex: 'usersex',
      key: 'usersex'
    },
    {
      title: '联系方式',
      dataIndex: 'userphone',
      key: 'userphone'
    },
    {
      title: '院系',
      dataIndex: 'department',
      key: 'department'
    },
    {
      title: '编辑',
      dataIndex: 'edit',
      key: 'edit'
    }
  ]
  export default {
    name: "teacherMgt",
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
      this.cacheData = data.map(item => ({...item}))
      return {
        teachers_info: {},
        editingKey: '',
      }
    },
    mounted() {
      this.get_teachers_info()
    },
    methods: {
      get_teachers_info() {
        this.$axios.post('/getteachersinfo', {
          user_no: this.userinfo.userno
        }).then(responce => {
          this.teachers_info = responce.data
        }).catch(err => {
          console.log(err)
        })
      },
      handleChange(value, key, column) {
        const newData = [...this.teachers_info];
        const target = newData.filter(item => key === item.key)[0];
        if (target) {
          target[column] = value;
          this.teachers_info = newData;
        }
      },
      edit(key) {
        const newData = [...this.teachers_info];
        const target = newData.filter(item => key === item.key)[0];
        this.editingKey = key;
        if (target) {
          target.editable = true;
          this.teachers_info = newData;
        }
      },
      save(key) {
        const newData = [...this.teachers_info];
        const newCacheData = [...this.cacheData];
        const target = newData.filter(item => key === item.key)[0];
        const targetCache = newCacheData.filter(item => key === item.key)[0];
        if (target && targetCache) {
          delete target.editable;
          this.teachers_info = newData;
          Object.assign(targetCache, target);
          this.cacheData = newCacheData;
        }
        this.editingKey = '';
      },
      cancel(key) {
        const newData = [...this.teachers_info];
        const target = newData.filter(item => key === item.key)[0];
        this.editingKey = '';
        if (target) {
          Object.assign(target, this.cacheData.filter(item => key === item.key)[0]);
          delete target.editable;
          this.teachers_info = newData;
        }
      },
    }
  }
</script>

<style scoped>

</style>
