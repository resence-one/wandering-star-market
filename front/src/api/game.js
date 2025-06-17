import request from '@/utils/request'

// 获取游戏列表
export function getGameList(params) {
  return request({
    url: '/game/list',
    method: 'get',
    params
  })
}

// 获取游戏详情
export function getGameDetail(id) {
  return request({
    url: `/game/${id}/detail`,
    method: 'get'
  })
}

// 获取推荐游戏
export function getFeaturedGames(params) {
  return request({
    url: '/game/featured',
    method: 'get',
    params
  })
}

// 获取游戏分类列表
export function getGameCategories() {
  return request({
    url: '/category/list',
    method: 'get'
  })
}

// 获取分类详情
export function getCategoryDetail(id) {
  return request({
    url: `/category/${id}`,
    method: 'get'
  })
}

// 获取热门游戏（模拟）
export function getHotGames(params) {
  return request({
    url: '/game/list',
    method: 'get',
    params: { ...params, sortBy: 'popularity', sortOrder: 'desc' }
  })
}

// 获取即将发售的游戏（模拟）
export function getUpcomingGames(params) {
  return request({
    url: '/game/list',
    method: 'get',
    params: { ...params, sortBy: 'releaseDate', sortOrder: 'asc' }
  })
}

// 获取促销游戏（模拟）
export function getPromotionGames(params) {
  return request({
    url: '/game/list',
    method: 'get',
    params: { ...params, sortBy: 'price', sortOrder: 'asc' }
  })
}

