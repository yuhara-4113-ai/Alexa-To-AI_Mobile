import 'package:flutter_dotenv/flutter_dotenv.dart';

final String amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "${dotenv.env['COGNITO_POOL_ID']}",
                        "AppClientId": "${dotenv.env['COGNITO_APP_CLIENT_ID']}",
                        "Region": "${dotenv.env['COGNITO_REGION']}"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "${dotenv.env['COGNITO_WEB_DOMAIN']}",
                            "AppClientId": "${dotenv.env['COGNITO_APP_CLIENT_ID']}",
                            "SignInRedirectURI": "${dotenv.env['COGNITO_SIGNIN_REDIRECT_URI']}",
                            "SignOutRedirectURI": "${dotenv.env['COGNITO_SIGNOUT_REDIRECT_URI']}",
                            "Scopes": [
                                "openid",
                                "profile"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [
                            "AMAZON"
                        ],
                        "usernameAttributes": [],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": []
                    }
                }
            }
        }
    }
}''';
