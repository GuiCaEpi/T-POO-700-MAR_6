<template>
  <div>
    <h1>Chart Manager</h1>
    <bar-chart :data="chartData"></bar-chart>
    <line-chart :data="chartData"></line-chart>
    <pie-chart :data="chartData"></pie-chart>
  </div>
</template>

<script>
import { Bar, Line, Pie } from 'vue-chartjs';

export default {
  name: 'ChartManager',
  components: {
    'bar-chart': Bar,
    'line-chart': Line,
    'pie-chart': Pie
  },
  data() {
    return {
      chartData: {
        labels: ['January', 'February', 'March'],
        datasets: [
          {
            label: 'Working Hours',
            backgroundColor: '#f87979',
            data: [40, 20, 30]
          }
        ]
      }
    };
  }
};
</script>

<style scoped>
/* Add your CSS here */
</style>
