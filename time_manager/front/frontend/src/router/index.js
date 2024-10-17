import { createRouter, createWebHistory } from 'vue-router';
import UserManager from '../components/UserManager.vue';
import WorkingTimes from '../components/WorkingTimes.vue';
import WorkingTime from '../components/WorkingTime.vue';
import ClockManager from '../components/ClockManager.vue';
import ChartManager from '../components/ChartManager.vue';

const routes = [
  {
    path: '/',
    name: 'UserManager',
    component: UserManager
  },
  {
    path: '/working-times',
    name: 'WorkingTimes',
    component: WorkingTimes
  },
  {
    path: '/working-time/:userid',
    name: 'WorkingTime',
    component: WorkingTime
  },
  {
    path: '/clock',
    name: 'ClockManager',
    component: ClockManager
  },
  {
    path: '/chart-manager/:userid',
    name: 'ChartManager',
    component: ChartManager
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
