# Alexa-To-AI_Flutter

## 目的
AlexaがAI(ChatGPTなど)と接続する際、ユーザーがAIの口調などを任意に設定できるようにする

## 前提
1. Flutterで開発しているので、以下でFlutterをinstallしてください  
[Install Flutter](https://docs.flutter.dev/get-started/install)

2. FVMをインストール
    ```sh
    brew tap leoafarias/fvm
    brew install fvm

    # 以下でバージョンが表示されたらOK
    fvm --version
    ```

## プロジェクトのclone後
ルートフォルダで以下を実行
```sh
fvm use 3.19.6
fvm flutter pub get
```
