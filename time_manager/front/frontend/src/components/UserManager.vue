<template>
  <div class="h-screen w-full container flex items-center mx-auto shadow">
   <div class="h-[calc(100vh-100px)] flex flex-row justify-between bg-gray-100 w-full">
    <div class="flex flex-col w-1/2 md:w-2/3 justify-center">
      <div class="flex p-4 items-center justify-center">
        <form @submit.prevent="handleSubmit" class="bg-white w-full md:w-2/3 shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <div class="mb-4 relative">
            <h1 class="text-xl md:text-2xl font-bold mb-4 text-center">{{ editMode ? "Edit User" : "Add User" }}</h1>
            <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username:</label>
            <div class="relative">
              <i class="fas fa-user absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input
                type="text"
                placeholder="Username"
                v-model="user.username"
                id="username"
                required
                class="shadow appearance-none border rounded w-full py-3 px-10 text-gray-700 leading-tight focus:outline-none focus:shadow-outline focus:border-blue-200"
              />
            </div>
          </div>
          <div class="mb-6 relative">
            <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
            <div class="relative">
              <i class="fas fa-envelope absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input
                type="email"
                v-model="user.email"
                id="email"
                required
                placeholder="Email"
                class="focus:border-blue-200 shadow appearance-none border rounded w-full py-3 px-10 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              />
            </div>
          </div>
          <div class="w-full flex items-center justify-center pt-4">
            <button type="submit" class="bg-blue-400 hover:bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
              {{ editMode ? "Update User" : "Add User" }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- User List -->
    <div class="flex flex-col w-1/2 md:w-1/3 bg-white rounded-lg px-4">
      <h2 class="text-2xl md:text-3xl font-semibold p-4 mb-4 flex items-start">Current Users List</h2>
      <div class="h-full list-disc list-inside bg-gray-200 flex flex-col gap-2 p-4 rounded-lg overflow-y-auto">
        
        <input
        type="text"
        v-model="searchQuery"
        placeholder="Search users"
        class="mb-4 p-2 rounded-md border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        />

        <div v-for="user in filteredUsers" :key="user.id" class="rounded-lg mb-2 flex justify-between items-center p-4 bg-white hover:bg-gray-100">
          <div class="flex flex-row justify-center items-center gap-2">
           <img src="https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg" alt="User Avatar" class="w-12 h-12 rounded-full">
           <div class="flex flex-col">
            <span class="font-semibold">{{ user.username }}</span>
            <span class="text-xs text-gray-600">{{ user.email }}</span>
          </div>
        </div>
          <div>
            <button @click="toggleMenu(user.id)" class="focus:outline-none">
              <i class="fas fa-ellipsis-v text-gray-700"></i>
            </button>
          </div>

          <div v-if="user.id === dropdownUserId" class="absolute right-0 mt-2 w-32 bg-white rounded-md shadow-lg z-10">
              <ul>
                <li>
                  <button @click="editUser(user)" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 w-full text-left">
                    <i class="fas fa-edit mr-2"></i> Edit
                  </button>
                </li>
                <li>
                  <button @click="deleteUser(user.id)" class="block px-4 py-2 text-sm text-red-700 hover:bg-gray-100 w-full text-left">
                    <i class="fas fa-trash mr-2"></i> Delete
                  </button>
                </li>
              </ul>
            </div>

        </div>
    </div>
    </div>
  </div>
  </div> 
</template>


<script>

export default {
  name: 'UserManager',
  data() {
    return {
      // Using mock data for users
      users: [
        { id: 1, username:'Kae98', email: 'Kae@example.com' },
        { id: 2, username: 'JaneSmith', email: 'jane@example.com' },
        { id: 3, username: 'AliceJohnson', email: 'alice@example.com' },
        { id: 4, username:'Kae98', email: 'Kae@example.com' },
        { id: 5, username: 'JaneSmith', email: 'jane@example.com' },
        { id: 6, username: 'AliceJohnson', email: 'alice@example.com' },
        { id: 7, username:'Kae98', email: 'Kae@example.com' },
        { id: 8, username: 'JaneSmith', email: 'jane@example.com' },
        { id: 9, username: 'AliceJohnson', email: 'alice@example.com' }
      ],
      user: {
        username:'',
        email: ''
      },
      editMode: false,
      editUserId: null,
      dropdownUserId: null,
      searchQuery: ''
    };
  },

  computed: {
    // Computed property to filter users based on search query
    filteredUsers() {
      if (!this.searchQuery) {
        return this.users;
      }
      const query = this.searchQuery.toLowerCase();
      return this.users.filter(user =>
        user.username.toLowerCase().includes(query) || user.email.toLowerCase().includes(query)
      );
    }
  },

  methods: {
    // Handle adding/updating user
    handleSubmit() {
      if (this.editMode) {
        // Update user
        const userIndex = this.users.findIndex(user => user.id === this.editUserId);
        if (userIndex !== -1) {
          this.users[userIndex] = { ...this.user, id: this.editUserId };
        }
        this.editMode = false;
        this.editUserId = null;
      } else {
        // Add new user
        const newUser = { ...this.user, id: this.users.length + 1 };
        this.users.push(newUser);
      }
      this.user = { username: '', email: '' }; // Clear form
    },
    // Populate form fields for editing
    editUser(user) {
      this.user.username = user.username;
      this.user.email = user.email;
      this.editMode = true;
      this.editUserId = user.id;
      this.dropdownUserId = null; // Close dropdown after selecting edit
    },
    deleteUser(userId) {
      this.users = this.users.filter(user => user.id !== userId);
      this.dropdownUserId = null; // Close dropdown after deleting
    },
    toggleMenu(userId) {
      if (this.dropdownUserId === userId) {
        this.dropdownUserId = null; // Close the dropdown if clicked again
      } else {
        this.dropdownUserId = userId; // Set the ID to open the dropdown for that user
      }
    }
  }
};
</script>


<style scoped>
</style>