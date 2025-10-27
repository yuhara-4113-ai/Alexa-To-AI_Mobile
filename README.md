# Alexa-To-AI Mobile

<p align="center">
  <img src="assets/images/app_icon.png" width="120" alt="Alexa-To-AI Logo" />
</p>

## 📱 概要

Alexa-To-AI Mobileは、Amazon AlexaとAI（ChatGPT、Claude、Google Geminiなど）を連携させる際に、AIの口調やパーソナリティをカスタマイズできるFlutterアプリケーションです。

ユーザーはこのアプリを通じて、各AIサービスの設定を細かく調整し、Alexaを通じてより自然で個性的な対話体験を実現できます。

## ✨ 主な機能

- 🤖 **複数のAIサービス対応**
  - OpenAI (ChatGPT)
  - Anthropic (Claude)
  - Google Generative AI (Gemini)

- 🎨 **カスタマイズ可能な設定**
  - AIの口調やパーソナリティの設定
  - モデルの選択とパラメータ調整
  - カスタムプロンプトの設定

- 🔐 **セキュアな認証**
  - AWS Cognito を使用したソーシャルログイン
  - 生体認証（指紋認証・顔認証）対応
  - クラウドストレージへの設定の安全な保存

- 💾 **ローカルデータ管理**
  - Hiveを使用した高速なローカルストレージ
  - オフラインでの設定管理

- 🌓 **ダークモード対応**
  - システム設定に応じた自動切り替え
  - 目に優しいUI

## 🛠 技術スタック

- **フレームワーク**: Flutter 3.35.7
- **言語**: Dart 3.2.0以上
- **状態管理**: Riverpod + BLoC パターン
- **ローカルDB**: Hive
- **認証**: AWS Amplify (Cognito)
- **UIコンポーネント**: Material Design
- **フォント**: Noto Sans JP

### 主要な依存パッケージ

- `flutter_riverpod`: 状態管理
- `flutter_bloc`: BLoCパターンの実装
- `amplify_flutter`: AWS Amplifyとの連携
- `openai_dart`: OpenAI API
- `google_generative_ai`: Google Gemini API
- `local_auth`: 生体認証
- `hive`: ローカルストレージ
- `flutter_chat_ui`: チャットUIコンポーネント

## 📋 前提条件

### 必須
- macOS、Windows、または Linux
- Git
- FVM (Flutter Version Management)

### 推奨
- エディタ: Visual Studio Code または Android Studio
- 実機またはエミュレータ（iOS/Android）

## 🚀 セットアップ

### 1. FVMのインストール

#### macOS / Linux (Homebrewを使用)
```sh
brew tap leoafarias/fvm
brew install fvm

# インストール確認
fvm --version
```

#### macOS / Linux (Bashスクリプトを使用)
```sh
curl -fsSL https://fvm.app/install.sh | bash

# インストール確認
fvm --version
```

#### Windows (Chocolateyを使用)
```powershell
choco install fvm

# インストール確認
fvm --version
```

### 2. プロジェクトのクローン

```sh
git clone https://github.com/yuhara-4113-ai/Alexa-To-AI_Mobile.git
cd Alexa-To-AI_Mobile
```

### 3. Flutterバージョンの設定

```sh
# プロジェクトで指定されたFlutterバージョン（3.35.7）をインストール
fvm install 3.35.7

# プロジェクトでFlutter 3.35.7を使用
fvm use 3.35.7
```

### 4. 依存パッケージのインストール

```sh
fvm flutter pub get
```

### 5. 環境変数の設定

プロジェクトルートに `.env` ファイルを作成し、AWS関連の設定を記述します：

```env
# AWS API Gateway設定
OPEN_API_KEY=your_aws_api_gateway_key_here
AWS_X_API_KEY=your_aws_x_api_key_here
SAVE_AI_SETTING_URL=your_save_ai_setting_url_here

# AWS Cognito設定
COGNITO_POOL_ID=your_cognito_pool_id_here
COGNITO_APP_CLIENT_ID=your_cognito_app_client_id_here
COGNITO_REGION=your_cognito_region_here
COGNITO_WEB_DOMAIN=your_cognito_web_domain_here
COGNITO_SIGNIN_REDIRECT_URI=your_signin_redirect_uri_here
COGNITO_SIGNOUT_REDIRECT_URI=your_signout_redirect_uri_here
```

