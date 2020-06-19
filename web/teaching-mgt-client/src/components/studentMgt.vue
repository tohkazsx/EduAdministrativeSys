<template>
  <a-layout>
    <a-layout-header style="background-color: white">学生信息</a-layout-header>
    <a-table :columns="Columns" :data-source="students_info">
      <template
        v-for="col in ['userno', 'username', 'usersex', 'enterdate', 'class', 'teacher', 'department']"
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
      title: '学号',
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
      title: '入学时间',
      dataIndex: 'enterdate',
      key: 'enterdate'
    },
    {
      title: '班级',
      dataIndex: 'class',
      key: 'class'
    },
    {
      title: '班主任',
      dataIndex: 'teacher',
      key: 'teacher'
    },
    {
      title: '院系',
      dataIndex: 'department',
      key: 'department'
    }
  ]
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
      this.cacheData = data.map(item => ({...item}))
      return {
        students_info: {},
        editingKey: '',
      }
    },
    mounted() {
      this.get_students_info()
    },
    methods: {
      get_students_info() {
        this.$axios.post('/getstudentsinfo', {
          user_no: this.userinfo.userno
        }).then(responce => {
          this.students_info = responce.data
        }).catch(err => {
          console.log(err)
        })
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
        this.editingKey = '';
      },
      cancel(key) {
        const newData = [...this.students_info];
        const target = newData.filter(item => key === item.key)[0];
        this.editingKey = '';
        if (target) {
          Object.assign(target, this.cacheData.filter(item => key === item.key)[0]);
          delete target.editable;
          this.students_info = newData;
        }
      },
    }
  }
</script>

<style scoped>

</style>
