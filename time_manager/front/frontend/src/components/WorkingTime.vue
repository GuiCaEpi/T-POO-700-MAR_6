<template>
  <div>
    <h1>{{ editMode ? 'Edit Working Time' : 'Add New Working Time' }}</h1>
    <form @submit.prevent="handleSubmit">
      <div>
        <label for="startTime">Start Time:</label>
        <input type="datetime-local" v-model="workingTime.startTime" required />
      </div>
      <div>
        <label for="endTime">End Time:</label>
        <input type="datetime-local" v-model="workingTime.endTime" required />
      </div>
      <button type="submit" class="bg-blue-500 text-white py-2 px-4 rounded">{{ editMode ? 'Update' : 'Add' }}</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      workingTime: {
        startTime: '',
        endTime: ''
      },
      editMode: false
    };
  },
  methods: {
    async handleSubmit() {
      try {
        if (this.editMode) {
          await axios.put(`http://localhost:4000/api/workingTimes/${this.$route.params.workingTimeId}`, this.workingTime);
        } else {
          await axios.post(`http://localhost:4000/api/workingTimes/${this.$route.params.userId}`, this.workingTime);
        }
        this.$router.push(`/workingTimes/${this.$route.params.userId}`);
      } catch (error) {
        console.error('Error saving working time:', error);
      }
    }
  },
  mounted() {
    // If the route contains workingTimeId, it means we're in edit mode
    if (this.$route.params.workingTimeId) {
      this.editMode = true;
      this.fetchWorkingTime();
    }
  },
  async fetchWorkingTime() {
    try {
      const response = await axios.get(`http://localhost:4000/api/workingTimes/${this.$route.params.workingTimeId}`);
      this.workingTime = response.data;
    } catch (error) {
      console.error('Error fetching working time:', error);
    }
  }
};
</script>
