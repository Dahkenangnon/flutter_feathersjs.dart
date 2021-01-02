module.exports = {
    themeConfig: {
        logo: '/assets/img/logo.png',
    },
    plugins: ['@vuepress/nprogress', ['@vuepress/search', {
        searchMaxSuggestions: 10
    }]]
}