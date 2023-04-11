module.exports = {
    "extends": [
        "eslint:recommended"
    ],
    "env": {
        es6: true,
        browser: true,
        node: true,
        jquery: true,
    },
    "globals": {
        "define": "readonly",
        "require": "readonly"
    },
    "rules": {
        "indent": [
            2,
            4,
            {
                "CallExpression": {
                    "arguments": "off",
                }
            },
        ],
        "quotes": "off",
        "linebreak-style": [
            2,
            "unix"
        ],
        "semi": [
            2,
            "always"
        ],
        "react/display-name": 1,
        "react/forbid-prop-types": 1,
        "react/jsx-boolean-value": 1,
        "react/jsx-closing-bracket-location": 1,
        "react/jsx-curly-spacing": 1,
        "react/jsx-handler-names": 1,
        "react/jsx-indent-props": 1,
        "react/jsx-key": 1,
        // "react/jsx-max-props-per-line": 1,
        // "react/jsx-no-bind": 1,
        "react/jsx-no-duplicate-props": 1,
        // "react/jsx-no-literals": 1,
        "react/jsx-no-undef": 1,
        "react/jsx-pascal-case": 1,
        // "react/jsx-quotes": 1,
        // "react/jsx-sort-prop-types": 1,
        // "react/jsx-sort-props": 1,
        "react/jsx-uses-react": 1,
        "react/jsx-uses-vars": 1,
        "react/no-danger": 1,
        "react/no-did-mount-set-state": 1,
        "react/no-did-update-set-state": 1,
        "react/no-direct-mutation-state": 1,
        "react/no-multi-comp": 1,
        "react/no-set-state": 1,
        "react/no-unknown-property": 1,
        "react/prefer-es6-class": 1,
        // "react/prop-types": 1,
        "react/react-in-jsx-scope": 1,
        // "react/require-extension": 1,
        "react/self-closing-comp": 1,
        "react/sort-comp": 1,
        // "react/wrap-multilines": 1
    },
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true,
            "modules": true
        },
        "sourceType": "module"
    },
    "settings": {
        "react": {
            "createClass": "createReactClass", // Regex for Component Factory to use,
            // default to "createReactClass"
            "pragma": "React",  // Pragma to use, default to "React"
            "version": "detect", // React version. "detect" automatically picks the version you have installed.
            // You can also use `16.0`, `16.3`, etc, if you want to override the detected value.
            // default to latest and warns if missing
            // It will default to "detect" in the future
            "flowVersion": "0.53" // Flow version
        }
    }
};
