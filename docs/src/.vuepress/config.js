const { description } = require('../../package')

module.exports = {
    /**
     * Ref：https://v1.vuepress.vuejs.org/config/#title
     */
    title: 'FlutterFeatherjs',
    /**
     * Ref：https://v1.vuepress.vuejs.org/config/#description
     */
    description: description,

    /**
     * Extra tags to be injected to the page HTML `<head>`
     *
     * ref：https://v1.vuepress.vuejs.org/config/#head
     */
    head: [
        ['meta', { name: 'theme-color', content: '#3eaf7c' }],
        ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
        ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
        ['link', { rel: 'icon', href: '/assets/img/logo.png' }]
    ],

    base: '/flutter_feathersjs.dart/',
    /**
     * Theme configuration, here is the default theme configuration for VuePress.
     *
     * ref：https://v1.vuepress.vuejs.org/theme/default-theme-config.html
     */
    themeConfig: {
        repo: '',
        editLinks: false,
        docsDir: '',
        editLinkText: '',
        lastUpdated: true,
        nav: [{
                text: 'Guide',
                link: '/guide/',
            },
            {
                text: 'Github',
                link: 'https://github.com/Dahkenangnon/flutter_feathersjs.dart'
            },
            {
                text: 'Pub.Dev',
                link: 'https://pub.dev/packages/flutter_feathersjs'
            }
        ],
        sidebar: {
            '/guide/': [{
                title: 'Guide',
                collapsable: true,
                children: [
                    '',
                    'installation',
                    'authentication',
                    'using-rest',
                    'using-socketio',
                    'how-to-upload-file',
                    'listening-event',
                    'examples'
                ]
            }, ],
        }
    },

    /**
     * Apply plugins，ref：https://v1.vuepress.vuejs.org/zh/plugin/
     */
    plugins: [
        '@vuepress/plugin-back-to-top',
        '@vuepress/plugin-medium-zoom',
    ]
}