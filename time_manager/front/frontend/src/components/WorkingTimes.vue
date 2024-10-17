<template>
    <div class="container mx-auto p-4">
      <h1 class="text-2xl md:text-3xl font-semibold mb-6">Working Times</h1>
  
      <!-- Search User by Username or Email -->
  
      <div class="flex flex-row justify-between">
        <div class="flex justify-center items-center relative w-1/2 md:w-1/3">
          <input
            type="text"
            v-model="searchQuery"
            @input="filterUsers"
            @focus="showSuggestions = true"
            placeholder="Type username or email..."
            class="shadow appearance-none border rounded w-full py-3 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
          <ul
            v-if="showSuggestions && filteredUsers.length > 0"
            class="absolute left-0 right-0 mt-2 bg-white rounded-md shadow-md z-10"
          >
            <li
              v-for="user in filteredUsers"
              :key="user.id"
              @click="selectUser(user)"
              class="px-4 py-2 cursor-pointer hover:bg-gray-100"
            >
              {{ user.name }} ({{ user.email }})
            </li>
          </ul>
        </div>
        <div class="flex justify-center items-center">
          <button
            @click="addWorkingTime"
            class="bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded"
          >
            Add
          </button>
        </div>
      </div>
  
      <!-- Display Working Times for Selected User -->
      <div v-if="selectedUser" class="mb-4">
        <label class="block text-lg font-bold mb-2"
          >Working Times for {{ selectedUser.name }}:</label
        >
  
        <div class="table-container overflow-x-auto">
          <table class="table-auto w-full border-collapse border border-gray-300">
            <thead>
              <tr class="bg-gray-100">
                <th class="border px-4 py-2">Date</th>
                <th class="border px-4 py-2">Start Time</th>
                <th class="border px-4 py-2">End Time</th>
                <th class="border px-4 py-2">Duration (hours)</th>
                <th class="border px-4 py-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="workingTime in selectedUser.workingTimes"
                :key="workingTime.id"
                class="hover:bg-gray-50"
              >
                <td class="border px-4 py-2">
                  {{ formatDate(workingTime.startTime) }}
                </td>
                <td class="border px-4 py-2">
                  {{ formatTime(workingTime.startTime) }}
                </td>
                <td class="border px-4 py-2">
                  {{ formatTime(workingTime.endTime) }}
                </td>
                <td class="border px-4 py-2">
                  {{
                    calculateDuration(workingTime.startTime, workingTime.endTime)
                  }}
                </td>
                <button
                  @click="editWorkingTime(workingTime)"
                  class="bg-yellow-500 hover:bg-yellow-700 text-white py-1 px-2 rounded"
                >
                  E
                </button>
                <button
                  @click="deleteWorkingTime(workingTime.id)"
                  class="bg-red-500 hover:bg-red-700 text-white py-1 px-2 rounded"
                >
                  D
                </button>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
  
      <div v-else-if="searchQuery && filteredUsers.length === 0">
        <p class="text-gray-600">No users found for the search query.</p>
      </div>
    </div>
  </template>
  
  <script>
  import { format } from "date-fns";
  import axios from "axios";
  
  export default {
      
    name: "WorkingTimes",
    data() {
      return {
        // Mock user list with working times
        users: [
          {
            id: "123",
            name: "User A",
            email: "userA@example.com",
            workingTimes: [
              {
                id: 1,
                startTime: new Date(2024, 9, 10, 9, 0),
                endTime: new Date(2024, 9, 10, 17, 0),
              },
              {
                id: 2,
                startTime: new Date(2024, 9, 11, 10, 0),
                endTime: new Date(2024, 9, 11, 18, 0),
              },
            ],
          },
          {
            id: "124",
            name: "User B",
            email: "userB@example.com",
            workingTimes: [
              {
                id: 3,
                startTime: new Date(2024, 9, 12, 8, 30),
                endTime: new Date(2024, 9, 12, 16, 30),
              },
            ],
          },
          {
            id: "125",
            name: "User C",
            email: "userC@example.com",
            workingTimes: [
              {
                id: 4,
                startTime: new Date(2024, 9, 13, 9, 15),
                endTime: new Date(2024, 9, 13, 17, 45),
              },
            ],
          },
        ],
        searchQuery: "", // User input for search query
        filteredUsers: [],
        selectedUser: null, // Stores the user selected from suggestions
        showSuggestions: false,
      };
    },
    methods: {
      formatDate(date) {
        return format(date, "yyyy-MM-dd");
      },
      formatTime(date) {
        return format(date, "HH:mm");
      },
      addWorkingTime(){
          this.$router.push(`/workingTime/${this.route.params.userId}`);
      },
      editWorkingTime(workingTime) {
          this.$router.push(`/workingTime/${this.route.params.userId}/${workingTime.id}`);
      },
      async deleteWorkingTime(workingTimeId) {
          try{
              await axios.delete(`http://localhost:4000/api/workingTimes/${workingTimeId}`);
              this.fetchWorkingTimes();
          } catch (error) {
              console.error('error deleting working time',error);
          }
          },
  
  
      calculateDuration(startTime, endTime) {
        const duration = (endTime - startTime) / (1000 * 60 * 60);
        return duration.toFixed(2); // Duration in hours
      },
      filterUsers() {
        // Filter users based on search query (by username or email)
        if (this.searchQuery) {
          this.filteredUsers = this.users.filter(
            (user) =>
              user.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
              user.email.toLowerCase().includes(this.searchQuery.toLowerCase())
          );
        } else {
          // If no search query, reset filtered list
          this.filteredUsers = [];
        }
      },
      selectUser(user) {
        // Set the selected user
        this.selectedUser = user;
        // Clear searchQuery and hide suggestions after selection
        this.searchQuery = user.name;
        this.showSuggestions = false;
      },
    },
  };
  </script>
  
  <style scoped>
  .table-container {
    max-width: 100%;
    overflow-x: auto;
  }
  </style>