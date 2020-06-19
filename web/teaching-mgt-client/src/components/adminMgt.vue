<template>
  <a-layout>
    <a-layout-header style="background-color: white">管理员信息</a-layout-header>
    <a-table :columns="Columns" :data-source="admins_info">
      <template
        v-for="col in ['userno', 'username', 'userphone']"
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
      title: '联系方式',
      dataIndex: 'userphone',
      key: 'userphone'
    },
    {
      title: '编辑',
      dataIndex: 'edit',
      key: 'edit'
    }
  ]
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
      return {
        admins_info: [],
        editingKey: '',
        Columns,
        // cacheData
      }
    },
    mounted() {
      this.get_admins_info()
    },
    methods: {
      get_admins_info() {
        this.$axios.post('/getadminsinfo', {
          user_no: this.userinfo.userno
        }).then(responce => {
          this.admins_info = responce.data
          this.cacheData = this.admins_info.map(item => ({...item}))
          console.log(this.admins_info)
        }).catch(err => {
          console.log(err)
        })
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
        this.editingKey = '';
      },
      cancel(key) {
        const newData = [...this.admins_info];
        const target = newData.filter(item => key === item.key)[0];
        this.editingKey = '';
        if (target) {
          Object.assign(target, this.cacheData.filter(item => key === item.key)[0]);
          delete target.editable;
          this.admins_info = newData;
        }
      },
    }
  }
</script>

<style scoped>

</style>
