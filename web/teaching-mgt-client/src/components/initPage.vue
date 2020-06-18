<template>
  <a-card title="个人信息" head-style="font-size: 24px; font-weight: 600; text-align: center;" hoverable="true"
          style="margin: 36px"  bordered="false">
    <a-layout>
      <div style="background-color: white">
        <a-card hoverable="true" bordered="false">
          <a-descriptions bordered title="Custom Size" size="default" style="background-color: white">
            <a-descriptions-item label="学号">
              Cloud Database
            </a-descriptions-item>
            <a-descriptions-item label="姓名">
              Prepaid
            </a-descriptions-item>
            <a-descriptions-item label="性别">
              18:00:00
            </a-descriptions-item>
            <a-descriptions-item label="入学时间">
              $80.00
            </a-descriptions-item>
            <a-descriptions-item label="班级">
              $20.00
            </a-descriptions-item>
            <a-descriptions-item label="班主任">
              $60.00
            </a-descriptions-item>
            <a-descriptions-item label="院系">
            </a-descriptions-item>
          </a-descriptions>
        </a-card>

        <a-card hoverable="true" bordered="false">
          <a-descriptions title="Custom Size" :size="size">
            <a-descriptions-item label="Product">
              Cloud Database
            </a-descriptions-item>
            <a-descriptions-item label="Billing">
              Prepaid
            </a-descriptions-item>
            <a-descriptions-item label="Time">
              18:00:00
            </a-descriptions-item>
            <a-descriptions-item label="Amount">
              $80.00
            </a-descriptions-item>
            <a-descriptions-item label="Discount">
              $20.00
            </a-descriptions-item>
            <a-descriptions-item label="Official">
              $60.00
            </a-descriptions-item>
          </a-descriptions>
        </a-card>
      </div>

    </a-layout>
  </a-card>
</template>

<script>

</script>

<style>
  .larger-font {
    font-size: 20px;
    font-weight: 600;
  }
</style>
