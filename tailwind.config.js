module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  daisyui: {
    darkTheme: false, // ダークモードをONにする場合は削除
    themes: [
      {
        mytheme: {
          "primary": "#617b47",
          "secondary": "#f87d08",
          "accent": "#f6b827",
          "neutral": "#48350e",
          "base-100": "#ffffff",
          "info": "#8DBA30",
          "success": "#30b1ba",
          "warning": "#f6b827",
          "error": "#f84c08",
        },
      },
    ],
  },
}
