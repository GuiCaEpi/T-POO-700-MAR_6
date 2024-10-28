<template>
  <div class="h-screen flex flex-col" id="app">
    <header className="bg-white shadow-md p-4 flex flex-row justify-between">
      <div className="flex justify-center items-center">
        <h1 className="text-2xl font-semibold">TM App</h1>
      </div>
      <nav className="flex justify-center items-center">
        <div
          className="flex flex-row justify-between text-sm md:text-base font-semibold gap-4"
        >
          <router-link to="/">
            <div class="hover:text-gray-500"
              >User Manager</div
            >
          </router-link>
          <router-link class="hover:text-gray-500" to="/working-times">Working Times</router-link>
          <router-link class="hover:text-gray-500" to="/clock">Clock Manager</router-link>
          <router-link class="hover:text-gray-500" to="/chart-manager/1"
            >Chart Manager</router-link
          >
        </div>
      </nav>
    </header>
    <router-view />
  </div>
</template>

<script>
export default {
  name: "App",
};
</script>
