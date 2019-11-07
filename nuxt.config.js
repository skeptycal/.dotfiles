export default {
    mode: 'universal',
    /*
     ** Headers of the page
     */
    head: {
        title: process.env.npm_package_name || '',
        meta: [
            {
                'http-equiv': 'content-type',
                content: 'text/html',
            },
            { charset: 'utf-8' },
            { 
                name: 'viewport', 
                content: 'width=device-width, initial-scale=1' 
            },
            {
                hid: 'description',
                name: 'description',
                content: process.env.npm_package_description || ''
            },
            {
                property: 'og:title',
                content: 'Michael Treanor',
            },
            {
                name: 'og:description',
                property: 'og:description',
                content: 'Michael Treanor is a creative software developer focused on data science, python, dev tools.',
            },
            {
                property: 'og:url',
                content: 'https://www.skeptycal.com',
            },
            {
                property: 'og:image:secure_url',
                content: 'https://en.gravatar.com/userimage/20578593/68f0ec70ffec7aba965e4da3d1ac272e.png',
            },
            {
                property: 'og:image:alt',
                content: 'Profile Picture for Michael Treanor',
            },
            {
                name: 'twitter:card',
                content: 'summary',
            },
            {
                name: 'twitter:site',
                content: '@skeptycal',
            },
            {
                name: 'twitter:title',
                content: 'Michael Treanor',
            },
            {
                name: 'twitter:description',
                content: 'Michael Treanor is a creative software developer focused on data science, python, dev tools.',
            },
        ],
        link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }]
    },
    /*
     ** Customize the progress-bar color
     */
    loading: { color: '#fff' },
    /*
     ** Global CSS
     */
    css: [],
    /*
     ** Plugins to load before mounting the App
     */
    plugins: [],
    /*
     ** Nuxt.js dev-modules
     */
    buildModules: [],
    /*
     ** Nuxt.js modules
     */
    modules: [
        // Doc: https://bootstrap-vue.js.org
        'bootstrap-vue/nuxt',
        '@nuxtjs/pwa'
    ],
    /*
     ** Build configuration
     */
    build: {
        /*
         ** You can extend webpack config here
         */
        extend(config, ctx) {}
    }
}