⚠️ **注意**: 
- `.env` ファイルは `.gitignore` に含まれているため、コミットされません
- OpenAI、Google AI、AnthropicのAPIキーは、アプリの設定画面から入力します

### 6. コード生成（必要な場合）

Hiveのアダプターなど、自動生成されるコードがある場合は以下を実行：

```sh
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## 🏃 実行方法

### デバッグモードで実行

```sh
# 接続されているデバイスを確認
fvm flutter devices

# アプリを実行
fvm flutter run
```

### リリースビルド

#### Android
```sh
fvm flutter build apk --release
# または
fvm flutter build appbundle --release
```

#### iOS
```sh
fvm flutter build ios --release
```

## 🏗 プロジェクト構造

```
lib/
├── app/                    # アプリケーション全体の設定
│   ├── navigation/        # ナビゲーション関連
│   └── theme/            # テーマ設定
├── core/                  # コア機能
│   └── config/           # 環境設定
├── features/             # 機能ごとのモジュール
│   ├── authentication/   # 認証機能
│   └── settings/         # 設定機能
│       ├── data/        # データレイヤー
│       ├── domain/      # ドメインレイヤー
│       └── presentation/ # プレゼンテーションレイヤー
├── shared/              # 共通コンポーネント
│   └── widgets/        # 再利用可能なウィジェット
└── main.dart           # エントリーポイント
```

### アーキテクチャ

本プロジェクトは **Clean Architecture** の原則に基づいて設計されています：

- **Presentation Layer**: UI とユーザーインタラクション
- **Domain Layer**: ビジネスロジックとモデル
- **Data Layer**: データの取得と永続化

状態管理には **Riverpod** と **BLoC パターン** を組み合わせて使用しています。

## 🔧 開発ワークフロー

### ブランチ戦略

- `main`: 本番環境用の安定版
- `develop`: 開発用のメインブランチ
- `feature/*`: 新機能開発用
- `bugfix/*`: バグ修正用
- `hotfix/*`: 緊急修正用

### コーディング規約

```sh
# コード解析
fvm flutter analyze

# フォーマット
fvm flutter format lib/ test/
```

プロジェクトでは `analysis_options.yaml` で定義されたルールに従ってください。

## 🐛 トラブルシューティング

### FVMでFlutterバージョンが切り替わらない

```sh
# FVMのキャッシュをクリア
fvm list
fvm install 3.35.7
fvm use 3.35.7 --force
```

### 依存関係のエラー

```sh
# pubキャッシュをクリア
fvm flutter pub cache clean
fvm flutter pub get
```

### ビルドエラー

```sh
# クリーンビルド
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS固有の問題

```sh
cd ios
pod install
cd ..
```

## 📝 コントリビューション

プルリクエストを歓迎します！以下の手順で貢献してください：

1. このリポジトリをフォーク
2. 新しいブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

### コントリビューションガイドライン

- コードは必ずテストを含める
- `flutter analyze` でエラーがないことを確認
- `flutter format` でコードをフォーマット
- コミットメッセージは明確に記述

## 📄 ライセンス

このプロジェクトは [MIT License](LICENSE) の下でライセンスされています。

### 依存ライブラリのライセンス

本プロジェクトは以下のオープンソースライブラリを使用しており、それぞれのライセンスに従います：

- **MIT License**: flutter_riverpod, openai_dart, equatable, logger など
- **Apache 2.0**: hive, amplify_flutter, google_fonts, google_generative_ai, flutter_chat_ui など
- **BSD-3-Clause**: flutter_bloc, http, local_auth など

これらのライセンスは全てMIT Licenseと互換性があります。

## 👥 開発者

Maintained by [yuhara-4113-ai](https://github.com/yuhara-4113-ai)

## 🔗 関連リンク

- [Flutter公式ドキュメント](https://docs.flutter.dev/)
- [FVM公式サイト](https://fvm.app/)
- [AWS Amplify Flutter](https://docs.amplify.aws/lib/q/platform/flutter/)
- [OpenAI API ドキュメント](https://platform.openai.com/docs)
- [Google AI Studio](https://ai.google.dev/)
- [Anthropic API ドキュメント](https://docs.anthropic.com/)

---

## 📞 サポート

問題が発生した場合は、[Issues](https://github.com/yuhara-4113-ai/Alexa-To-AI_Mobile/issues) セクションで報告してください。
