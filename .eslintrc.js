/*
Required modules for this config:
npm install\
  eslint\
  eslint-config-airbnb\
  eslint-plugin-import\
  eslint-plugin-jsx-a11y\
  eslint-plugin-react\
  eslint-plugin-flowtype\
  eslint-plugin-babel\
  babel-eslint
*/
module.exports = {
  "parser": "babel-eslint",
  "env": {
    "browser": true,
    "commonjs": true,
    "node": true,
    "es6": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaFeatures": {
      "experimentalObjectRestSpread": true,
      "classes": true,
      "jsx": true
    },
    "sourceType": "module"
  },
  "plugins": [
    "react",
    "flowtype",
    "babel"
  ],
  "rules": {
    "no-console": 0,
    "no-trailing-spaces": 2,
    "no-unused-vars": [
      "warn",
      {
        "varsIgnorePattern": "React"
      }
    ],
    "react/jsx-uses-vars": 2,
    "indent": [
      "warn",
      2,
      { "SwitchCase": 1 }
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "warn",
      "single"
    ],
    "flowtype/semi": [
      "warn",
      "never"
    ],
    "babel/semi": [
      "warn",
      "never"
    ],
    "semi": [
      "warn",
      "never"
    ]
  }
};
