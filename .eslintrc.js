module.exports = {
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
        "quotes": [
            2,
            "double"
        ],
        "linebreak-style": [
            2,
            "unix"
        ],
        "semi": [
            2,
            "always"
        ]
    },
    "env": {
        "browser": true
    },
    "extends": "eslint:recommended"
};
