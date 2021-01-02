module.exports = {
    themeConfig: {
        logo: '/assets/img/logo.png',
    },
    plugins: ['@vuepress/nprogress', ['@vuepress/search', {
        searchMaxSuggestions: 10
    }]],
    publicPath: process.env.NODE_ENV === 'production' ?
        '/flutter_feathersjs.dart/' :
        '/'
}