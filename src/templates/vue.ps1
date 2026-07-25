param([string]$Path, [string]$FileName)
return @"
<template>
  <div>
    <h1>{{ title }}</h1>
  </div>
</template>

<script setup>
import { ref } from 'vue';
const title = ref('${FileName} Component');
</script>

<style scoped>
/* Component styles */
</style>
"@