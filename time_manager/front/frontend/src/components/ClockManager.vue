<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="p-6 max-w-lg w-full bg-white rounded-xl shadow-md space-y-4">
      <h2 class="text-2xl font-bold text-center text-teal-600">Clock Manager</h2>

      <div class="mb-4">
        <label for="userSelect" class="block text-sm font-medium text-gray-700">Select User:</label>
        <select
          id="userSelect"
          v-model="selectedUserId"
          @change="handleUserSelection"
          class="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-teal-500 focus:border-teal-500 sm:text-sm">
          <option value="" disabled>Select a user</option>
          <option v-for="user in users.data" :key="user.id" :value="user.id">
            {{ user.username }}
          </option>
        </select>
      </div>

      <div v-if="selectedUser" class="space-y-4">
        <p class="text-lg font-semibold">User: <span class="font-medium">{{ selectedUser.data.username }} (ID: {{ selectedUser.data.id }})</span></p>
        <p class="text-gray-500">Email: {{ selectedUser.data.email }}</p>

        <div class="flex items-center space-x-2">
          <p class="text-lg">Clock Status:</p>
          <span :class="clockIn ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'"
                class="px-4 py-1 rounded-full font-semibold">
            {{ clockIn ? 'Clocked In' : 'Clocked Out' }}
          </span>
        </div>

        <div v-if="lastClock" class="text-sm text-gray-600">
          <p>Last Clock: {{ lastClock.time }}</p>
          <p v-if="!clockIn">Last shift : {{ calculateTimeGap() }}</p>
        </div>

        <div class="space-x-2">
          <button
            @click="clock"
            v-if="!clockIn"
            class="bg-teal-500 text-white px-4 py-2 rounded-md hover:bg-teal-600 transition">
            Clock In
          </button>

          <button
            @click="refresh"
            v-if="clockIn"
            class="bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition">
            Clock Out
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'UserClockManager',
  data() {
    return {
      users: [],
      clocks : null,
      selectedUserId: '',
      selectedUser: null,
      clockIn: false,
      lastClock: null,
    };
  },
  methods: {
    async fetchUsers() {
      try {
        const response = await axios.get('http://localhost:4000/api/users');
        this.users = response.data;
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    },
    async handleUserSelection() {
      if (!this.selectedUserId) return;

      try {
        const response = await axios.get(`http://localhost:4000/api/users/${this.selectedUserId}`);
        this.selectedUser = response.data;
        await this.fetchClockStatus(this.selectedUserId);
      } catch (error) {
        console.error('Error fetching selected user:', error);
      }
    },
    async fetchClockStatus(userId) {
      try {
        const response = await axios.get(`http://localhost:4000/api/clocks/${userId}`);
        this.clocks = response.data.data;
        if (this.clocks.length > 0) {
          this.lastClock = this.clocks[this.clocks.length - 1];
          this.clockIn = this.lastClock.status === true;
        } else {
          this.lastClock = null;
          this.clockIn = false;
        }

      } catch (error) {
        console.error('Error fetching clock status:', error);
      }
    },

    calculateTimeGap() {
      if (!this.lastClock || this.clockIn) return '';

      const lastClockIn = this.clocks
        .slice()
        .reverse()
        .find(clock => clock.status === true);

      if (!lastClockIn.status) return 'No previous clock-in found';

      const clockOutTime = new Date(this.lastClock.time);

      const clockInTime = new Date(lastClockIn.time);
      const diffInMs = clockOutTime - clockInTime;

      const diffInHours = (diffInMs / 1000 / 60 / 60).toFixed(2);

      return `${diffInHours} hour(s)`;
    },
    async clock() {
      if (!this.selectedUserId) return;

      try {
        await axios.post(`http://localhost:4000/api/clocks/${this.selectedUserId}`, {
          clock: {
            time: new Date().toISOString(),
            status: true,
            user_id: this.selectedUserId
          }
        });
        await this.fetchClockStatus(this.selectedUserId);
      } catch (error) {
        console.error('Error clocking in:', error);
      }
    },
    async refresh() {
      if (!this.selectedUserId) return;

      try {
        await axios.post(`http://localhost:4000/api/clocks/${this.selectedUserId}`, {
          clock: {
            time: new Date().toISOString(),
            status: false,
            user_id: this.selectedUserId
          }
        });
        await this.fetchClockStatus(this.selectedUserId);
      } catch (error) {
        console.error('Error clocking out:', error);
      }
    },
  },
  mounted() {
    this.fetchUsers();
  },
};
</script>

<style scoped>
</style>
