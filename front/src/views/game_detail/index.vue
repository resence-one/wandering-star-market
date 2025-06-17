<template>
  <div class="game-detail-page" v-loading="loading">
    <div v-if="game" class="game-content">
      <div class="game-header">
        <img :src="game.coverImage || 'https://via.placeholder.com/400x500?text=No+Image'" :alt="game.name" class="game-cover">
        <div class="game-info">
          <h1>{{ game.name }}</h1>
          <p class="game-price">￥{{ Number(game.price).toFixed(2) }}</p>
          <div class="purchase-actions">
            <el-button type="primary" size="large" :disabled="isUpcoming" :class="{ 'is-disabled-purchase': isUpcoming }">立即购买</el-button>
            <el-button size="large">加入购物车</el-button>
            <el-button size="large">加入心愿单</el-button>
          </div>
          <div class="game-meta">
            <p><strong>发行日期:</strong> {{ formatDate(game.releaseDate) }}</p>
            <p><strong>游戏状态:</strong> {{ formatStatus(game.status) }}</p>
            <p><strong>分类:</strong> {{ getCategoryName(game.categoryId) }}</p>
          </div>
        </div>
      </div>

      <div class="game-sections">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="游戏简介" name="overview">
            <div class="section-content" v-html="formatDescription(game.longDescription)"></div>
          </el-tab-pane>
          <el-tab-pane label="游戏特色" name="features">
            <div class="section-content" v-html="formatDescription(game.features)"></div>
          </el-tab-pane>
          <el-tab-pane label="系统要求" name="requirements">
            <div class="section-content" v-html="formatDescription(game.systemRequirements)"></div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
    <div v-else-if="!loading" class="no-game-found">
      <el-empty description="游戏不存在或已下架"></el-empty>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch, computed } from 'vue';
import { useRoute } from 'vue-router';
import { getGameDetail, getGameCategories } from '@/api/game'; // 假设你有一个API来获取游戏详情

export default {
  name: 'GameDetailPage',
  setup() {
    const route = useRoute();
    const game = ref(null);
    const loading = ref(true);
    const activeTab = ref('overview');
    const categories = ref([]);

    // 计算属性：判断游戏是否为预发售状态
    const isUpcoming = computed(() => {
      return game.value && game.value.status === 2;
    });

    const loadGameDetail = async (id) => {
      loading.value = true;
      try {
        const res = await getGameDetail(id);
        if (res) {
          game.value = res;
        } else {
          game.value = null;
        }
      } catch (error) {
        console.error('获取游戏详情失败:', error);
        game.value = null;
      } finally {
        loading.value = false;
      }
    };

    const loadCategories = async () => {
      try {
        const res = await getGameCategories();
        if (res) {
          categories.value = res;
        }
      } catch (error) {
        console.error('获取分类失败:', error);
      }
    };

    const formatDate = (dateString) => {
      if (!dateString) return 'N/A';
      const date = new Date(dateString);
      return date.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' });
    };

    const formatStatus = (status) => {
      switch (status) {
        case 0: return '已下架';
        case 1: return '已上架';
        case 2: return '预发售';
        default: return '未知';
      }
    };

    const getCategoryName = (categoryId) => {
      const category = categories.value.find(cat => cat.id === categoryId);
      return category ? category.name : '未知分类';
    };

    const formatDescription = (text) => {
      if (!text) return '暂无描述';
      return text.replace(/\n/g, '<br/>'); // 将 \n 替换为 <br/>
    };

    onMounted(() => {
      const gameId = route.params.id;
      if (gameId) {
        loadCategories(); // 先加载分类，因为详情页可能需要显示分类名称
        loadGameDetail(gameId);
      }
    });

    watch(
      () => route.params.id,
      (newId) => {
        if (newId) {
          loadGameDetail(newId);
        }
      }
    );

    return {
      game,
      loading,
      activeTab,
      formatDate,
      formatStatus,
      getCategoryName,
      formatDescription,
      isUpcoming
    };
  }
};
</script>

<style lang="scss" scoped>
.game-detail-page {
  max-width: 1200px;
  margin: 20px auto;
  padding: 30px;
  background-color: #1a1a1a;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
  color: #e0e0e0;

  .game-content {
    .game-header {
      display: flex;
      gap: 40px;
      margin-bottom: 40px;
      align-items: flex-start;

      .game-cover {
        width: 300px;
        height: 400px;
        object-fit: cover;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
      }

      .game-info {
        flex: 1;

        h1 {
          font-size: 36px;
          color: #fff;
          margin-bottom: 15px;
        }

        .game-price {
          font-size: 32px;
          color: #409eff;
          font-weight: bold;
          margin-bottom: 25px;
        }

        .purchase-actions {
          display: flex;
          gap: 15px;
          margin-bottom: 30px;

          .el-button {
            padding: 12px 25px;
            font-size: 16px;
            border-radius: 6px;
          }

          .is-disabled-purchase {
            background-color: #606266 !important; /* 灰色背景 */
            border-color: #606266 !important; /* 灰色边框 */
            color: #a0a0a0 !important; /* 灰色文字 */
            cursor: not-allowed !important; /* 禁用光标 */
            opacity: 0.8; /* 降低不透明度 */
          }
        }

        .game-meta {
          p {
            font-size: 16px;
            margin-bottom: 10px;
            color: #ccc;
          }

          strong {
            color: #fff;
          }
        }
      }
    }

    .game-sections {
      :deep(.el-tabs__header) {
        margin-bottom: 30px;
      }

      :deep(.el-tabs__nav-wrap::after) {
        background-color: #333;
      }

      :deep(.el-tabs__item) {
        color: #e0e0e0;
        font-size: 18px;
        font-weight: bold;

        &:hover {
          color: #409eff;
        }

        &.is-active {
          color: #409eff;
        }
      }

      :deep(.el-tabs__active-bar) {
        background-color: #409eff;
      }

      .section-content {
        background-color: #2a2a2a;
        padding: 25px;
        border-radius: 8px;
        line-height: 1.8;
        font-size: 16px;
        color: #c0c0c0;
        min-height: 150px; // 确保内容区域有最小高度

        // 处理从后端获取的换行符
        white-space: pre-wrap;
      }
    }
  }

  .no-game-found {
    text-align: center;
    padding: 100px 0;
  }
}
</style> 