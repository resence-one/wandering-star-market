<template>
    <div class="games-page">
      <div class="sidebar">
        <h3>游戏分类</h3>
        <ul class="category-list">
          <li
            :class="{'active': selectedCategoryId === null}"
            @click="selectCategory(null)"
          >
            全部
          </li>
          <li
            v-for="category in categories"
            :key="category.id"
            :class="{'active': selectedCategoryId === category.id}"
            @click="selectCategory(category.id)"
          >
            {{ category.name }}
          </li>
        </ul>
        <!-- 价格区间等其他筛选条件可以后续添加 -->
      </div>

      <div class="main-content">
        <div class="filter-bar">
          <div class="sort-options">
            <span>推荐排序</span>
            <el-select v-model="sortBy" placeholder="推荐排序" size="small" @change="loadGames">
              <el-option label="最新发售" value="releaseDate"></el-option>
              <el-option label="价格从低到高" value="price_asc"></el-option>
              <el-option label="价格从高到低" value="price_desc"></el-option>
              <!-- 更多排序选项 -->
            </el-select>
          </div>
          <div class="price-range">
            <span>价格区间</span>
            <el-input v-model="minPrice" placeholder="最小" size="small" style="width: 80px;"></el-input>
            <span>-</span>
            <el-input v-model="maxPrice" placeholder="最大" size="small" style="width: 80px;"></el-input>
            <el-button type="primary" size="small" @click="loadGames">确定</el-button>
          </div>
        </div>

        <div v-if="loading" class="loading-indicator">加载中...</div>
        <div v-else-if="games.length === 0" class="no-data">暂无游戏</div>
        <div v-else class="game-grid">
          <div v-for="game in games" :key="game.id" class="game-card" @click="goToGameDetail(game.id)">
            <div class="game-cover">
              <img :src="game.coverImage || 'https://via.placeholder.com/200x266?text=No+Image'" :alt="game.name">
              <div v-if="game.discount" class="discount-tag">-{{ game.discount }}%</div>
            </div>
            <div class="game-info">
              <h3>{{ game.name }}</h3>
              <p v-if="game.originalPrice" class="original-price">¥{{ Number(game.originalPrice).toFixed(2) }}</p>
              <p class="current-price">¥{{ Number(game.price).toFixed(2) }}</p>
            </div>
          </div>
        </div>

        <el-pagination
          v-if="total > pageSize"
          :current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="handlePageChange"
          class="pagination"
        >
        </el-pagination>
      </div>
    </div>
  </template>

  <script>
  import { ref, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { getGameList, getGameCategories } from '@/api/game'

  export default {
    name: 'GamesPage',
    setup() {
      const router = useRouter()
      const categories = ref([])
      const games = ref([])
      const loading = ref(false)
      const selectedCategoryId = ref(null)
      const sortBy = ref('createdAt') // 默认排序
      const minPrice = ref(null)
      const maxPrice = ref(null)
      const currentPage = ref(1)
      const pageSize = ref(12)
      const total = ref(0)

      const loadCategories = async () => {
        try {
          const res = await getGameCategories()
          console.log('Categories API response:', res)
          categories.value = res
        } catch (error) {
          console.error('获取分类失败:', error)
        }
      }

      const loadGames = async () => {
        loading.value = true
        try {
          const params = {
            page: currentPage.value,
            size: pageSize.value,
            categoryId: selectedCategoryId.value,
            minPrice: minPrice.value,
            maxPrice: maxPrice.value
          }

          // 处理排序
          if (sortBy.value) {
            if (sortBy.value.includes('price')) {
              params.sortBy = 'price'
              params.sortOrder = sortBy.value.endsWith('_asc') ? 'asc' : 'desc'
            } else {
              params.sortBy = sortBy.value
              params.sortOrder = 'desc' // 默认降序
            }
          }

          const res = await getGameList(params)
          console.log('Game List API response:', res)

          if (res.records) {
            games.value = res.records.map(game => ({
              ...game,
              // 模拟 discount 和 originalPrice，实际应由后端返回
              discount: game.price < 100 ? Math.floor(Math.random() * (70 - 10 + 1)) + 10 : null,
              originalPrice: game.price < 100 ? Number(game.price) + Math.random() * 50 : null // 模拟原价
            }))
            total.value = res.total
          } else {
            games.value = []
            total.value = 0
          }
        } catch (error) {
          console.error('获取游戏列表失败:', error)
          games.value = []
          total.value = 0
        } finally {
          loading.value = false
        }
      }

      const selectCategory = (categoryId) => {
        selectedCategoryId.value = categoryId
        currentPage.value = 1 // 切换分类回到第一页
        loadGames()
      }

      const handlePageChange = (page) => {
        currentPage.value = page
        loadGames()
      }

      const goToGameDetail = (id) => {
        router.push(`/game/${id}`)
      }

      onMounted(() => {
        loadCategories()
        loadGames()
      })

      return {
        categories,
        games,
        loading,
        selectedCategoryId,
        sortBy,
        minPrice,
        maxPrice,
        currentPage,
        pageSize,
        total,
        selectCategory,
        handlePageChange,
        goToGameDetail,
        loadGames
      }
    }
  }
  </script>

  <style lang="scss" scoped>
  .games-page {
    display: flex;
    max-width: 1400px;
    margin: 20px auto;
    background-color: #1a1a1a;
    color: #e0e0e0;
    border-radius: 8px;
    overflow: hidden;
    min-height: calc(100vh - 60px - 200px - 40px); // 减去header, footer, 和上下margin

    .sidebar {
      width: 250px;
      background-color: #2a2a2a;
      padding: 20px;
      border-right: 1px solid #333;

      h3 {
        font-size: 20px;
        color: #fff;
        margin-bottom: 20px;
        border-left: 4px solid #409eff;
        padding-left: 10px;
      }

      .category-list {
        list-style: none;
        padding: 0;

        li {
          padding: 10px 15px;
          margin-bottom: 5px;
          border-radius: 4px;
          cursor: pointer;
          transition: all 0.3s;

          &:hover {
            background-color: #3a3a3a;
            color: #409eff;
          }

          &.active {
            background-color: #409eff;
            color: #fff;
            font-weight: bold;
          }
        }
      }
    }

    .main-content {
      flex: 1;
      padding: 20px;

      .filter-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        background-color: #2a2a2a; /* 筛选条背景色 */
        border-bottom: 1px solid #3a3a3a;
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;

        .sort-options,
        .price-range {
          display: flex;
          align-items: center;
          span {
            margin-right: 10px;
            color: #e0e0e0;
          }
        }

        // 调整Element Plus Select的样式以适应暗色主题
        :deep(.el-select) {
          .el-input__wrapper {
            background-color: #3a3a3a; /* 输入框背景 */
            box-shadow: none !important; /* 移除阴影 */
            border: 1px solid #555; /* 输入框边框 */
            
            &.is-focus,
            &:hover {
              border-color: #409eff; /* 聚焦和悬停边框色 */
            }
          }

          .el-input__inner {
            color: #e0e0e0; /* 文字颜色 */
          }

          .el-icon {
            color: #e0e0e0; /* 图标颜色 */
          }
        }

        // 价格区间输入框样式
        .price-range {
          span {
            &:first-child { /* 价格区间文本 */
              margin-right: 10px;
            }
            &:nth-child(3) { /* 横线 - */
              margin: 0 10px; /* 左右间隔 */
            }
            color: #e0e0e0;
          }

          .el-input {
            // 针对输入框内部wrapper
            :deep(.el-input__wrapper) {
              background-color: #ffffff !important; /* 强制设置为白色背景 */
              border: 1px solid #ffffff !important; /* 强制设置为白色边框 */
              box-shadow: none !important; /* 移除阴影 */

              &.is-focus,
              &:hover {
                border-color: #409eff !important; /* 聚焦和悬停边框色 */
              }
            }

            // 针对输入框内的文本
            :deep(.el-input__inner) {
              color: #333333 !important; /* 强制设置为深色文字 */
              &::placeholder {
                color: #999999 !important; /* 强制设置为深色 placeholder */
              }
            }
          }

          .el-button {
            margin-left: 10px; /* 确定按钮左侧间隔 */
            background-color: #409eff;
            border-color: #409eff;

            &:hover {
              background-color: #66b1ff;
              border-color: #66b1ff;
            }
          }
        }
      }

      .loading-indicator,
      .no-data {
        text-align: center;
        padding: 50px;
        font-size: 18px;
        color: #888;
      }

      .game-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 20px;
        padding: 20px;

        .game-card {
          background: #2a2a2a;
          border-radius: 8px;
          overflow: hidden;
          cursor: pointer;
          transition: transform 0.3s, box-shadow 0.3s;
          border: 1px solid #333;

          &:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
          }

          .game-cover {
            position: relative;
            width: 100%;
            padding-top: 133%; // 200/266 比例
            overflow: hidden;

            img {
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              object-fit: cover;
            }

            .discount-tag {
              position: absolute;
              top: 10px;
              right: 10px;
              background: #ff4d4f;
              color: #fff;
              padding: 5px 10px;
              border-radius: 4px;
              font-size: 13px;
              font-weight: bold;
            }
          }

          .game-info {
            padding: 15px;
            text-align: center;

            h3 {
              margin: 0 0 10px;
              font-size: 18px;
              color: #fff;
              white-space: nowrap;
              overflow: hidden;
              text-overflow: ellipsis;
            }

            .original-price {
              color: #888;
              text-decoration: line-through;
              font-size: 14px;
              margin-bottom: 5px;
            }

            .current-price {
              color: #ff4d4f;
              font-size: 20px;
              font-weight: bold;
            }
          }
        }
      }

      .pagination {
        margin-top: 30px;
        text-align: center;

        :deep(.el-pager li),
        :deep(.el-pagination button) {
          background-color: #2a2a2a !important;
          color: #e0e0e0 !important;

          &:hover {
            color: #409eff !important;
          }
          &.is-active {
            background-color: #409eff !important;
            color: #fff !important;
          }
        }
      }
    }
  }
  </style>