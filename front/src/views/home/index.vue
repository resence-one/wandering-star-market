<template>
  <div class="home-page">
    <!-- 游戏分类导航 -->
    <div class="category-nav">
      <div class="category-list">
        <div
          v-for="category in categories"
          :key="category.id"
          class="category-item"
          @click="goToCategory(category.id)"
        >
          {{ category.name }}
        </div>
      </div>
    </div>

    <!-- 顶部轮播/推荐大图 -->
    <div class="banner-section">
      <el-carousel height="400px" :interval="5000" arrow="hover">
        <el-carousel-item v-for="item in banners" :key="item.id">
          <div class="banner-item" :style="{ backgroundImage: 'url(' + item.imageUrl + ')' }">
            <div class="banner-content">
              <h2 class="banner-title">{{ item.title }}</h2>
              <p class="banner-description">{{ item.description }}</p>
              <el-button type="primary" class="view-detail-btn">立即查看</el-button>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <!-- 推荐游戏 -->
    <div class="section featured-games">
      <div class="section-header">
        <h2>推荐游戏</h2>
        <el-button type="text" class="more-btn" @click="goToMore('featured')" v-if="featuredGames.total >= 6">查看更多 ></el-button>
      </div>
      <div v-if="featuredGames.records && featuredGames.records.length === 0" style="color: gray; text-align: center; padding: 20px;">目前没有推荐游戏</div>
      <div class="game-grid">
        <div v-for="game in featuredGames.records.slice(0, 6)" :key="game.id" class="game-card" @click="goToGameDetail(game.id)">
          <div class="game-cover">
            <img :src="game.coverImage || 'https://via.placeholder.com/200x266?text=No+Image'" :alt="game.name">
            <div v-if="game.discount" class="discount-tag">-{{ game.discount }}%</div>
          </div>
          <div class="game-info">
            <h3>{{ game.name }}</h3>
            <p v-if="game.originalPrice" class="original-price">¥{{ game.originalPrice != null ? Number(game.originalPrice).toFixed(2) : '--' }}</p>
            <p class="current-price">¥{{ game.price != null ? Number(game.price).toFixed(2) : '--' }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 即将发售 -->
    <div class="section upcoming-games">
      <div class="section-header">
        <h2>即将发售</h2>
        <el-button type="text" class="more-btn" @click="goToMore('upcoming')" v-if="upcomingGames.length >= 6">查看更多 ></el-button>
      </div>
      <div class="game-grid">
        <div v-for="game in upcomingGames.slice(0, 6)" :key="game.id" class="game-card" @click="goToGameDetail(game.id)">
          <div class="game-cover">
            <img :src="game.coverImage || 'https://via.placeholder.com/200x266?text=No+Image'" :alt="game.name">
            <div class="release-date-tag">{{ formatDate(game.releaseDate) }} 发售</div>
          </div>
          <div class="game-info">
            <h3>{{ game.name }}</h3>
            <p class="current-price">¥{{ game.price != null ? Number(game.price).toFixed(2) : '--' }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 限时促销 -->
    <div class="section promotion-games">
      <div class="section-header">
        <h2>限时促销</h2>
        <el-button type="text" class="more-btn" @click="goToMore('promotion')" v-if="promotionGames.total >= 6">查看更多 ></el-button>
      </div>
      <div class="game-grid">
        <div v-for="game in promotionGames.records.slice(0, 6)" :key="game.id" class="game-card" @click="goToGameDetail(game.id)">
          <div class="game-cover">
            <img :src="game.coverImage || 'https://via.placeholder.com/200x266?text=No+Image'" :alt="game.name">
            <div class="discount-tag">-{{ game.discount }}%</div>
          </div>
          <div class="game-info">
            <h3>{{ game.name }}</h3>
            <p class="original-price">¥{{ game.originalPrice != null ? Number(game.originalPrice).toFixed(2) : '--' }}</p>
            <p class="current-price">¥{{ game.price != null ? Number(game.price).toFixed(2) : '--' }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 热门神作 -->
    <div class="section hot-games">
      <div class="section-header">
        <h2>热门神作</h2>
        <el-button type="text" class="more-btn" @click="goToMore('hot')" v-if="hotGames.total >= 6">查看更多 ></el-button>
      </div>
      <div class="game-grid">
        <div v-for="game in hotGames.records.slice(0, 6)" :key="game.id" class="game-card" @click="goToGameDetail(game.id)">
          <div class="game-cover">
            <img :src="game.coverImage || 'https://via.placeholder.com/200x266?text=No+Image'" :alt="game.name">
          </div>
          <div class="game-info">
            <h3>{{ game.name }}</h3>
            <p class="current-price">¥{{ game.price != null ? Number(game.price).toFixed(2) : '--' }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getGameList, getFeaturedGames, getGameCategories, getUpcomingGames } from '@/api/game'

export default {
  name: 'HomePage',
  setup() {
    const router = useRouter()
    const categories = ref([])
    const banners = ref([
      { id: 1, title: '育碧佳作 限时闪促！', description: '精选游戏低至1折起', imageUrl: 'https://cdn.sonkwo.cn/cms/assets/cms_banner_v2_f8e81119.jpg' },
      { id: 2, title: '史低游戏', description: '超多史低游戏等你来！', imageUrl: 'https://cdn.sonkwo.cn/cms/assets/cms_banner_v2_f8e81119.jpg' }
    ])
    const featuredGames = ref({ records: [], total: 0 })
    const upcomingGames = ref([])
    const promotionGames = ref({ records: [], total: 0 })
    const hotGames = ref({ records: [], total: 0 })

    const loadCategories = async () => {
      try {
        const res = await getGameCategories()
        if (res.code === 200) {
          categories.value = res.data
        }
      } catch (error) {
        console.error('获取分类失败:', error)
      }
    }

    const loadFeaturedGames = async () => {
      try {
        const res = await getFeaturedGames({ page: 1, size: 6 })
        featuredGames.value.records = res.records
        featuredGames.value.total = res.total
      } catch (error) {
        console.error('获取推荐游戏失败: 捕获到错误', error)
      }
    }

    const loadUpcomingGames = async () => {
      try {
        const res = await getUpcomingGames()
        upcomingGames.value = res
      } catch (error) {
        console.error('获取即将发售游戏失败: 捕获到错误', error)
      }
    }

    const loadPromotionGames = async () => {
      try {
        const res = await getGameList({
          page: 1,
          size: 6,
          sortBy: 'price',
          sortOrder: 'asc'
        })
        if (res.code === 200) {
          promotionGames.value.records = res.records.map(game => ({
            ...game,
            discount: Math.floor(Math.random() * (70 - 10 + 1)) + 10,
            originalPrice: game.price,
            price: Number(((game.price != null ? Number(game.price) : 0) * (1 - (Math.floor(Math.random() * (70 - 10 + 1)) + 10) / 100)).toFixed(2))
          }))
          promotionGames.value.total = res.total
        }
      } catch (error) {
        console.error('获取促销游戏失败:', error)
      }
    }

    const loadHotGames = async () => {
      try {
        const res = await getGameList({
          page: 1,
          size: 6,
          sortBy: 'createdAt',
          sortOrder: 'desc' 
        })
        if (res.code === 200) {
          hotGames.value.records = res.records
          hotGames.value.total = res.total
        }
      } catch (error) {
        console.error('获取热门游戏失败:', error)
      }
    }

    const loadData = async () => {
      try {
        await Promise.all([
          loadCategories(),
          loadFeaturedGames(),
          loadUpcomingGames(),
          loadPromotionGames(),
          loadHotGames()
        ])
      } catch (error) {
        console.error('加载数据失败:', error)
      }
    }

    const goToGameDetail = (id) => {
      router.push(`/game/${id}`)
    }

    const goToCategory = (id) => {
      router.push(`/category/${id}`)
    }

    const formatDate = (dateString) => {
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      if (!dateString) return '待定'
      try {
        return new Date(dateString).toLocaleDateString('zh-CN', options)
      } catch (e) {
        console.error("日期格式化错误:", dateString, e)
        return '格式错误'
      }
    }

    const goToMore = (type) => {
      let query = {};
      if (type === 'featured') {
        query = { isFeatured: true };
      } else if (type === 'upcoming') {
        query = { status: 2 };
      } else if (type === 'promotion') {
        query = { sortBy: 'price', sortOrder: 'asc', hasDiscount: true };
      } else if (type === 'hot') {
        query = { sortBy: 'createdAt', sortOrder: 'desc' };
      }
      router.push({ path: '/games', query });
    };

    onMounted(() => {
      loadData()
    })

    return {
      categories,
      banners,
      featuredGames,
      upcomingGames,
      promotionGames,
      hotGames,
      goToGameDetail,
      goToCategory,
      formatDate,
      goToMore
    }
  }
}
</script>

<style lang="scss" scoped>
.home-page {
  background-color: #1a1a1a;
  color: #e0e0e0;
  padding: 20px 0;
  min-height: calc(100vh - 60px - 200px);
  max-width: 1400px;
  margin: 0 auto;

  .category-nav {
    margin-bottom: 30px;
    padding: 0 20px;

    .category-list {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;

      .category-item {
        padding: 8px 16px;
        background: #2a2a2a;
        border-radius: 4px;
        cursor: pointer;
        white-space: nowrap;
        transition: all 0.3s;
        border: 1px solid #333;

        &:hover {
          background: #3a3a3a;
          border-color: #409eff;
          color: #409eff;
        }
      }
    }
  }

  .banner-section {
    margin-bottom: 40px;
    border-radius: 8px;
    overflow: hidden;

    .banner-item {
      height: 100%;
      background-size: cover;
      background-position: center;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: flex-start;
      padding-left: 80px;
      
      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(to right, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.2));
      }

      .banner-content {
        position: relative;
        z-index: 1;
        color: #fff;
        max-width: 600px;

        .banner-title {
          font-size: 42px;
          margin-bottom: 10px;
          font-weight: bold;
          text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .banner-description {
          font-size: 18px;
          margin-bottom: 25px;
          line-height: 1.6;
        }

        .view-detail-btn {
          background-color: #409eff;
          border-color: #409eff;
          color: #fff;
          padding: 12px 30px;
          font-size: 18px;
          border-radius: 5px;
          transition: background-color 0.3s, border-color 0.3s;

          &:hover {
            background-color: #66b1ff;
            border-color: #66b1ff;
          }
        }
      }
    }
  }

  .section {
    margin-bottom: 50px;
    padding: 0 20px;

    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;

      h2 {
        font-size: 28px;
        font-weight: 700;
        color: #fff;
        border-left: 4px solid #409eff;
        padding-left: 15px;
      }

      .more-btn {
        color: #a0a0a0;
        font-size: 16px;
        &:hover {
          color: #409eff;
        }
      }
    }

    .game-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 25px;

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
          padding-top: 133%;
          overflow: hidden;

          img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
          }

          .discount-tag,
          .release-date-tag {
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

          .release-date-tag {
            background: #409eff;
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
  }
}
</style> 